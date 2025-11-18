import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color customPrimaryColor = Color(0xFF1E92A1);

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: customPrimaryColor,
        primary: customPrimaryColor,
        secondary: const Color(0xFFFBB03B), // Amarillo tierra
        surface: const Color(0xFFF0F9FA),
        onPrimary: Colors.white,
        onSecondary: Colors.black87,
        onSurface: const Color(0xFF333333),
        error: const Color(0xFFF44336),
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      // Opcional: Personalizar algunos estilos globales
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: customPrimaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: customPrimaryColor),
      ),
      // Aplicar tipografías globalmente
      textTheme: TextTheme(
        // Títulos (Display, Headline)
        displayLarge: GoogleFonts.poppins(
          fontSize: 36,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        // Texto principal
        titleLarge: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        // Texto secundario (por ejemplo, para la lengua indígena)
        bodySmall: GoogleFonts.notoSans(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
