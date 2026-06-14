import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../login/login_screen.dart';
import '../login/login_social_section.dart';
import '../shared/auth_card.dart';
import '../shared/auth_footer_link.dart';
import '../shared/auth_scaffold.dart';
import '../shared/brand_wordmark.dart';
import 'forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  static const routeName = '/forgot-password';

  void _comingSoon(BuildContext context) =>
      AppNotification.info(context, 'Función disponible próximamente');

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AuthScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colors.white),
          onPressed: () => context.go(LoginScreen.routeName),
        ),
        title: BrandWordmark(style: context.typography.titleLarge),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: colors.white),
            onPressed: () => _comingSoon(context),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _LockBadge(),
          const Gap(separatorLg),
          Text(
            '¿Olvidaste tu contraseña?',
            textAlign: TextAlign.center,
            style: context.typography.displaySmall?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(separatorSm),
          Text(
            'No te preocupes, podemos ayudarte a restablecerla.',
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
          const Gap(separatorXLg),
          const AuthCard(child: ForgotPasswordForm()),
          const Gap(separatorLg),
          LoginSocialSection(
            onGoogle: () => _comingSoon(context),
            onApple: () => _comingSoon(context),
          ),
          const Gap(separatorLg),
          AuthFooterLink(
            question: '¿Recordaste tu contraseña? ',
            actionLabel: 'Iniciar sesión',
            onTap: () => context.go(LoginScreen.routeName),
          ),
        ],
      ),
    );
  }
}

class _LockBadge extends StatelessWidget {
  const _LockBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: 92,
      height: 92,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.nightCard,
        border: Border.all(color: colors.primary.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.3),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(Icons.lock_outline_rounded, color: colors.white, size: 40),
    );
  }
}
