import 'package:flutter/material.dart';

import '../../../../../core/helpers/context_helper.dart';

/// Pie del login: invitación a registrarse.
class LoginFooter extends StatelessWidget {
  const LoginFooter({required this.onCreateAccount, super.key});

  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '¿No tienes una cuenta? ',
          style: context.typography.bodyMedium?.copyWith(color: colors.slate),
        ),
        GestureDetector(
          onTap: onCreateAccount,
          behavior: HitTestBehavior.opaque,
          child: Text(
            'Crear cuenta',
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
