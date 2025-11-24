class Session {
  static String? token;
  static Map<String, dynamic>? user; 
  // يحتوي بيانات المستخدم بعد تسجيل الدخول من الـ backend

  static bool get isEmployee => user?['role'] == 'employee';
  static bool get isClient => user?['role'] == 'client';

  static void clear() {
    token = null;
    user = null;
  }
}
