import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HojaColors {
  static const Color lightBgMain = Color(0xFFFFFFFF);
  static const Color lightBgCard = Color(0xFFFFFFFF);
  static const Color lightBgSoft = Color(0xFFF3F5F9);
  static const Color lightTextMain = Color(0xFF0B1B3A);
  static const Color lightTextMuted = Color(0xFF5B6678);
  static const Color lightBorder = Color(0xFFDDE2EA);
  static const Color primaryNavy = Color(0xFF1D4FA3);
  static const Color primaryNavyHover = Color(0xFF143D84);
  static const Color primarySoft = Color(0xFFE8F0FC);
  static const Color accentGold = Color(0xFFC9A13B);
  static const Color metalBlue = Color(0xFF2E64C2);
  static const Color silver = Color(0xFFC9CDD3);

  static const Color darkBgMain = Color(0xFF07101F);
  static const Color darkBgCard = Color(0xFF0D1A30);
  static const Color darkBgSoft = Color(0xFF14233F);
  static const Color darkTextMain = Color(0xFFF2F5FB);
  static const Color darkTextMuted = Color(0xFF9FB0CC);
  static const Color darkBorder = Color(0xFF223457);
  static const Color darkPrimary = Color(0xFF3F74CC);
}

class HojaTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: HojaColors.lightBgMain,
      primaryColor: HojaColors.primaryNavy,
      colorScheme: const ColorScheme.light(
        primary: HojaColors.primaryNavy,
        secondary: HojaColors.accentGold,
        surface: HojaColors.lightBgCard,
        onPrimary: Colors.white,
        onSurface: HojaColors.lightTextMain,
      ),
      textTheme: GoogleFonts.tajawalTextTheme().apply(
        bodyColor: HojaColors.lightTextMain,
        displayColor: HojaColors.lightTextMain,
      ),
      cardTheme: CardTheme(
        color: HojaColors.lightBgCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: HojaColors.lightBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HojaColors.lightBgMain,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.primaryNavy, width: 2),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HojaColors.darkBgMain,
      primaryColor: HojaColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: HojaColors.darkPrimary,
        secondary: HojaColors.accentGold,
        surface: HojaColors.darkBgCard,
        onPrimary: Colors.white,
        onSurface: HojaColors.darkTextMain,
      ),
      textTheme: GoogleFonts.tajawalTextTheme().apply(
        bodyColor: HojaColors.darkTextMain,
        displayColor: HojaColors.darkTextMain,
      ),
      cardTheme: CardTheme(
        color: HojaColors.darkBgCard,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: HojaColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HojaColors.darkBgSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: HojaColors.darkPrimary, width: 2),
        ),
      ),
    );
  }
}
