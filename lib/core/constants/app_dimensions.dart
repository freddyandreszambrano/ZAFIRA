import 'package:flutter/cupertino.dart';

class AppDimensions {
  static const mobile = 480;
  static const tabletSm = 700;
  static const tablet = 992;
  static const desktop = 1240;
  static const desktopLg = 1440;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.height >= tablet;
  }
}
