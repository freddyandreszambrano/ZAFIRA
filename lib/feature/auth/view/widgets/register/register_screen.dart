import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/helpers/context_helper.dart';
import '../login/login_screen.dart';
import '../shared/auth_scaffold.dart';
import 'register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.white),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go(LoginScreen.routeName),
        ),
      ),
      child: const RegisterBody(),
    );
  }
}
