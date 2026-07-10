import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/widgets/forgot_password/forgot_password_screen.dart';
import '../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../feature/auth/view/widgets/register/register_screen.dart';
import '../../../feature/auth/view/widgets/register/register_success_screen.dart';
import '../../../feature/auth/view/widgets/reset_password/reset_password_screen.dart';
import '../../../feature/auth/view/widgets/splash/splash_screen.dart';
import '../../../feature/home/view/main/home_screen.dart';
import '../../../feature/try_on/domain/try_on_args.dart';
import '../../../feature/try_on/view/main/photo_preview_screen.dart';
import '../../../feature/try_on/view/main/try_on_result_screen.dart';
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
import '../../../feature/onboarding/view/main/onboarding_screen.dart';
import '../../../feature/recommend/view/main/recommend_screen.dart';

CustomTransitionPage<T> _fadePage<T>(Widget child, GoRouterState state) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 100),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

final appRouter = GoRouter(
  initialLocation: SplashScreen.routeName,
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          Scaffold(body: child, bottomNavigationBar: const OnlineWidget()),
      routes: [
        GoRoute(
          path: SplashScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const SplashScreen(), state),
        ),
        GoRoute(
          path: LoginScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const LoginScreen(), state),
        ),
        GoRoute(
          path: RegisterScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const RegisterScreen(), state),
        ),
        GoRoute(
          path: RegisterSuccessScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const RegisterSuccessScreen(), state),
        ),
        GoRoute(
          path: ForgotPasswordScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const ForgotPasswordScreen(), state),
        ),
        GoRoute(
          path: ResetPasswordScreen.routeName,
          pageBuilder: (context, state) => _fadePage(
            ResetPasswordScreen(email: state.extra as String? ?? ''),
            state,
          ),
        ),
        GoRoute(
          path: HomeScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const HomeScreen(), state),
        ),
        GoRoute(
          path: OnboardingScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const OnboardingScreen(), state),
        ),
        GoRoute(
          path: CatalogScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const CatalogScreen(), state),
        ),
        GoRoute(
          path: CatalogGarmentsScreen.routeName,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, String>? ?? const {};
            return _fadePage(
              CatalogGarmentsScreen(
                gender: extra['gender'] ?? 'woman',
                category: extra['category'] ?? '',
                categoryLabel: extra['categoryLabel'],
                // Modo "complementa tu outfit": id de la prenda ya probada y
                // si esa prenda es torso o pierna (define el orden del par)
                complementProductId: int.tryParse(
                  extra['complementProductId'] ?? '',
                ),
                complementIsUpper: extra['complementIsUpper'] == 'true',
              ),
              state,
            );
          },
        ),
        GoRoute(
          path: ProductDetailScreen.routeName,
          pageBuilder: (context, state) => _fadePage(
            ProductDetailScreen(product: state.extra as ProductModel),
            state,
          ),
        ),
        GoRoute(
          path: FavoritesScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const FavoritesScreen(), state),
        ),
        GoRoute(
          path: RecommendScreen.routeName,
          pageBuilder: (context, state) => _fadePage(
            RecommendScreen(favoriteIds: state.extra as List<int>?),
            state,
          ),
        ),
        GoRoute(
          path: ProfileScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const ProfileScreen(), state),
        ),
        GoRoute(
          path: EditProfileScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const EditProfileScreen(), state),
        ),
        GoRoute(
          path: PreferencesScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const PreferencesScreen(), state),
        ),
        GoRoute(
          path: SettingsScreen.routeName,
          pageBuilder: (context, state) => _fadePage(const SettingsScreen(), state),
        ),
        GoRoute(
          path: UploadPhotoScreen.routeName,
          pageBuilder: (context, state) =>
              _fadePage(const UploadPhotoScreen(), state),
        ),
        GoRoute(
          path: PhotoPreviewScreen.routeName,
          pageBuilder: (context, state) => _fadePage(
            PhotoPreviewScreen(imagePath: state.extra as String? ?? ''),
            state,
          ),
        ),
        GoRoute(
          path: TryOnResultScreen.routeName,
          pageBuilder: (context, state) {
            final extra = state.extra;
            // Desde el detalle llega TryOnRequestArgs (con el producto, para
            // "complementa tu outfit"); desde "combinar" llega TryOnOutfitArgs
            // (outfit editable); desde recomendación, la lista de ids.
            if (extra is TryOnRequestArgs) {
              return _fadePage(
                TryOnResultScreen(
                  productIds: extra.productIds,
                  sourceProduct: extra.sourceProduct,
                ),
                state,
              );
            }
            if (extra is TryOnOutfitArgs) {
              return _fadePage(
                TryOnResultScreen(
                  productIds: [extra.upperId, extra.lowerId],
                  outfitArgs: extra,
                ),
                state,
              );
            }
            return _fadePage(
              TryOnResultScreen(
                productIds: (extra as List?)?.cast<int>() ?? const [],
              ),
              state,
            );
          },
        ),
      ],
    ),
  ],
);
