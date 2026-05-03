import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cheerful education system palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueShadow = Color(0xFF1D4ED8);
  static const Color secondaryYellow = Color(0xFFFACC15);
  static const Color tertiaryOrange = Color(0xFFFB923C);
  static const Color neutralSlate = Color(0xFF64748B);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF64748B);
  static const Color borderGray = Color(0xFFD1D5DB);
  static const Color dangerRed = Color(0xFFFF4B4B);

  // Legacy aliases to preserve existing app references while using the new palette
  static const Color primaryGreen = primaryBlue;
  static const Color primaryGreenShadow = primaryBlueShadow;
  static const Color secondaryBlue = primaryBlue;
  static const Color secondaryBlueShadow = primaryBlueShadow;

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: secondaryYellow,
        error: dangerRed,
        surface: backgroundLight,
      ),
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        headlineMedium: GoogleFonts.nunito(
          color: textMain,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: GoogleFonts.nunito(
          color: textMain,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        bodyLarge: GoogleFonts.nunito(color: textMain, fontSize: 16),
        bodyMedium: GoogleFonts.nunito(color: textLight, fontSize: 14),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderGray, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderGray, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        hintStyle: const TextStyle(
          color: neutralSlate,
          fontWeight: FontWeight.bold,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: neutralSlate),
      ),
      useMaterial3: true,
    );
  }
}
