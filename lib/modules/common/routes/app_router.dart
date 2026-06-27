import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/widgets/forgot_password/forgot_password_screen.dart';
import '../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../feature/auth/view/widgets/register/register_screen.dart';
import '../../../feature/auth/view/widgets/register/register_success_screen.dart';
import '../../../feature/auth/view/widgets/reset_password/reset_password_screen.dart';
import '../../../feature/home/view/main/home_screen.dart';
import '../../../feature/try_on/view/main/photo_preview_screen.dart';
import '../../../feature/try_on/view/main/upload_photo_screen.dart';
import '../../../feature/profile/view/main/profile_screen.dart';
import '../../connection/view/widgets/online_widget.dart';

final appRouter = GoRouter(
  initialLocation: LoginScreen.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          Scaffold(body: child, bottomNavigationBar: const OnlineWidget()),
      routes: [
        GoRoute(
          path: LoginScreen.routeName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegisterScreen.routeName,
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: RegisterSuccessScreen.routeName,
          builder: (context, state) => const RegisterSuccessScreen(),
        ),
        GoRoute(
          path: ForgotPasswordScreen.routeName,
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: ResetPasswordScreen.routeName,
          builder: (context, state) =>
              ResetPasswordScreen(email: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: HomeScreen.routeName,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: UploadPhotoScreen.routeName,
          builder: (context, state) => const UploadPhotoScreen(),
        ),

        GoRoute(
          path: PhotoPreviewScreen.routeName,
          builder: (context, state) =>
              PhotoPreviewScreen(imagePath: state.extra as String? ?? ''),
        ),
      ],
    ),
  ],
);
