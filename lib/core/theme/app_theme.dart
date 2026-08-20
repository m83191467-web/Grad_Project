import 'package:flutter/material.dart';

/// Navio's visual language: dependable navy, movement-focused teal, and a
/// warm amber accent for actions and live status.
class AppTheme {
  AppTheme._();

  // Brand colors.
  static const Color primary = Color(0xFF123B5D);
  static const Color primaryDark = Color(0xFF08263F);
  static const Color primaryLight = Color(0xFFD9ECF5);
  static const Color secondary = Color(0xFF0B9B94);
  static const Color accent = Color(0xFFF2A93B);

  // Semantic colors.
  static const Color success = Color(0xFF168A63);
  static const Color warning = Color(0xFFD88919);
  static const Color danger = Color(0xFFD9534F);
  static const Color error = danger;

  // Light-mode surfaces and text.
  static const Color background = Color(0xFFF4F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFEAF1F4);
  static const Color textPrimary = Color(0xFF172B3A);
  static const Color textSecondary = Color(0xFF5E7180);
  static const Color textLight = Color(0xFF91A1AC);
  static const Color outline = Color(0xFFD5E0E6);

  // Design tokens.
  static const double radiusSmall = 10;
  static const double radiusMedium = 16;
  static const double radiusLarge = 24;
  static const double radiusPill = 999;
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets fieldPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 15,
  );

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x140D2B45), blurRadius: 18, offset: Offset(0, 8)),
  ];

  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: dark ? secondary : primary,
          brightness: brightness,
        ).copyWith(
          primary: dark ? const Color(0xFF8CCBE0) : primary,
          onPrimary: dark ? const Color(0xFF08263F) : Colors.white,
          primaryContainer: dark ? const Color(0xFF1B4D68) : primaryLight,
          onPrimaryContainer: dark ? const Color(0xFFD9ECF5) : primaryDark,
          secondary: dark ? const Color(0xFF68D5C9) : secondary,
          onSecondary: dark ? const Color(0xFF003733) : Colors.white,
          secondaryContainer: dark
              ? const Color(0xFF14524F)
              : const Color(0xFFD6F2EE),
          onSecondaryContainer: dark
              ? const Color(0xFFB5F2E9)
              : const Color(0xFF064D4A),
          tertiary: dark ? const Color(0xFFFFC66B) : accent,
          error: dark ? const Color(0xFFFF8A80) : danger,
          surface: dark ? const Color(0xFF18232C) : surface,
          onSurface: dark ? const Color(0xFFE8F0F3) : textPrimary,
          outline: dark ? const Color(0xFF526875) : outline,
        );
    final secondaryText = dark ? const Color(0xFFB4C4CC) : textSecondary;
    final fieldFill = dark ? const Color(0xFF1D2A34) : surface;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Cairo',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: dark ? const Color(0xFF0E171E) : background,
      textTheme: TextTheme(
        displayLarge: _text(32, FontWeight.w800, scheme.onSurface, 1.15),
        displayMedium: _text(28, FontWeight.w800, scheme.onSurface, 1.2),
        displaySmall: _text(24, FontWeight.w700, scheme.onSurface, 1.25),
        headlineLarge: _text(22, FontWeight.w800, scheme.onSurface, 1.3),
        headlineMedium: _text(20, FontWeight.w700, scheme.onSurface, 1.35),
        headlineSmall: _text(18, FontWeight.w700, scheme.onSurface, 1.35),
        titleLarge: _text(17, FontWeight.w700, scheme.onSurface, 1.35),
        titleMedium: _text(15, FontWeight.w700, scheme.onSurface, 1.4),
        bodyLarge: _text(16, FontWeight.w400, scheme.onSurface, 1.55),
        bodyMedium: _text(14, FontWeight.w400, secondaryText, 1.5),
        bodySmall: _text(12, FontWeight.w400, secondaryText, 1.45),
        labelLarge: _text(14, FontWeight.w700, scheme.primary, 1.3),
        labelMedium: _text(12, FontWeight.w700, secondaryText, 1.3),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? const Color(0xFF121E27) : surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cairo',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        contentPadding: fieldPadding,
        border: _inputBorder(scheme.outline),
        enabledBorder: _inputBorder(scheme.outline),
        focusedBorder: _inputBorder(scheme.primary, width: 1.8),
        errorBorder: _inputBorder(scheme.error, width: 1.5),
        focusedErrorBorder: _inputBorder(scheme.error, width: 1.8),
        labelStyle: TextStyle(color: secondaryText),
        hintStyle: TextStyle(color: dark ? const Color(0xFF80929D) : textLight),
        prefixIconColor: secondaryText,
        suffixIconColor: secondaryText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusPill)),
          ),
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusPill)),
          ),
          side: BorderSide(color: scheme.primary, width: 1.4),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: dark ? 2 : 1,
        shadowColor: dark ? Colors.black54 : const Color(0x180D2B45),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusMedium)),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: dark ? const Color(0xFF24343F) : surfaceMuted,
        selectedColor: scheme.primaryContainer,
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusPill)),
        ),
        labelStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
      dividerTheme: DividerThemeData(
        color: dark ? const Color(0xFF2B3B45) : outline,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusLarge)),
        ),
        titleTextStyle: _text(20, FontWeight.w800, scheme.onSurface, 1.3),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? const Color(0xFFE8F0F3) : primaryDark,
        contentTextStyle: TextStyle(
          color: dark ? primaryDark : Colors.white,
          fontFamily: 'Cairo',
          fontWeight: FontWeight.w600,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radiusSmall)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.secondary,
        linearTrackColor: scheme.secondaryContainer,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
      iconTheme: IconThemeData(color: secondaryText, size: 22),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: dark ? const Color(0xFF121E27) : surface,
        selectedItemColor: scheme.primary,
        unselectedItemColor: dark ? const Color(0xFF80929D) : textLight,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
    );
  }

  static TextStyle _text(
    double size,
    FontWeight weight,
    Color color,
    double height,
  ) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(radiusSmall)),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
