import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../shared/brand_wordmark.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        const BrandWordmark(),
        const Gap(separatorMd),
        Text(
          'Bienvenido',
          style: context.typography.displayMedium?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(separatorXSm),
        Text(
          'Inicia sesión para continuar',
          style: context.typography.bodyLarge?.copyWith(color: colors.slate),
        ),
      ],
    );
  }
}
