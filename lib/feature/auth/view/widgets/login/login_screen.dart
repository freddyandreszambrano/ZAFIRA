import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
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
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: kSpaceDeviceLg,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: tabletSize),
                child: const LoginBody(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
