import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../widget/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;
    AppNotification.info(
      context,
      '${HomeBottomNav.items[index].label} disponible próximamente',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Inicio',
                  style: context.typography.displaySmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Gap(separatorSm),
                Text(
                  'Tu armario virtual te espera.',
                  style: context.typography.bodyLarge?.copyWith(
                    color: colors.slate,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}
