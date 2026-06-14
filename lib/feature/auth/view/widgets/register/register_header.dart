import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../shared/brand_wordmark.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BrandWordmark(),
        const Gap(separatorSm),
        Text(
          'Inteligencia Artificial para tu Estilo',
          textAlign: TextAlign.center,
          style: context.typography.bodyLarge?.copyWith(
            color: context.appColors.slate,
          ),
        ),
      ],
    );
  }
}
