import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
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
    final res = await Api.dio.get('/orders/mine');
    setState(() {
      orders = res.data;
      loading = false;
    });
  }

  Future<void> _download(String fileUrl) async {
    final url = "http://10.0.2.2:4000$fileUrl";
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    "No orders yet.",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    itemBuilder: (_, i) {
                      final o = orders[i];
                      final status = (o["status"] as String).toLowerCase();
                      final fullName =
                          o["contact"]?["fullName"] ?? "CV Order";
                      final deliverableUrl = o["deliverableUrl"];

                      return Card(
                        color: card,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    status == "complete"
                                        ? Icons.check_circle
                                        : Icons.pending,
                                    color: status == "complete"
                                        ? Colors.green
                                        : main,
                                    size: 26,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      fullName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Status: ${status.toUpperCase()}",
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),

                              const SizedBox(height: 14),

                              // Actions buttons
                              if (status == "complete" &&
                                  deliverableUrl != null)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _download(deliverableUrl),
                                    icon: const Icon(Icons.download,
                                        color: Colors.white),
                                    label: const Text(
                                      "Download Final File",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: main,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const Text(
                                  "Pending — Deliverable not uploaded yet",
                                  style: TextStyle(
                                      color: Colors.white54, fontSize: 13),
                                ),
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

