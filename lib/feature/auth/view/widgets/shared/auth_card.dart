import 'package:flutter/material.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: separatorLg,
        vertical: separatorXLg,
      ),
      decoration: BoxDecoration(
        color: colors.nightCard.withValues(alpha: 0.6),
        borderRadius: kBorderRadiusAllXXLarge,
        border: Border.all(color: colors.nightBorder.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: colors.scrim.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}
