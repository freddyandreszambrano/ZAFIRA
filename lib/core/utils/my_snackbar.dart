import 'package:flutter/material.dart';

import '../constants/colors/app_colors.dart';

enum SnackBarType {
  info,
  success,
  warning,
  error,
}

extension SnackBarTypeExtension on SnackBarType {
  Color get color {
    switch (this) {
      case SnackBarType.info:
        return AppColors.blueLightColor;
      case SnackBarType.success:
        return AppColors.greenHeyColor;
      case SnackBarType.warning:
        return AppColors.yellowHeyColor;
      case SnackBarType.error:
        return AppColors.errorColor;
    }
  }
}

class MySnackBar {
  static void show(
    BuildContext context,
    String text, {
    SnackBarType type = SnackBarType.info,
  }) {
    FocusScope.of(context).requestFocus(FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Poppins',
          ),
        ),
        backgroundColor: type.color,
        duration: const Duration(
          seconds: 3,
        ),
      ),
    );
  }
}
