import 'package:flutter/material.dart';

import '../../../core/helpers/context_helper.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({this.onMenu, this.onNotifications, super.key});

  final VoidCallback? onMenu;
  final VoidCallback? onNotifications;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        IconButton(
          onPressed: onMenu,
          icon: Icon(Icons.menu_rounded, color: colors.white),
        ),
        const Spacer(),
        Text(
          'Zafira',
          style: context.typography.titleLarge?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onNotifications,
          icon: Icon(Icons.notifications_none_rounded, color: colors.white),
        ),
      ],
    );
  }
}
