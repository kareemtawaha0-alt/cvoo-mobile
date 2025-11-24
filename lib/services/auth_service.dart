import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api.dart';
import '../client/client_home.dart';
import '../employee/employee_home.dart';

class AuthService {
  final _s = const FlutterSecureStorage();
  Future<Map> login(String email,String password) async {
    final res = await Api.dio.post('/auth/login', data:{'email':email,'password':password});
    await _s.write(key:'token', value: res.data['token']);
    await _s.write(key:'role', value: res.data['user']['role']);
    await _s.write(key:'userId', value: res.data['user']['id']);
    Api.dio.options.headers['Authorization'] = 'Bearer ${res.data['token']}';
    return res.data;
  }
  Future<void> boot() async {
    final t = await _s.read(key:'token');
    if(t!=null){ Api.dio.options.headers['Authorization']='Bearer $t'; }
  }
}