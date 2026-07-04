import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../home/view/main/home_screen.dart';
import '../../../../onboarding/view/main/onboarding_screen.dart';
import '../../controller/auth_controller.dart';
import '../login/login_screen.dart';
import '../shared/brand_wordmark.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const routeName = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolveSession());
  }

  Future<void> _resolveSession() async {
    await ref.read(authControllerProvider.notifier).bootstrap(isWeb: kIsWeb);

    if (!mounted) return;

    final auth = ref.read(authControllerProvider);

    if (auth.isTokenExist != true) {
      context.go(LoginScreen.routeName);
      return;
    }

    context.go(
      OnboardingScreen.isRequired(auth.user)
          ? OnboardingScreen.routeName
          : HomeScreen.routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandWordmark(),
              const Gap(separatorXLg),
              CircularProgressIndicator(color: colors.primaryLight),
            ],
          ),
        ),
      ),
    );
  }
}
