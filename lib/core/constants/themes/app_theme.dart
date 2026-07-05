import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flavors/flavors_config.dart';
import '../../helpers/app_colors.dart';
import '../../helpers/context_helper.dart';
import '../app_numbers.dart';

class AppTheme {
  ThemeData getThemeData(BuildContext context) {
    final isDev = Flavor.env == Environment.dev;
    final colors = context.appColors;
    final textTheme = GoogleFonts.montserratTextTheme(
      ThemeData.light().textTheme,
    );

    final onEnvironmentColor = isDev ? colors.obsidian : colors.primary;

    final onEnvironmentContainerColor = isDev
        ? colors.slateDeep
        : colors.primaryDark;

    final statusBarColor = onEnvironmentColor;

    final statusBarIconTextColor = colors.surface;

    final tabColor = onEnvironmentColor;

    return ThemeData(
      useMaterial3: true,
      colorScheme: const AppColorScheme(),
      iconTheme: IconThemeData(color: colors.onSurface),
      primaryIconTheme: IconThemeData(color: onEnvironmentColor),
      focusColor: colors.primarySoft,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: onEnvironmentColor,
        selectionHandleColor: onEnvironmentColor,
        selectionColor: colors.primarySoft,
      ),
      scaffoldBackgroundColor: colors.surface,
      hintColor: colors.slate,
      primaryColor: onEnvironmentColor,
      primaryColorDark: onEnvironmentContainerColor,
      tabBarTheme: TabBarThemeData(
        indicatorColor: colors.secondary,
        labelColor: colors.primary,
        unselectedLabelColor: colors.slateDeep,
      ),
      dividerColor: colors.slateSoft,
      disabledColor: colors.slate,
      splashColor: tabColor,
      cardColor: colors.surface,
      highlightColor: colors.primarySoft.withValues(alpha: 0.35),
      canvasColor: colors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: statusBarColor,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarTextStyle: GoogleFonts.montserrat(
          fontSize: context.responsive<double>(compact: 14, medium: 16),
          color: statusBarIconTextColor,
          fontWeight: FontWeight.w600,
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: context.responsive<double>(compact: 16, medium: 18),
          color: statusBarIconTextColor,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(color: statusBarIconTextColor, size: kIconSm),
        shadowColor: tabColor,
      ),
      fontFamily: GoogleFonts.montserrat().fontFamily,
      textTheme: textTheme.apply(
        bodyColor: colors.onSurface,
        displayColor: colors.onSurface,
      ),
      inputDecorationTheme: ThemeData().inputDecorationTheme.copyWith(
        errorStyle: GoogleFonts.montserrat(
          fontSize: context.responsive<double>(compact: 11, medium: 12),
          fontWeight: FontWeight.w500,
          color: colors.error,
        ),
        labelStyle: GoogleFonts.montserrat(
          fontSize: context.responsive<double>(compact: 14, medium: 16),
          fontWeight: FontWeight.w500,
          color: colors.slateDeep,
        ),
        floatingLabelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w700,
          fontSize: context.responsive<double>(compact: 14, medium: 16),
          color: colors.primary,
        ),
        hintStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          color: colors.slate,
          fontSize: context.responsive<double>(compact: 14, medium: 16),
        ),
        filled: true,
        fillColor: colors.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: kBorderRadiusAllMedium,
          borderSide: BorderSide(color: colors.slateSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: kBorderRadiusAllMedium,
          borderSide: BorderSide(width: kBorderWidthMd, color: colors.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: kBorderRadiusAllMedium,
          borderSide: BorderSide(color: colors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: kBorderRadiusAllMedium,
          borderSide: BorderSide(color: colors.error, width: kBorderWidthMd),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.white,
          minimumSize: const Size.fromHeight(kButtonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllLarge,
          ),
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.primary.withValues(alpha: 0.45)),
          minimumSize: const Size.fromHeight(kButtonHeightSm),
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllLarge,
          ),
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadiusAllLarge,
        ),
        titleTextStyle: GoogleFonts.montserrat(
          color: colors.onSurface,
          fontWeight: FontWeight.w800,
          fontSize: context.responsive<double>(compact: 18, medium: 20),
        ),
        contentTextStyle: GoogleFonts.montserrat(
          color: colors.slateDeep,
          fontSize: context.responsive<double>(compact: 14, medium: 16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.surface,
        modalBackgroundColor: colors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(kRadiusXLg)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.nightCard,
        indicatorColor: colors.primary.withValues(alpha: 0.16),
        labelTextStyle: WidgetStatePropertyAll(
          GoogleFonts.montserrat(fontWeight: FontWeight.w700, fontSize: 12),
        ),
      ),
    );
  }
}
