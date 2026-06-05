import 'package:flutter/material.dart';

/// `AppPalette` — fachada simplificada para el theme y widgets que solo necesitan
/// los tokens semánticos básicos (primary/secondary/success/error/...).
///
/// Si necesitas más granularidad (containers, slate-deep, gradients), usá
/// `context.appColors` (instancia de [AppColors] en `app_colors.dart`).
///
/// Sigue el patrón de `hey-support/lib/core/helpers/colors.dart` pero con la
/// paleta ZAFIRA (`docs/DESIGN_SYSTEM.md`).

class _AppColors {
  /// PRIMARY (Cyber-Magenta) — `#FF3BBE`
  static const int _primaryBase = 0xFFFF3BBE;

  static const MaterialColor primary = MaterialColor(
    _primaryBase,
    <int, Color>{
      50: Color(0xFFFFE5F6),
      100: Color(0xFFFFB6E2),
      200: Color(0xFFFF87CD),
      300: Color(0xFFFF58B8),
      400: Color(0xFFFF3BBE),
      500: Color(_primaryBase),
      600: Color(0xFFE52FAA),
      700: Color(0xFFC42A92),
      800: Color(0xFF9C2275),
      900: Color(0xFF6B1750),
    },
  );

  /// SECONDARY (Electric-Violet) — `#8E54FF`
  static const int _secondaryBase = 0xFF8E54FF;

  static const MaterialColor secondary = MaterialColor(
    _secondaryBase,
    <int, Color>{
      50: Color(0xFFEFE7FF),
      100: Color(0xFFC2A8FF),
      200: Color(0xFFA88AFF),
      300: Color(0xFF9E76FF),
      400: Color(0xFF9461FF),
      500: Color(_secondaryBase),
      600: Color(0xFF7C49E6),
      700: Color(0xFF6B3ECB),
      800: Color(0xFF5630A6),
      900: Color(0xFF3D2178),
    },
  );

  /// ACCENT — secondary alias, para resaltes.
  static const MaterialColor accent = secondary;

  /// ERROR
  static const int _errorBase = 0xFFEF4444;

  static const MaterialColor error = MaterialColor(
    _errorBase,
    <int, Color>{
      50: Color(0xFFFEE2E2),
      100: Color(0xFFFECACA),
      200: Color(0xFFFCA5A5),
      300: Color(0xFFF87171),
      400: Color(0xFFEF4444),
      500: Color(_errorBase),
      600: Color(0xFFDC2626),
      700: Color(0xFFB91C1C),
      800: Color(0xFF991B1B),
      900: Color(0xFF7F1D1D),
    },
  );

  /// SUCCESS
  static const int _successBase = 0xFF22C55E;

  static const MaterialColor success = MaterialColor(
    _successBase,
    <int, Color>{
      50: Color(0xFFDCFCE7),
      100: Color(0xFFBBF7D0),
      200: Color(0xFF86EFAC),
      300: Color(0xFF4ADE80),
      400: Color(0xFF22C55E),
      500: Color(_successBase),
      600: Color(0xFF16A34A),
      700: Color(0xFF15803D),
      800: Color(0xFF166534),
      900: Color(0xFF14532D),
    },
  );

  /// INFO
  static const int _informationBase = 0xFF0EA5E9;

  static const MaterialColor information = MaterialColor(
    _informationBase,
    <int, Color>{
      50: Color(0xFFE0F2FE),
      100: Color(0xFFBAE6FD),
      200: Color(0xFF7DD3FC),
      300: Color(0xFF38BDF8),
      400: Color(0xFF0EA5E9),
      500: Color(_informationBase),
      600: Color(0xFF0284C7),
      700: Color(0xFF0369A1),
      800: Color(0xFF075985),
      900: Color(0xFF0C4A6E),
    },
  );

  /// NEUTRALS — escala slate de ZAFIRA.
  static const int _neutralBase = 0xFF94A3BB;

  static const MaterialColor neutral = MaterialColor(
    _neutralBase,
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFE2E8F0),
      200: Color(0xFFCBD5E1),
      300: Color(0xFFB6C2D2),
      400: Color(0xFFA5B2C5),
      500: Color(_neutralBase),
      600: Color(0xFF64748B),
      700: Color(0xFF475569),
      800: Color(0xFF334155),
      900: Color(0xFF1E293B),
    },
  );
}

class AppPalette {
  const AppPalette();

  /// Primary (Cyber-Magenta)
  Color get primary => _AppColors.primary[500]!;
  Color get primaryLight => _AppColors.primary[100]!;
  Color get primaryDark => _AppColors.primary[700]!;

  /// Secondary (Electric-Violet)
  Color get secondary => _AppColors.secondary[500]!;
  Color get secondaryLight => _AppColors.secondary[100]!;
  Color get secondaryDark => _AppColors.secondary[700]!;

  /// Status
  Color get success => _AppColors.success[500]!;
  Color get warning => const Color(0xFFF59E0B);
  Color get error => _AppColors.error[500]!;
  Color get info => _AppColors.information[500]!;

  /// Neutral
  Color get surface => Colors.white;
  Color get onSurface => _AppColors.neutral[800]!;
  Color get outline => _AppColors.neutral[500]!;

  /// Basic
  Color get black => const Color(0xFF090101); // ZAFIRA obsidian
  Color get white => Colors.white;

  /// Accent — alias del secondary.
  Color get accentColor => _AppColors.accent[500]!;
}
