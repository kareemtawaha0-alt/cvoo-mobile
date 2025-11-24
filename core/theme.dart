// mobile/lib/core/theme.dart
import 'package:flutter/material.dart';


class AppTheme {
static ThemeData get darkCorporate {
final scheme = const ColorScheme.dark(
primary: Color(0xFF1E88E5), // corporate blue
secondary: Color(0xFF90CAF9),
surface: Color(0xFF0F1115),
background: Color(0xFF0B0D11),
onPrimary: Colors.white,
onSurface: Colors.white70,
);
return ThemeData(
useMaterial3: true,
colorScheme: scheme,
scaffoldBackgroundColor: scheme.background,
appBarTheme: AppBarTheme(
backgroundColor: scheme.surface,
foregroundColor: scheme.onSurface,
elevation: 0,
centerTitle: true,
titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
),
cardTheme:  CardThemeData(
color: const Color(0xFF141821),
elevation: 0,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
),
inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: const Color(0xFF141821),
border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
labelStyle: const TextStyle(color: Colors.white70),
),
bottomNavigationBarTheme: BottomNavigationBarThemeData(
backgroundColor: const Color(0xFF0F1115),
selectedItemColor: scheme.primary,
unselectedItemColor: Colors.white38,
type: BottomNavigationBarType.fixed,
selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
),
);
}
}