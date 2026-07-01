import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../buttons/app_gradient_button.dart';
import '../notifications/app_notification.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.header,
    super.key,
  });

  final AppNotificationType type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = _styleFor(context);

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Padding(
            padding: kSpaceDeviceLg,
            child: Column(
              children: [
                ?header,
                const Spacer(),
                _StatusIcon(accent: style.accent, icon: style.icon),
                const Gap(separatorXLg),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.typography.displayMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(separatorMd),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.typography.bodyLarge?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Spacer(),
                if (actionLabel != null && onAction != null)
                  AppGradientButton(label: actionLabel!, onPressed: onAction!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _StatusStyle _styleFor(BuildContext context) {
    final colors = context.appColors;
    switch (type) {
      case AppNotificationType.success:
        return _StatusStyle(colors.primary, Icons.check_rounded);
      case AppNotificationType.error:
        return _StatusStyle(colors.error, Icons.close_rounded);
      case AppNotificationType.warning:
        return _StatusStyle(colors.warning, Icons.priority_high_rounded);
      case AppNotificationType.info:
        return _StatusStyle(colors.info, Icons.info_outline_rounded);
    }
  }
}

class _StatusStyle {
  const _StatusStyle(this.accent, this.icon);

  final Color accent;
  final IconData icon;
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [accent.withValues(alpha: 0.35), accent.withValues(alpha: 0)],
        ),
      ),
      child: Container(
        width: 92,
        height: 92,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: accent,
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: context.appColors.white, size: 48),
      ),
    );
  }
}
