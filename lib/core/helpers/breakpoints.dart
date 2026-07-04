import 'package:flutter/widgets.dart';

enum Breakpoint { compact, medium, expanded, large }

extension BreakpointX on BuildContext {
  Breakpoint get breakpoint {
    final width = MediaQuery.sizeOf(this).width;
    if (width < 600) return Breakpoint.compact;
    if (width < 840) return Breakpoint.medium;
    if (width < 1200) return Breakpoint.expanded;
    return Breakpoint.large;
  }

  bool get isCompact => breakpoint == Breakpoint.compact;

  bool get isMedium => breakpoint == Breakpoint.medium;

  bool get isExpanded => breakpoint == Breakpoint.expanded;

  bool get isLarge => breakpoint == Breakpoint.large;

  bool get isCompactOrMedium => isCompact || isMedium;

  bool get isExpandedOrLarge => isExpanded || isLarge;

  T responsive<T>({
    required T compact,
    T? medium,
    T? expanded,
    T? large,
  }) {
    switch (breakpoint) {
      case Breakpoint.compact:
        return compact;
      case Breakpoint.medium:
        return medium ?? compact;
      case Breakpoint.expanded:
        return expanded ?? medium ?? compact;
      case Breakpoint.large:
        return large ?? expanded ?? medium ?? compact;
    }
  }
}
