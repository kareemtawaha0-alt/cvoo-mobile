import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../state/session.dart';
import '../auth/auth_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  Map<String, dynamic>? userData;
  bool loading = true;

  final Color bgColor = const Color(0xFF0D0D0D);
  final Color cardColor = const Color(0xFF1A1A1A);
  final Color mainColor = const Color(0xFF5C7AFF);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final me = await ApiService.me();
      if (me.data != null && me.data['user'] != null) {
        setState(() {
          userData = me.data['user'];
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  void _signOut() {
    Session.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  Widget _buildInfoItem(String label, String? value, IconData icon) {
    return Card(
      color: cardColor,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade800),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: mainColor, size: 28),
        title: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        subtitle: Text(
          value ?? '-',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : userData == null
              ? const Center(
                  child: Text("No user data found",
                      style: TextStyle(color: Colors.white70)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile image
                      const SizedBox(height: 10),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade800,
                        child: const Icon(Icons.person,
                            color: Colors.white, size: 55),
                      ),
                      const SizedBox(height: 20),

                      // INFO CARDS
                      _buildInfoItem("Name", userData!['name'], Icons.person),
                      _buildInfoItem("Email", userData!['email'], Icons.email),
                      _buildInfoItem("Role", userData!['role'], Icons.work),
                      _buildInfoItem("Phone", userData!['phone'], Icons.phone),
                      _buildInfoItem(
                          "LinkedIn", userData!['linkedin'], Icons.link),
                      _buildInfoItem(
                          "City", userData!['city'], Icons.location_city),
                      _buildInfoItem(
                          "Country", userData!['country'], Icons.flag),

                      const SizedBox(height: 25),

                      // SIGN OUT BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _signOut,
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Sign Out",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}



