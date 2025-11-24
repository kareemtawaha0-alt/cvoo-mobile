import 'dart:io' show File;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';

class EmployeeTasksScreen extends StatefulWidget {
  const EmployeeTasksScreen({super.key});

  @override
  State<EmployeeTasksScreen> createState() => _EmployeeTasksScreenState();
}

class _EmployeeTasksScreenState extends State<EmployeeTasksScreen> {
  bool loading = true;
  List<dynamic> tasks = [];

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color cardColor = const Color(0xFF1A1A1A);
  final Color mainColor = const Color(0xFF5C7AFF);

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      setState(() => loading = true);
      final res = await ApiService.getAllOrders();
      setState(() {
        tasks = res.data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to load tasks: $e')),
      );
    }
  }

  void _openTask(dynamic order) {
    final details = order['details'];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cardColor,
        title: Text(
          order['description'] ?? 'Task Details',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            details != null ? details.toString() : 'No details provided.',
            style: const TextStyle(color: Colors.white70),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: mainColor)),
          )
        ],
      ),
    );
  }

  Future<void> _downloadClientInfo(String orderId) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⬇️ Downloading client info...')),
      );

      await ApiService.downloadOrderText(orderId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Client info downloaded successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed: $e')),
      );
    }
  }

  Future<void> _uploadDeliverable(String orderId) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );
      if (result == null) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⬆️ Uploading file...')),
      );

      if (kIsWeb) {
        final bytes = result.files.single.bytes;
        final name = result.files.single.name;

        if (bytes == null) throw Exception("Missing file bytes");

        final form = FormData.fromMap({
          "file": MultipartFile.fromBytes(bytes, filename: name),
        });

        await ApiService.dio.post("/orders/$orderId/upload", data: form);
      } else {
        final path = result.files.single.path;
        if (path == null) throw Exception("Missing file path");
        await ApiService.uploadCompletedFile(orderId, path);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ File uploaded successfully!')),
      );

      _loadTasks();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: $e')),
      );
    }
  }

  Future<void> _downloadFinalFile(String fileUrl) async {
    try {
      final base = ApiService.dio.options.baseUrl.replaceAll('/api', '');
      final link = "$base$fileUrl";

      if (kIsWeb) {
        await launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
      } else {
        await OpenFilex.open(link);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to open file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          'No pending tasks yet.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTasks,
      backgroundColor: cardColor,
      color: mainColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final order = tasks[i];
          final status = order['status'] ?? "pending";
          final client = order['client']?['name'] ?? "Unknown";
          final deliverable = order['deliverableUrl'];

          return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(14),
              leading: Icon(
                status == "complete" ? Icons.check_circle : Icons.work_history_outlined,
                color: status == "complete" ? Colors.greenAccent : mainColor,
                size: 28,
              ),
              title: Text(
                order["description"] ?? "CV Request",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                "Client: $client\nStatus: ${status.toUpperCase()}",
                style: const TextStyle(color: Colors.white70, height: 1.3),
              ),
              trailing: PopupMenuButton<String>(
                color: cardColor,
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  if (value == "view") _openTask(order);
                  if (value == "download-info") _downloadClientInfo(order['_id']);
                  if (value == "upload") _uploadDeliverable(order['_id']);
                  if (value == "download" && deliverable != null) {
                    _downloadFinalFile(deliverable);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Text('View Details', style: TextStyle(color: mainColor)),
                  ),
                  PopupMenuItem(
                    value: 'download-info',
                    child: Text('Download Client Info', style: TextStyle(color: mainColor)),
                  ),
                  if (status == 'pending')
                    PopupMenuItem(
                      value: 'upload',
                      child: Text('Upload Completed File', style: TextStyle(color: mainColor)),
                    ),
                  if (deliverable != null)
                    PopupMenuItem(
                      value: 'download',
                      child: Text('Download Final File', style: TextStyle(color: mainColor)),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}





