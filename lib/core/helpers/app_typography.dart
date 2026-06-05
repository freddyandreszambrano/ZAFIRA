import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'context_helper.dart';

/// Familias de fuentes registradas en `pubspec.yaml` y/o vía `google_fonts`.
class AppFonts {
  String get fontRoboto => 'Roboto';

  String get fontPoppins => 'Poppins';

  String get fontPacifico => 'Pacifico';

  String get fontNimbusSans => 'NimbusSans';

  String get fontSaens => 'Saens';

  /// Familia base usada en el theme (ver `app_theme.dart`).
  String get fontMontserrat => 'Montserrat';
}

/// Estilos tipográficos derivados del `Theme.of(context).textTheme`.
///
/// Replica el patrón de `hey-support/lib/core/helpers/app_typography.dart`,
/// pero con `AppColors` y `AppDimensions` de ZAFIRA.
class AppTypography {
  AppTypography({
    required this.context,
  });

  final BuildContext context;

  AppColors get appColors => AppColors();

  AppDimensions get appDimensions => AppDimensions();

  TextStyle? get displayLarge => context.textTheme.displayLarge?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 40 : 34,
        fontWeight: FontWeight.w600,
        color: appColors.onSurface,
      );

  TextStyle? get displayMedium => context.textTheme.displayMedium?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 34 : 27,
        fontWeight: FontWeight.w600,
        color: appColors.onSurface,
      );

  TextStyle? get displaySmall => context.textTheme.displaySmall?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 27 : 22,
        fontWeight: FontWeight.w600,
        color: appColors.onSurface,
      );

  TextStyle? get headlineLarge => context.textTheme.headlineLarge?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 26 : 18,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  TextStyle? get headlineMedium => context.textTheme.headlineMedium?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 24 : 16,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  TextStyle? get headlineSmall => context.textTheme.headlineSmall?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 20 : 14,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  TextStyle? get titleLarge => context.textTheme.headlineLarge?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 24 : 18,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get titleMedium => context.textTheme.headlineMedium?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 20 : 16,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get titleSmall => context.textTheme.headlineSmall?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 18 : 14,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get bodyLarge => context.textTheme.bodyLarge?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 22 : 16,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get bodyMedium => context.textTheme.bodyMedium?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 18 : 13,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get bodySmall => context.textTheme.bodySmall?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 15 : 9,
        fontWeight: FontWeight.w400,
        color: appColors.onSurface,
      );

  TextStyle? get labelLarge => context.textTheme.labelLarge?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 24 : 18,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  TextStyle? get labelMedium => context.textTheme.labelMedium?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 20 : 14,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  TextStyle? get labelSmall => context.textTheme.labelSmall?.copyWith(
        fontSize: appDimensions.isTablet(context) ? 18 : 11,
        fontWeight: FontWeight.w500,
        color: appColors.onSurface,
      );

  // ── ZAFIRA brand text styles ──────────────────────────────────────────
  /// Texto secundario gris (slate-deep) — body por defecto del DESIGN_SYSTEM.
  TextStyle? get bodyMuted => bodyMedium?.copyWith(color: appColors.slateDeep);

  /// Texto enfático (obsidian).
  TextStyle? get bodyStrong => bodyMedium?.copyWith(
        color: appColors.obsidian,
        fontWeight: FontWeight.w600,
      );

  /// Labels en mayúsculas (badges, secciones) — DESIGN_SYSTEM §5.
  TextStyle? get labelUppercase => labelSmall?.copyWith(
        color: appColors.slate,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      );
}
