import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api.dart';

class EmployeeOrdersScreen extends StatefulWidget {
  const EmployeeOrdersScreen({super.key});

  @override
  State<EmployeeOrdersScreen> createState() => _EmployeeOrdersScreenState();
}

class _EmployeeOrdersScreenState extends State<EmployeeOrdersScreen> {
  List orders = [];
  bool loading = true;

  final Color bg = const Color(0xFF0D0D0D);
  final Color card = const Color(0xFF1A1A1A);
  final Color main = const Color(0xFF5C7AFF);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final res = await Api.dio.get('/orders');
    setState(() {
      orders = res.data;
      loading = false;
    });
  }

  Future<void> _downloadOrder(String id) async {
    final url = "http://10.0.2.2:4000/api/orders/$id/export";
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Could not open download link.")),
      );
    }
  }

  Future<void> _upload(String id) async {
    final pick = await FilePicker.platform.pickFiles();
    if (pick == null) return;

    final filePath = pick.files.single.path!;
    final fileName = pick.files.single.name;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      await Api.dio.post(
        '/orders/$id/upload',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ File uploaded successfully')),
        );
      }
      _load();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Upload failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('All Orders', style: TextStyle(color: Colors.white)),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (_, i) {
                  final o = orders[i];
                  final clientName = o['contact']?['fullName'] ??
                      o['client']?['name'] ??
                      "CV Order";
                  final email = o['contact']?['email'] ?? '';
                  final status = o['status'] ?? 'pending';

                  return Card(
                    color: card,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                status == 'complete'
                                    ? Icons.check_circle
                                    : Icons.pending_actions,
                                color:
                                    status == 'complete' ? Colors.green : main,
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  clientName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Text(
                            email,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 13),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Download button
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => _downloadOrder(o['_id']),
                                  icon: const Icon(Icons.download,
                                      color: Colors.white),
                                  label: const Text(
                                    "Download",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: main, width: 1.3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // Upload button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _upload(o['_id']),
                                  icon: const Icon(Icons.upload,
                                      color: Colors.white),
                                  label: const Text("Upload"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: main,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

