import 'package:flutter/material.dart';
import 'auth/auth_screen.dart';

void main() {
  runApp(const CvooApp());
}

class CvooApp extends StatelessWidget {
  const CvooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // 🎨 ثيم فاتح
      home: const AuthScreen(),
    );
  }
}

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  useMaterial3: true,

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
    bodyLarge: TextStyle(color: Colors.black87),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade200,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: Colors.black54),
    labelStyle: const TextStyle(color: Colors.black87),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.black),
      foregroundColor: WidgetStatePropertyAll(Colors.white),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    ),
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    labelStyle: const TextStyle(color: Colors.black87),
    shape: const StadiumBorder(),
  ),
);





