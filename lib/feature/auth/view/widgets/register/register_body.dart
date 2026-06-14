import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../login/login_screen.dart';
import '../shared/auth_card.dart';
import '../shared/auth_footer_link.dart';
import 'register_form.dart';
import 'register_header.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const RegisterHeader(),
        const Gap(separatorXLg),
        const AuthCard(child: RegisterForm()),
        const Gap(separatorLg),
        AuthFooterLink(
          question: '¿Ya tienes una cuenta? ',
          actionLabel: 'Inicia sesión',
          onTap: () => context.go(LoginScreen.routeName),
        ),
      ],
    );
  }
}
