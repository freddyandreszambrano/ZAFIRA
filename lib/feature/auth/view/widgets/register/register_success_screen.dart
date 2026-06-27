import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../../../modules/common/widget/status/status_screen.dart';
import '../login/login_screen.dart';
import '../shared/brand_wordmark.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  static const routeName = '/register-success';

  @override
  Widget build(BuildContext context) {
    return StatusScreen(
      type: AppNotificationType.success,
      title: '¡Cuenta creada con éxito!',
      message:
          'Tu probador virtual está listo. '
          'Inicia sesión para comenzar tu experiencia.',
      actionLabel: 'Ir a Iniciar sesión',
      onAction: () => context.go(LoginScreen.routeName),
      header: Column(
        children: [
          const BrandWordmark(),
          const Gap(separatorSm),
          Text(
            'Tu probador virtual impulsado por IA',
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium?.copyWith(
              color: context.appColors.slate,
            ),
          ),
        ],
      ),
    );
  }
}
