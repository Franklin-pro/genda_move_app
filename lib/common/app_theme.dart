import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFFA5D6A7);

  static const Color secondaryColor = Color(0xFF2196F3);
  static const Color secondaryDark = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF90CAF9);

  static const Color accentColor = Color(0xFFFF9800);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);

  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFf44336);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Heatmap colors
  static const Color heatmapCold = Color(0xFF0000FF);
  static const Color heatmapWarm = Color(0xFFFF0000);
  static const Color heatmapMid = Color(0xFFFFFF00);

  // Get light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimaryColor,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryColor,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimaryColor,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textSecondaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(
          color: textHintColor,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        elevation: 8,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // Text styles
  static TextStyle get headingLarge {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: textPrimaryColor,
    );
  }

  static TextStyle get headingMedium {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    );
  }

  static TextStyle get headingSmall {
    return GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    );
  }

  static TextStyle get bodyLarge {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textPrimaryColor,
    );
  }

  static TextStyle get bodyMedium {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textPrimaryColor,
    );
  }

  static TextStyle get bodySmall {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: textSecondaryColor,
    );
  }

  static TextStyle get labelLarge {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimaryColor,
    );
  }

  static TextStyle get labelMedium {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textPrimaryColor,
    );
  }

  static TextStyle get caption {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: textSecondaryColor,
    );
  }
}
