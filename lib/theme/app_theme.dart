import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primarySeedColor = Colors.orange;

  // Tipografías base sin color fijo
  static TextTheme baseTextTheme = TextTheme(
    displayLarge: GoogleFonts.raleway(
      fontSize: 57,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.raleway(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
    bodyMedium: GoogleFonts.roboto(fontSize: 14),
    headlineSmall: GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
  );

  // Tema claro
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      brightness: Brightness.light,
    ),
    textTheme: baseTextTheme.copyWith(
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(color: Colors.black87),
      titleLarge: baseTextTheme.titleLarge!.copyWith(color: Colors.black),
      headlineSmall: baseTextTheme.headlineSmall!.copyWith(color: Colors.black87),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primarySeedColor,
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );

  // Tema oscuro
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primarySeedColor,
      brightness: Brightness.dark,
      background: const Color(0xFF121212),
    ),
    textTheme: baseTextTheme.copyWith(
      bodyMedium: baseTextTheme.bodyMedium!.copyWith(color: Colors.white70),
      titleLarge: baseTextTheme.titleLarge!.copyWith(color: Colors.white),
      headlineSmall: baseTextTheme.headlineSmall!.copyWith(color: Colors.white70),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF121212),
      foregroundColor: Colors.white,
      titleTextStyle: GoogleFonts.raleway(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primarySeedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}
