import 'package:flutter/material.dart';

import '../shared/auth_scaffold.dart';
import 'register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    return const AuthScaffold(child: RegisterBody());
  }
}
