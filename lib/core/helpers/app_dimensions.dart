import 'package:flutter/cupertino.dart';

/// Breakpoints responsive del proyecto.
///
/// Versión instance-based (idéntica a `hey-support/lib/core/helpers/app_dimensions.dart`).
/// La versión `static` en `core/constants/app_dimensions.dart` sigue disponible
/// como compat para `app_theme.dart`.
class AppDimensions {
  int get mobile => 480;

  int get tabletSm => 500;

  int get tablet => 992;

  int get desktop => 1240;

  int get desktopLg => 1440;

  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > tabletSm;
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobile;
  }

  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }
}
