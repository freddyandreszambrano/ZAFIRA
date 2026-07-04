import 'package:flutter/widgets.dart';

import 'breakpoints.dart';

extension AdaptiveGapX on BuildContext {
  double get gutter => responsive<double>(
        compact: 16,
        medium: 24,
        expanded: 32,
        large: 40,
      );

  double get sectionGap => responsive<double>(
        compact: 24,
        medium: 32,
        expanded: 40,
        large: 48,
      );

  double get cardMinHeight => responsive<double>(
        compact: 76,
        medium: 90,
        expanded: 104,
      );

  double get cardMinHeightTall => responsive<double>(
        compact: 118,
        medium: 132,
        expanded: 148,
      );

  int get gridColumns => responsive<int>(
        compact: 2,
        medium: 3,
        expanded: 4,
        large: 6,
      );

  EdgeInsets get pagePadding => EdgeInsets.symmetric(horizontal: gutter);

  EdgeInsets get cardPadding => EdgeInsets.all(
        responsive<double>(compact: 12, medium: 16, expanded: 20),
      );
}
