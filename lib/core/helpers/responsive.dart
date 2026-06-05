import 'package:flutter/widgets.dart';

extension MediaQueryExtension on BuildContext {
  // Base screen height and width from your Figma design (872px height and 375px width)
  static const double baseWidth = 375;
  static const double baseHeight = 812;

  /// Get the screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the text scale factor
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1.0);

  /// Get the device pixel ratio
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Get the screen orientation (portrait or landscape)
  Orientation get orientation => MediaQuery.of(this).orientation;

  /// Get safe area insets (top, bottom, left, right)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // === New Methods for Scaling === //

  /// Scale width based on the screen width relative to the base width (375px)
  double responsiveWidth(double originalWidth) {
    // Calculate the scaling factor based on the screen width
    double scaleFactor = screenWidth / baseWidth;

    // Apply the scale factor to the original size (to prevent overflow)
    return originalWidth * scaleFactor;
  }

  /// Scale height based on the screen height relative to the base height (872px)
  double responsiveHeight(double originalHeight) {
    // Calculate the scaling factor based on the screen height
    double scaleFactor = screenHeight / baseHeight;

    // Apply the scale factor to the original size (to prevent overflow)
    return originalHeight * scaleFactor;
  }

  /// Scale font size based on the screen width relative to the base width (375px)
  double responsiveFontSize(double originalFontSize) {
    // Calculate the scaling factor based on the screen width
    double scaleFactor = screenWidth / baseWidth;

    // Apply the scale factor to the original font size (to maintain proportionality)
    return originalFontSize * scaleFactor;
  }

  /// Scale padding based on the screen size (for top, bottom, left, and right)
  EdgeInsets responsivePadding({
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
  }) {
    // Calculate the scaling factor based on the screen height for padding
    double verticalScale = screenHeight / baseHeight;
    double horizontalScale = screenWidth / baseWidth;

    // Apply the scale factor to the padding values
    return EdgeInsets.only(
      top: top * verticalScale,
      bottom: bottom * verticalScale,
      left: left * horizontalScale,
      right: right * horizontalScale,
    );
  }

  /// Scale border radius based on the screen width relative to the base width (375px)
  double responsiveBorderRadius(double originalRadius) {
    // Calculate the scaling factor based on the screen width
    double scaleFactor = screenWidth / baseWidth;

    // Apply the scale factor to the original radius
    return originalRadius * scaleFactor;
  }
}
