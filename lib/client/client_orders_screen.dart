import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClientOrdersScreen extends StatefulWidget {
  const ClientOrdersScreen({super.key});

  @override
  State<ClientOrdersScreen> createState() => _ClientOrdersScreenState();
}

class _ClientOrdersScreenState extends State<ClientOrdersScreen> {
  bool loading = true;
  List<dynamic> orders = [];

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color cardColor = const Color(0xFF1A1A1A);
  final Color mainColor = const Color(0xFF5C7AFF);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      setState(() => loading = true);
      final res = await ApiService.getMyOrders();
      setState(() {
        orders = (res.data as List?) ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders: $e')),
      );
    }
  }

  Future<void> _download(String? url) async {
    if (url == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No file available yet')),
      );
      return;
    }
    try {
      await ApiService.downloadDeliverableFile(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download file: $e')),
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

    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders yet',
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return RefreshIndicator(
      color: mainColor,
      onRefresh: _load,
      child: Container(
        color: bgColor,
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (_, i) {
            final o = orders[i] as Map<String, dynamic>;
            final status = (o['status'] ?? 'pending').toString();
            final desc = (o['description'] ?? 'CV Order').toString();
            final deliverableUrl = o['deliverableUrl'] as String?;

            final bool isDone = status == 'complete';

            return Card(
              color: cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade800),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

                leading: Icon(
                  isDone ? Icons.check_circle : Icons.hourglass_bottom,
                  color: isDone ? Colors.greenAccent : Colors.orangeAccent,
                  size: 32,
                ),

                title: Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                subtitle: Text(
                  'Status: ${status.toUpperCase()}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),

                trailing: IconButton(
                  icon: Icon(Icons.download, color: isDone ? mainColor : Colors.white38),
                  onPressed: isDone ? () => _download(deliverableUrl) : null,
                  tooltip: 'Download final file',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}




