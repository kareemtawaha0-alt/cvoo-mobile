import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../core/theme.dart';
import '../services/api_service.dart';
import '../state/session.dart';
import '../client/client_home.dart';
import '../employee/employee_home.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true, isLoading = false, showPassword = false;
  String? role = 'client';
  final f = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final linkedin = TextEditingController();
  final city = TextEditingController();
  final country = TextEditingController();

  void toggle() => setState(() => isLogin = !isLogin);

  Future<void> submit() async {
    if (!f.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final endpoint = isLogin ? '/auth/login' : '/auth/register';
      final body = isLogin
          ? {
              'email': email.text.trim(),
              'password': password.text.trim(),
            }
          : {
              'name': name.text.trim(),
              'email': email.text.trim(),
              'password': password.text.trim(),
              'role': role,
              'phone': phone.text.trim(),
              // ✅ LinkedIn اختياري
              if (linkedin.text.trim().isNotEmpty)
                'linkedin': linkedin.text.trim(),
              'city': city.text.trim(),
              'country': country.text.trim(),
            };

      final res = await ApiService.dio.post(endpoint, data: body);
      final token = res.data['token'] as String?;
      if (token == null) throw 'No token returned';
      ApiService.setAuthToken(token);
      Session.token = token;

      // ✅ جلب بيانات المستخدم
      final me = await ApiService.me();
      if (me != null && me.data['user'] != null) {
        Session.user = me.data['user'];
      } else {
        Session.user = res.data['user']; // fallback
      }

      if (!mounted) return;

      // ✅ الانتقال حسب الدور
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => (Session.user?['role'] == 'employee')
              ? const EmployeeHomePage()
              : const ClientHomePage(),
        ),
      );
    } on DioException catch (e) {
      _err(e.response?.data['message'] ?? 'Network error');
    } catch (e) {
      _err(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _err(String m) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(m), backgroundColor: Colors.redAccent),
      );

  InputDecoration _dec(String label, {IconData? icon, Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: AppTheme.subtext) : null,
      suffixIcon: suffix,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.gap),
                child: Form(
                  key: f,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isLogin ? 'Sign in' : 'Create account',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'CV / Resume Service',
                        style: TextStyle(color: AppTheme.subtext),
                      ),
                      const SizedBox(height: 20),

                      if (!isLogin) ...[
                        TextFormField(
                          controller: name,
                          decoration: _dec('Full name',
                              icon: Icons.person_outline),
                          validator: (v) =>
                              v!.isEmpty ? 'Enter your name' : null,
                        ),
                        const SizedBox(height: 12),
                      ],

                      TextFormField(
                        controller: email,
                        decoration:
                            _dec('Email', icon: Icons.mail_outline),
                        validator: (v) =>
                            v!.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: password,
                        obscureText: !showPassword,
                        decoration: _dec(
                          'Password',
                          icon: Icons.lock_outline,
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => showPassword = !showPassword),
                            icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppTheme.subtext),
                          ),
                        ),
                        validator: (v) =>
                            v!.length < 6 ? 'Min 6 chars' : null,
                      ),
                      const SizedBox(height: 12),

                      if (!isLogin) ...[
                        DropdownButtonFormField<String>(
                          value: role,
                          decoration: _dec('Role'),
                          dropdownColor: const Color(0xFF1C2333),
                          items: const [
                            DropdownMenuItem(
                                value: 'client', child: Text('Client')),
                            DropdownMenuItem(
                                value: 'employee',
                                child: Text('Employee')),
                          ],
                          onChanged: (v) => setState(() => role = v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    controller: phone,
                                    decoration: _dec('Phone',
                                        icon: Icons.phone_outlined))),
                            const SizedBox(width: 12),
                            Expanded(
                                child: TextFormField(
                                    controller: linkedin,
                                    decoration: _dec('LinkedIn (optional)',
                                        icon: Icons.link_outlined))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    controller: city,
                                    decoration: _dec('City',
                                        icon:
                                            Icons.location_city_outlined))),
                            const SizedBox(width: 12),
                            Expanded(
                                child: TextFormField(
                                    controller: country,
                                    decoration: _dec('Country',
                                        icon: Icons.public_outlined))),
                          ],
                        ),
                      ],

                      const SizedBox(height: 20),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: submit,
                              child: Text(isLogin
                                  ? 'Sign in'
                                  : 'Create account'),
                            ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: toggle,
                        child: Text(isLogin
                            ? "Don't have an account? Sign up"
                            : "Already have an account? Sign in"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




