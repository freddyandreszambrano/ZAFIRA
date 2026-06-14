import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/enum/response_status.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../../controller/auth_controller.dart';
import '../shared/auth_gradient_button.dart';
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _toggleObscure() => setState(() => _obscure = !_obscure);

  void _onForgotPassword() =>
      AppNotification.info(context, 'Función disponible próximamente');

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref.read(authControllerProvider.notifier).getToken(
          _usernameController.text.trim(),
          _passwordController.text,
        );
  }

  String? _validateUsername(String? value) {
    if ((value?.trim() ?? '').isEmpty) return 'Ingrese su usuario';
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) return 'Ingrese su contraseña';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
      authControllerProvider.select((s) => s.status == ResponseStatus.loading),
    );

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
            onSubmitted: (_) => _submit(),
            labelTrailing: _ForgotPasswordLink(onTap: _onForgotPassword),
            suffixIcon: ObscureToggleButton(
              obscured: _obscure,
              onPressed: _toggleObscure,
            ),
          ),
          const Gap(separatorXLg),
          AuthGradientButton(
            label: 'Iniciar sesión',
            isLoading: isLoading,
            onPressed: _submit,
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
