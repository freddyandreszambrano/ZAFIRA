import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

/// Encabezado del login: wordmark "Zafira" con gradiente de marca + bienvenida.
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              colors.gradientPrimary.createShader(bounds),
          child: Text(
            'Zafira',
            style: context.typography.displayLarge?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
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
