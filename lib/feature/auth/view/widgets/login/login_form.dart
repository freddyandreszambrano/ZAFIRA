import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/enum/response_status.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/buttons/app_gradient_button.dart';
import '../../controller/auth_controller.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../shared/auth_text_field.dart';
import '../shared/obscure_toggle_button.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;
  bool _submitted = false;
  bool _showRequiredMessage = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _obscure = !_obscure);

  void _onForgotPassword() => context.go(ForgotPasswordScreen.routeName);

  void _clearLoginFeedback() {
    ref.read(authControllerProvider.notifier).clearLoginError();

    if (_submitted || _showRequiredMessage) {
      setState(() {
        _submitted = false;
        _showRequiredMessage = false;
      });

      _formKey.currentState?.validate();
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _submitted = true;
      _showRequiredMessage = false;
    });

    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ref.read(authControllerProvider.notifier).clearLoginError();

      setState(() {
        _showRequiredMessage = true;
      });

      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      ref.read(authControllerProvider.notifier).clearLoginError();

      setState(() {
        _showRequiredMessage = true;
      });

      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .getToken(_usernameController.text.trim(), _passwordController.text);
  }

  String? _validateUsername(String? value) {
    return null;
  }

  String? _validatePassword(String? value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == ResponseStatus.loading;

    final hasLoginError =
        authState.status == ResponseStatus.error &&
        (authState.errorMessage ?? '').isNotEmpty;

    final isAccountDeactivated = (authState.errorMessage ?? '')
        .toLowerCase()
        .contains('desactivada');

    final showMessageCard = hasLoginError || _showRequiredMessage;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: _usernameController,
            label: 'Usuario',
            hint: 'Nombre de usuario',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            validator: _validateUsername,
            autovalidateMode: AutovalidateMode.disabled,
            errorText: null,
            hasExternalError: hasLoginError || _showRequiredMessage,
            onChanged: (_) => _clearLoginFeedback(),
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _passwordController,
            label: 'Contraseña',
            hint: '••••••••',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscure,
            textInputAction: TextInputAction.done,
            validator: _validatePassword,
            autovalidateMode: AutovalidateMode.disabled,
            errorText: null,
            hasExternalError: hasLoginError || _showRequiredMessage,
            onSubmitted: (_) => _submit(),
            onChanged: (_) => _clearLoginFeedback(),
            labelTrailing: _ForgotPasswordLink(onTap: _onForgotPassword),
            suffixIcon: ObscureToggleButton(
              obscured: _obscure,
              onPressed: _toggleObscure,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: showMessageCard
                ? Padding(
                    key: ValueKey(
                      hasLoginError ? 'login-error-card' : 'required-card',
                    ),
                    padding: const EdgeInsets.only(top: separatorLg),
                    child: _LoginMessageCard(
                      title: hasLoginError
                          ? (isAccountDeactivated
                                ? 'Cuenta desactivada'
                                : 'No pudimos iniciar sesión')
                          : 'Campos obligatorios',
                      message: hasLoginError
                          ? (authState.errorMessage ??
                                'Verifica tu usuario y contraseña e inténtalo nuevamente.')
                          : 'Ingresa tu usuario y contraseña para continuar.',
                      attempts: authState.failedLoginAttempts,
                      showRecovery:
                          hasLoginError &&
                          !isAccountDeactivated &&
                          authState.failedLoginAttempts >= 3,
                      onForgotPassword: _onForgotPassword,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          const Gap(separatorXLg),
          AppGradientButton(
            label: 'Iniciar sesión',
            isLoading: isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

class _LoginMessageCard extends StatelessWidget {
  const _LoginMessageCard({
    required this.title,
    required this.message,
    required this.attempts,
    required this.showRecovery,
    required this.onForgotPassword,
  });

  final String title;
  final String message;
  final int attempts;
  final bool showRecovery;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: kSpaceDeviceMd,
      decoration: BoxDecoration(
        color: colors.error.withValues(alpha: 0.10),
        borderRadius: kBorderRadiusAllMedium,
        border: Border.all(color: colors.error.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.error.withValues(alpha: 0.16),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: colors.error,
              size: 20,
            ),
          ),
          const Gap(separatorMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.typography.bodyLarge?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  message,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slateSoft,
                    height: 1.35,
                  ),
                ),
                if (showRecovery) ...[
                  const Gap(separatorSm),
                  GestureDetector(
                    onTap: onForgotPassword,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: context.typography.bodySmall?.copyWith(
                        color: colors.secondaryMid,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        '¿Olvidaste tu contraseña?',
        style: context.typography.bodyMedium?.copyWith(
          color: context.appColors.secondaryMid,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
