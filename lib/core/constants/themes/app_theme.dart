import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../flavors/flavors_config.dart';
import '../../helpers/context_helper.dart';
import '../app_dimensions.dart';

class AppTheme {
  ThemeData getThemeData(BuildContext context) {
    final isDev = Flavor.env == Environment.dev;

    final onEnvironmentColor = isDev
        ? context.appPalette.black
        : context.appPalette.primary;

    final onEnvironmentContainerColor = isDev
        ? context.appColors.grayDark
        : context.appPalette.primaryDark;

    final statusBarColor = onEnvironmentColor;

    final statusBarIconTextColor = isDev
        ? context.appPalette.surface
        : context.appPalette.surface;

    final tabColor = onEnvironmentColor;

    return ThemeData(
      useMaterial3: false,
      iconTheme: IconThemeData(color: context.appPalette.surface),
      primaryIconTheme: IconThemeData(color: onEnvironmentColor),
      focusColor: context.appColors.grayMainLight,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: onEnvironmentColor,
        selectionHandleColor: onEnvironmentColor,
        selectionColor: context.appColors.grayContainer3,
      ),
      scaffoldBackgroundColor: context.appColors.surface,
      hintColor: context.appColors.grayMainLight,
      primaryColor: onEnvironmentColor,
      primaryColorDark: onEnvironmentContainerColor,
      tabBarTheme: TabBarThemeData(
        indicatorColor: context.appPalette.secondary,
      ),
      dividerColor: context.appColors.grayDark,
      disabledColor: context.appColors.grayMainDark1,
      splashColor: tabColor,
      cardColor: context.appPalette.surface,
      highlightColor: context.appColors.whiteTransparent,
      canvasColor: context.appPalette.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: statusBarColor,
        toolbarTextStyle: GoogleFonts.montserrat(
          fontSize: AppDimensions.isTablet(context) ? 16 : 14,
          color: statusBarIconTextColor,
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: AppDimensions.isTablet(context) ? 18 : 16,
          color: statusBarIconTextColor,
        ),
        iconTheme: IconThemeData(color: statusBarIconTextColor, size: 20.0),
        shadowColor: tabColor,
      ),
      fontFamily: GoogleFonts.montserrat().fontFamily,
      textTheme: GoogleFonts.montserratTextTheme(
        ThemeData.light().textTheme.copyWith(
          displayLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 40 : 40,
          ),
          displayMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 34 : 30,
          ),
          displaySmall: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 27 : 26,
          ),
          headlineLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 26 : 20,
          ),
          headlineMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 24 : 18,
          ),
          headlineSmall: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 20 : 16,
          ),
          titleLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 24 : 18,
          ),
          titleMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 20 : 16,
          ),
          titleSmall: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 18 : 16,
          ),
          labelLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: const Color(0xffffffff),
            fontSize: AppDimensions.isTablet(context) ? 24 : 18,
          ),
          labelMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w400,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 20 : 16,
          ),
          labelSmall: GoogleFonts.montserrat(
            fontSize: AppDimensions.isTablet(context) ? 18 : 14,
            fontWeight: FontWeight.w300,
            color: const Color(0xffB9B9B9),
            letterSpacing: 1,
          ),
          bodyLarge: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            color: const Color(0xff606060),
            fontSize: 26,
          ),
          bodyMedium: GoogleFonts.montserrat(
            fontWeight: FontWeight.w300,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 18 : 14,
          ),
          bodySmall: GoogleFonts.montserrat(
            fontWeight: FontWeight.w200,
            color: const Color(0xff606060),
            fontSize: AppDimensions.isTablet(context) ? 15 : 12,
          ),
        ),
      ),
      inputDecorationTheme: ThemeData().inputDecorationTheme.copyWith(
        errorStyle: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.w300,
          color: const Color(0xffC90808),
        ),
        labelStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w300,
          color: const Color(0xffB9B9B9),
        ),
        floatingLabelStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: const Color(0xff606060),
        ),
        hintStyle: GoogleFonts.montserrat(
          fontWeight: FontWeight.w300,
          color: const Color(0xffc4c4c4),
          fontSize: 14,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xffc4c4c4), width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 0.7,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      colorScheme: ThemeData().colorScheme.copyWith(
        primary: onEnvironmentColor,
        secondary: context.appPalette.secondary,
        shadow: context.appPalette.accentColor,
        error: context.appPalette.error,
      ),
    );
  }
}
