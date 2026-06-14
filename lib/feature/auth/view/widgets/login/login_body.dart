import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../register/register_screen.dart';
import '../shared/auth_card.dart';
import '../shared/auth_footer_link.dart';
import 'login_form.dart';
import 'login_header.dart';
import 'login_social_section.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  void _comingSoon(BuildContext context) =>
      AppNotification.info(context, 'Función disponible próximamente');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const LoginHeader(),
        const Gap(separatorXLg),
        AuthCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginForm(),
              const Gap(separatorLg),
              LoginSocialSection(
                onGoogle: () => _comingSoon(context),
                onApple: () => _comingSoon(context),
              ),
            ],
          ),
        ),
        const Gap(separatorLg),
        AuthFooterLink(
          question: '¿No tienes una cuenta? ',
          actionLabel: 'Crear cuenta',
          onTap: () => context.go(RegisterScreen.routeName),
        ),
      ],
    );
  }
}
