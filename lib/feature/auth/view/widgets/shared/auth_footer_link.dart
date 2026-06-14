import 'package:flutter/material.dart';

import '../../../../../core/helpers/context_helper.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    required this.question,
    required this.actionLabel,
    required this.onTap,
    super.key,
  });

  final String question;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          question,
          style: context.typography.bodyMedium?.copyWith(color: colors.slate),
        ),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Text(
            actionLabel,
            style: context.typography.bodyMedium?.copyWith(
              color: colors.secondaryMid,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
