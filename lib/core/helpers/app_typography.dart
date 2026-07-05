import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'context_helper.dart';

class AppFonts {
  String get fontRoboto => 'Roboto';

  String get fontPoppins => 'Poppins';

  String get fontPacifico => 'Pacifico';

  String get fontNimbusSans => 'NimbusSans';

  String get fontSaens => 'Saens';

  String get fontMontserrat => 'Montserrat';
}

class AppTypography {
  AppTypography({required this.context});

  final BuildContext context;

  AppColors get appColors => AppColors();

  TextStyle? get displayLarge => context.textTheme.displayLarge?.copyWith(
    fontSize: context.responsive<double>(compact: 34, medium: 40, expanded: 46),
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  );

  TextStyle? get displayMedium => context.textTheme.displayMedium?.copyWith(
    fontSize: context.responsive<double>(compact: 27, medium: 32, expanded: 38),
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  );

  TextStyle? get displaySmall => context.textTheme.displaySmall?.copyWith(
    fontSize: context.responsive<double>(compact: 22, medium: 26, expanded: 30),
    fontWeight: FontWeight.w600,
    color: appColors.onSurface,
  );

  TextStyle? get headlineLarge => context.textTheme.headlineLarge?.copyWith(
    fontSize: context.responsive<double>(compact: 20, medium: 24, expanded: 28),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get headlineMedium => context.textTheme.headlineMedium?.copyWith(
    fontSize: context.responsive<double>(compact: 18, medium: 22, expanded: 26),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get headlineSmall => context.textTheme.headlineSmall?.copyWith(
    fontSize: context.responsive<double>(compact: 16, medium: 18, expanded: 22),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get titleLarge => context.textTheme.headlineLarge?.copyWith(
    fontSize: context.responsive<double>(compact: 18, medium: 22, expanded: 26),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get titleMedium => context.textTheme.headlineMedium?.copyWith(
    fontSize: context.responsive<double>(compact: 16, medium: 18, expanded: 22),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get titleSmall => context.textTheme.headlineSmall?.copyWith(
    fontSize: context.responsive<double>(compact: 14, medium: 16, expanded: 20),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get bodyLarge => context.textTheme.bodyLarge?.copyWith(
    fontSize: context.responsive<double>(compact: 16, medium: 18, expanded: 22),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get bodyMedium => context.textTheme.bodyMedium?.copyWith(
    fontSize: context.responsive<double>(compact: 14, medium: 16, expanded: 18),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get bodySmall => context.textTheme.bodySmall?.copyWith(
    fontSize: context.responsive<double>(compact: 12, medium: 14, expanded: 16),
    fontWeight: FontWeight.w400,
    color: appColors.onSurface,
  );

  TextStyle? get labelLarge => context.textTheme.labelLarge?.copyWith(
    fontSize: context.responsive<double>(compact: 16, medium: 20, expanded: 24),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get labelMedium => context.textTheme.labelMedium?.copyWith(
    fontSize: context.responsive<double>(compact: 13, medium: 16, expanded: 20),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get labelSmall => context.textTheme.labelSmall?.copyWith(
    fontSize: context.responsive<double>(compact: 11, medium: 14, expanded: 18),
    fontWeight: FontWeight.w500,
    color: appColors.onSurface,
  );

  TextStyle? get bodyMuted => bodyMedium?.copyWith(color: appColors.slateDeep);

  TextStyle? get bodyStrong => bodyMedium?.copyWith(
    color: appColors.obsidian,
    fontWeight: FontWeight.w600,
  );

  TextStyle? get labelUppercase => labelSmall?.copyWith(
    color: appColors.slate,
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
  );
}
