import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: kIsWeb
          ? 'http://127.0.0.1:4000/api' // 💻 للـ Web
          : 'http://10.0.2.2:4000/api', // 📱 للمحاكي أو الجهاز
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// ✅ إضافة أو إزالة التوكن في كل الطلبات
  static void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      dio.options.headers.remove('Authorization');
    } else {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 AUTHENTICATION
  // ---------------------------------------------------------------------------

  static Future<Response> register(Map<String, dynamic> data) async {
    try {
      final res = await dio.post('/auth/register', data: data);
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Registration failed');
    }
  }

  static Future<Response> login(String email, String password) async {
    try {
      final res = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  static Future<Response> me() async {
    try {
      final res = await dio.get('/auth/me');
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch profile');
    }
  }

  // ---------------------------------------------------------------------------
  // 🔹 ORDERS
  // ---------------------------------------------------------------------------

  static Future<Response> createOrder(Map<String, dynamic> data) async {
    try {
      final res = await dio.post('/orders', data: data);
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to create order');
    }
  }

  static Future<Response> getMyOrders() async {
    try {
      final res = await dio.get('/orders/mine');
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch orders');
    }
  }

  static Future<Response> getAllOrders() async {
    try {
      final res = await dio.get('/orders');
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch all orders');
    }
  }

  // ---------------------------------------------------------------------------
  // ⬆️ رفع ملف (يدعم Web + Mobile)
  // ---------------------------------------------------------------------------

  static Future<Response> uploadCompletedFile(
    String orderId,
    String filePath, {
    List<int>? fileBytes,
    String? fileName,
  }) async {
    try {
      late FormData formData;

      if (kIsWeb && fileBytes != null && fileName != null) {
        formData = FormData.fromMap({
          'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
        });
      } else {
        formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath),
        });
      }

      final res = await dio.post('/orders/$orderId/upload', data: formData);
      return res;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to upload file');
    }
  }

  // ---------------------------------------------------------------------------
  // ✅ تحميل الملف النهائي (يعمل على الموبايل والويب)
  // ---------------------------------------------------------------------------

  static Future<void> downloadDeliverableFile(String relativeUrl) async {
    try {
      final baseUrl = dio.options.baseUrl.replaceAll('/api', '');
      final tokenHeader = dio.options.headers['Authorization'];
      String? token;

      if (tokenHeader is String && tokenHeader.startsWith('Bearer ')) {
        token = tokenHeader.substring(7);
      }

      final fullUrl = '$baseUrl$relativeUrl${token != null ? '?token=$token' : ''}';

      if (kIsWeb) {
        // 🌐 للويب: افتح الرابط مباشرة بالمتصفح
        if (!await launchUrl(Uri.parse(fullUrl), mode: LaunchMode.externalApplication)) {
          throw Exception('Could not open download URL');
        }
      } else {
        // 📱 للموبايل أو المحاكي: نزّل الملف وافتحه
        final res = await dio.get(
          fullUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = res.data;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/${relativeUrl.split('/').last}');
        await file.writeAsBytes(bytes);
        await OpenFilex.open(file.path);
      }
    } catch (e) {
      throw Exception('❌ Failed to download file: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // 💾 تحميل بيانات الطلب كـ Text File (يدعم Web + Mobile)
  // ---------------------------------------------------------------------------

  static Future<void> downloadOrderText(String orderId) async {
    try {
      final res = await dio.get(
        '/orders/$orderId/export',
        options: Options(responseType: ResponseType.bytes),
      );

      if (kIsWeb) {
        // 🌐 افتح الرابط مباشرة في الويب
        final baseUrl = dio.options.baseUrl.replaceAll('/api', '');
        final fullUrl = '$baseUrl/orders/$orderId/export';
        if (!await launchUrl(Uri.parse(fullUrl), mode: LaunchMode.externalApplication)) {
          throw Exception('Could not open file URL');
        }
      } else {
        // 📱 على المحاكي أو الهاتف
        final bytes = res.data;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/order-$orderId.txt');
        await file.writeAsBytes(bytes);
        await OpenFilex.open(file.path);
      }
    } catch (e) {
      throw Exception('❌ Failed to download order text file: $e');
    }
  }
}






