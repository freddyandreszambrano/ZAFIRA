import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/auth_scaffold.dart';
import 'login_auth_mixin.dart';
import 'login_body.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with LoginAuthMixin<LoginScreen> {
  @override
  void initState() {
    initAuthServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    authListener();
    return const AuthScaffold(child: LoginBody());
  }
}
