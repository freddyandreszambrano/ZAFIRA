import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class OnboardingStepShell extends StatelessWidget {
  const OnboardingStepShell({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: kIconXl,
          width: kIconXl,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: colors.gradientPrimary,
            borderRadius: kBorderRadiusAllLarge,
            boxShadow: colors.shadowZafira,
          ),
          child: Icon(icon, color: colors.white, size: kIconMd),
        ),
        const Gap(separatorLg),
        Text(
          title,
          style: context.typography.headlineSmall?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Gap(separatorXSm),
        Text(
          subtitle,
          style: context.typography.bodyMedium?.copyWith(
            color: colors.slate,
            height: 1.35,
          ),
        ),
        const Gap(separatorXLg),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    );
  }
}
