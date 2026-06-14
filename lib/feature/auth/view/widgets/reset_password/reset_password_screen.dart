import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../shared/auth_card.dart';
import '../shared/auth_scaffold.dart';
import 'reset_password_form.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({required this.email, super.key});

  final String email;

  static const routeName = '/reset-password';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.white),
          onPressed: () => context.go(ForgotPasswordScreen.routeName),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Crea tu nueva contraseña',
            textAlign: TextAlign.center,
            style: context.typography.displaySmall?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(separatorSm),
          Text(
            'Ingresa el código que enviamos a $email y define tu nueva contraseña.',
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
          const Gap(separatorXLg),
          AuthCard(child: ResetPasswordForm(email: email)),
        ],
      ),
    );
  }
}
