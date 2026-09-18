import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ValueNotifier<ThemeMode> modo = ValueNotifier(ThemeMode.light);

  // Paleta extraída da imagem
  static const Color verandaBlue = Color(0xFF6BB1AD);
  static const Color skyCloud = Color(0xFFA7BCBD);
  static const Color lychee = Color(0xFFEDECDB);
  static const Color melon = Color(0xFFE5A9A9);
  static const Color cupidPink = Color(0xFFE6748E);

  static ThemeData get temaClaro {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lychee,
      colorScheme: const ColorScheme.light(
        primary: verandaBlue,
        secondary: cupidPink,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: verandaBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: cupidPink,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verandaBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: skyCloud,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme),
      useMaterial3: true,
    );
  }

  static ThemeData get temaEscuro {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF1A2425),
      colorScheme: const ColorScheme.dark(
        primary: verandaBlue,
        secondary: melon,
        surface: Color(0xFF253335),
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF253335),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: melon,
        foregroundColor: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: verandaBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF253335),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
    );
  }
}