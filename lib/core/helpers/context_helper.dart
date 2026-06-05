import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_typography.dart';
import 'colors.dart';

/// Atajos de uso frecuente sobre [BuildContext].
///
/// Patrón espejo de `hey-support/lib/core/helpers/context_helper.dart`.
/// Permite escribir `context.appColors.primary` en lugar de
/// `AppColors().primary` en cualquier widget.
extension ContextHelper on BuildContext {
  /// Altura típica para BottomSheets, ajustada por plataforma.
  double get heightBottomSheet {
    if (kIsWeb || Platform.isAndroid) {
      return MediaQuery.of(this).size.height * 0.95;
    }
    return MediaQuery.of(this).size.height * 0.85;
  }

  Size get mediaQuery => MediaQuery.of(this).size;

  /// Acceso completo a la paleta ZAFIRA (`docs/DESIGN_SYSTEM.md`).
  AppColors get appColors => AppColors();

  /// Fachada simplificada (primary, secondary, success, error, ...).
  AppPalette get appPalette => const AppPalette();

  AppFonts get appFonts => AppFonts();

  AppTypography get typography => AppTypography(context: this);

  AppDimensions get appDimensions => AppDimensions();

  /// Código de idioma actual en mayúsculas (`'ES'`, `'EN'`).
  String get currentLocale {
    return Localizations.localeOf(this).languageCode.toUpperCase();
  }

  ThemeData get theme => Theme.of(this);

  Size get screenSize => MediaQuery.of(this).size;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
