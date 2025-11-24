import 'package:flutter/material.dart';

class AppTheme {
  // Tokens (من globals.css مع مواءمة للدارك)
  static const Color primary = Color(0xFF030213); // --primary
  static const Color primaryOn = Colors.white;    // --primary-foreground
  static const Color background = Color(0xFF0F111A); // دارك بدل #fff
  static const Color surface = Color(0xFF141821);    // لوح داكن للكروت
  static const Color onSurface = Colors.white;
  static const Color muted = Color(0xFFECECF0);      // --muted (للحواف/الفواصل)
  static const Color subtext = Color(0xFF717182);    // --muted-foreground تقريبًا
  static const Color border = Color(0xFF263043);     // حد ناعم للكروت
  static const double radius = 16;                   // --radius
  static const double radiusMd = 14;                 // --radius-md
  static const double radiusLg = 20;                 // --radius-lg
  static const double gap = 16;

  static ThemeData get darkCorporate {
    final cs = ColorScheme.dark(
      primary: primary,
      onPrimary: primaryOn,
      surface: surface,
      onSurface: onSurface,
      background: background,
      onBackground: onSurface,
      secondary: const Color(0xFF12141E), // قريب من sidebar
      onSecondary: onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: cs,
      scaffoldBackgroundColor: background,
      fontFamily: 'Inter', // غيّر لو خط Figma مختلف
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C2333),
        labelStyle: const TextStyle(color: subtext),
        hintStyle: const TextStyle(color: subtext),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: border),
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primary, width: 1.2),
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: primaryOn,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: border),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          foregroundColor: Colors.white,
        ),
      ),
      dividerTheme: const DividerThemeData(color: border),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: subtext,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF233047),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

