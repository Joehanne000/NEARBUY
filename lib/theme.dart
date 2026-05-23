import 'package:flutter/material.dart';

class NbColors {
  static const bg        = Color(0xFF0A0E1A);
  static const surface   = Color(0xFF111827);
  static const card      = Color(0xFF1A2235);
  static const border    = Color(0xFF1F2D45);
  static const primary   = Color(0xFF4F8EF7);
  static const accent    = Color(0xFF00D4AA);
  static const warning   = Color(0xFFFBBF24);
  static const danger    = Color(0xFFEF4444);
  static const textPrimary   = Color(0xFFE8EDF5);
  static const textSecondary = Color(0xFF6B7FA3);
  static const textMuted     = Color(0xFF3D5070);
}

class NbTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: NbColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: NbColors.primary,
      surface: NbColors.surface,
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: NbColors.surface,
      indicatorColor: Color(0x334F8EF7),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: NbColors.surface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: NbColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: NbColors.textSecondary),
    ),
  );
}