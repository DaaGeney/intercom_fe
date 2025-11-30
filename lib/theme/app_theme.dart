import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ChatHub Palette
  static const Color primaryBlue = Color(0xFF3B82F6); // Bright Blue
  static const Color backgroundLight = Color(0xFFF3F4F6); // Light Gray/Blue
  static const Color surfaceWhite = Colors.white;
  static const Color textPrimary = Color(0xFF1F2937); // Dark Gray/Black
  static const Color textSecondary = Color(0xFF6B7280); // Medium Gray
  
  // Call Screen Palette
  static const Color callBackground = Color(0xFF111827); // Dark Navy
  static const Color callControlBackground = Color(0xFF374151); // Lighter Navy
  static const Color danger = Color(0xFFEF4444); // Red
  static const Color success = Color(0xFF10B981); // Green

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryBlue,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryBlue,
        background: backgroundLight,
        surface: surfaceWhite,
        onSurface: textPrimary,
        error: danger,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
