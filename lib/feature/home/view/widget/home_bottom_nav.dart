import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class HomeNavItem {
  const HomeNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const items = <HomeNavItem>[
    HomeNavItem(icon: Icons.home_rounded, label: 'Inicio'),
    HomeNavItem(icon: Icons.grid_view_rounded, label: 'Catálogo'),
    HomeNavItem(icon: Icons.checkroom_rounded, label: 'Selección'),
    HomeNavItem(icon: Icons.favorite_rounded, label: 'Favoritos'),
    HomeNavItem(icon: Icons.person_rounded, label: 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.nightCard,
        border: Border(
          top: BorderSide(color: colors.nightBorder.withValues(alpha: 0.6)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: kSpaceDeviceVSm,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: _NavItem(
                    item: items[i],
                    active: i == currentIndex,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final HomeNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = active ? colors.white : colors.slate;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, color: color, size: 24),
          const Gap(separatorXSm),
          Text(
            item.label,
            style: context.typography.labelSmall?.copyWith(color: color),
          ),
          const Gap(separatorXSm),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? colors.primary : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
