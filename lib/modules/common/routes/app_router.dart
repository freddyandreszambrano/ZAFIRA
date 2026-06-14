import 'package:go_router/go_router.dart';

import '../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../feature/auth/view/widgets/register/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: LoginScreen.routeName,
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
);
