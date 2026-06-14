import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../feature/auth/view/widgets/register/register_screen.dart';
import '../../connection/view/widgets/online_widget.dart';

final appRouter = GoRouter(
  initialLocation: LoginScreen.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const OnlineWidget(),
      ),
      routes: [
        GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    ),
  ],
);
