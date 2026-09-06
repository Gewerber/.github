// Gewerber Brand Colors - Dart/Flutter
// Import: import 'colors.dart';

import 'package:flutter/material.dart';

/// Gewerber brand color palette
class GewerberColors {
  // Private constructor
  GewerberColors._();

  /// Primary brand color - Gewerber Blue
  /// Trust, stability, clarity
  static const Color primary = Color(0xFF2D6CDF);
  static const Color primaryHover = Color(0xFF1D5BC4);
  static const Color primaryLight = Color(0xFFE8F0FD);
  static const Color primaryDark = Color(0xFF1A4AA3);

  /// Accent color - Gewerber Mint
  /// Freshness, modernity, friendliness
  static const Color accent = Color(0xFF4CD4A9);
  static const Color accentHover = Color(0xFF38C496);
  static const Color accentLight = Color(0xFFE8FAF3);
  static const Color accentDark = Color(0xFF1D9570);

  /// Neutral colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE1E5EB);

  /// Text colors
  static const Color text = Color(0xFF1F2A33);
  static const Color textSecondary = Color(0xFF5A6A78);
  static const Color textMuted = Color(0xFF64707E);
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Semantic colors
  static const Color error = Color(0xFFCC3333);
  static const Color errorLight = Color(0xFFFDEAEA);
  static const Color errorDark = Color(0xFFB12222);

  static const Color success = Color(0xFF187F4F);
  static const Color successLight = Color(0xFFE8F7EE);
  static const Color successDark = Color(0xFF157347);

  static const Color warning = Color(0xFF996200);
  static const Color warningLight = Color(0xFFFFF4E6);
  static const Color warningDark = Color(0xFF7A4E00);

  static const Color info = Color(0xFF2D6CDF);
  static const Color infoLight = Color(0xFFE8F0FD);
  static const Color infoDark = Color(0xFF1A4AA3);

  /// MaterialColor swatches for ThemeData
  static const MaterialColor primarySwatch = MaterialColor(
    0xFF2D6CDF,
    <int, Color>{
      50: Color(0xFFE8F0FD),
      100: Color(0xFFD1E1FA),
      200: Color(0xFFA3C3F5),
      300: Color(0xFF75A5F0),
      400: Color(0xFF4D88EB),
      500: Color(0xFF2D6CDF),
      600: Color(0xFF2862CE),
      700: Color(0xFF2257BD),
      800: Color(0xFF1D4DAB),
      900: Color(0xFF153A93),
    },
  );

  static const MaterialColor accentSwatch = MaterialColor(
    0xFF4CD4A9,
    <int, Color>{
      50: Color(0xFFE8FAF3),
      100: Color(0xFFD1F5E7),
      200: Color(0xFFA3EBD0),
      300: Color(0xFF75E1B9),
      400: Color(0xFF4DD7A1),
      500: Color(0xFF4CD4A9),
      600: Color(0xFF43BF99),
      700: Color(0xFF39A986),
      800: Color(0xFF309474),
      900: Color(0xFF23745A),
    },
  );

  /// Semantic color swatches
  static const MaterialColor errorSwatch = MaterialColor(
    0xFFCC3333,
    <int, Color>{
      50: Color(0xFFFDEAEA),
      100: Color(0xFFFBD5D5),
      200: Color(0xFFF7ABA8),
      300: Color(0xFFEF6A64),
      400: Color(0xFFE04A46),
      500: Color(0xFFCC3333),
      600: Color(0xFFC02C2C),
      700: Color(0xFFB12222),
      800: Color(0xFF971D1D),
      900: Color(0xFF7D1717),
    },
  );

  static const MaterialColor successSwatch = MaterialColor(
    0xFF187F4F,
    <int, Color>{
      50: Color(0xFFE8F7EE),
      100: Color(0xFFD1EFDD),
      200: Color(0xFFA3DFBC),
      300: Color(0xFF5CB885),
      400: Color(0xFF33A366),
      500: Color(0xFF187F4F),
      600: Color(0xFF16784A),
      700: Color(0xFF146A40),
      800: Color(0xFF125C37),
      900: Color(0xFF0F5234),
    },
  );

  /// Extension for easy access
  static const Map<String, Color> palette = {
    'primary': primary,
    'primaryHover': primaryHover,
    'primaryLight': primaryLight,
    'primaryDark': primaryDark,
    'accent': accent,
    'accentHover': accentHover,
    'accentLight': accentLight,
    'accentDark': accentDark,
    'background': background,
    'surface': surface,
    'border': border,
    'text': text,
    'textSecondary': textSecondary,
    'textMuted': textMuted,
    'textInverse': textInverse,
    'error': error,
    'errorLight': errorLight,
    'errorDark': errorDark,
    'success': success,
    'successLight': successLight,
    'successDark': successDark,
    'warning': warning,
    'warningLight': warningLight,
    'warningDark': warningDark,
    'info': info,
    'infoLight': infoLight,
    'infoDark': infoDark,
  };
}

/// Extension on BuildContext for easy theme access
extension GewerberColorsContext on BuildContext {
  Color get primaryColor => Theme.of(this).colorScheme.primary;
  Color get accentColor => Theme.of(this).colorScheme.secondary;
  Color get backgroundColor => Theme.of(this).colorScheme.background;
  Color get surfaceColor => Theme.of(this).colorScheme.surface;
  Color get errorColor => Theme.of(this).colorScheme.error;
  Color get onPrimaryColor => Theme.of(this).colorScheme.onPrimary;
  Color get onSecondaryColor => Theme.of(this).colorScheme.onSecondary;
  Color get onBackgroundColor => Theme.of(this).colorScheme.onBackground;
  Color get onSurfaceColor => Theme.of(this).colorScheme.onSurface;
  Color get onErrorColor => Theme.of(this).colorScheme.onError;
}