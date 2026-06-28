import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/widgets/forgot_password/forgot_password_screen.dart';
import '../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../feature/auth/view/widgets/register/register_screen.dart';
import '../../../feature/auth/view/widgets/register/register_success_screen.dart';
import '../../../feature/auth/view/widgets/reset_password/reset_password_screen.dart';
import '../../../feature/auth/view/widgets/splash/splash_screen.dart';
import '../../../feature/home/view/main/home_screen.dart';
import '../../../feature/try_on/view/main/photo_preview_screen.dart';
import '../../../feature/try_on/view/main/upload_photo_screen.dart';
import '../../../feature/profile/view/main/profile_screen.dart';
import '../../connection/view/widgets/online_widget.dart';
import '../../../feature/profile/view/main/edit_profile_screen.dart';
import '../../../feature/profile/view/main/preferences_screen.dart';
import '../../../feature/profile/view/main/settings_screen.dart';
import '../../../feature/catalog/view/main/catalog_screen.dart';
import '../../../feature/catalog/view/main/catalog_garments_screen.dart';
import '../../../feature/catalog/view/main/product_detail_screen.dart';
import '../../../feature/catalog/domain/product_model.dart';
import '../../../feature/favorites/view/main/favorites_screen.dart';

final appRouter = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          Scaffold(body: child, bottomNavigationBar: const OnlineWidget()),
      routes: [
        GoRoute(
          path: SplashScreen.routeName,
          builder: (context, state) => const SplashScreen(),
        ),
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
          path: CatalogScreen.routeName,
          builder: (context, state) => const CatalogScreen(),
        ),
        GoRoute(
          path: CatalogGarmentsScreen.routeName,
          builder: (context, state) {
            final extra = state.extra as Map<String, String>? ?? const {};
            return CatalogGarmentsScreen(
              gender: extra['gender'] ?? 'woman',
              category: extra['category'] ?? '',
              categoryLabel: extra['categoryLabel'],
            );
          },
        ),
        GoRoute(
          path: ProductDetailScreen.routeName,
          builder: (context, state) =>
              ProductDetailScreen(product: state.extra as ProductModel),
        ),
        GoRoute(
          path: FavoritesScreen.routeName,
          builder: (context, state) => const FavoritesScreen(),
        ),

        GoRoute(
          path: ProfileScreen.routeName,
          builder: (context, state) => const ProfileScreen(),
        ),

        GoRoute(
          path: EditProfileScreen.routeName,
          builder: (context, state) => const EditProfileScreen(),
        ),

        GoRoute(
          path: PreferencesScreen.routeName,
          builder: (context, state) => const PreferencesScreen(),
        ),

        GoRoute(
          path: SettingsScreen.routeName,
          builder: (context, state) => const SettingsScreen(),
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
