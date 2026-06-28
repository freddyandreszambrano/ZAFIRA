import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/enum/response_status.dart';
import '../../../../../modules/common/widget/buttons/app_gradient_button.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../domain/password_reset_confirm.dart';
import '../../controller/password_reset_controller.dart';
import '../../state/password_reset_state.dart';
import '../login/login_screen.dart';
import '../register/password_strength_indicator.dart';
import '../shared/auth_text_field.dart';
import '../shared/obscure_toggle_button.dart';

class ResetPasswordForm extends ConsumerStatefulWidget {
  const ResetPasswordForm({required this.email, super.key});

  final String email;

  @override
  ConsumerState<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends ConsumerState<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      AppNotification.error(
        context,
        'Hay datos pendientes por completar o corregir.',
      );
      return;
    }

    ref
        .read(passwordResetControllerProvider.notifier)
        .confirmReset(
          PasswordResetConfirm(
            email: widget.email,
            code: _codeController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  String? _validateCode(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingrese el código';
    if (text.length != 6 || int.tryParse(text) == null) {
      return 'El código tiene 6 dígitos';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';

    if (text.isEmpty) return 'Ingrese una contraseña';

    return _validateStrongPassword(text);
  }

  String? _validateStrongPassword(String password) {
    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'La contraseña debe contener al menos una letra mayúscula';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'La contraseña debe contener al menos una letra minúscula';
    }

    if (!RegExp(r'\d').hasMatch(password)) {
      return 'La contraseña debe contener al menos un número';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\];]').hasMatch(password)) {
      return 'La contraseña debe contener al menos un carácter especial';
    }

    return null;
  }

  String? _validateConfirm(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme su contraseña';
    if (value != _passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PasswordResetState>(passwordResetControllerProvider, (_, next) {
      if (next.status == ResponseStatus.success) {
        AppNotification.success(
          context,
          'Contraseña actualizada correctamente',
        );
        context.go(LoginScreen.routeName);
      } else if (next.status == ResponseStatus.error) {
        AppNotification.error(
          context,
          next.errorMessage ?? 'No se pudo actualizar la contraseña',
        );
      }
    });

    final isLoading = ref.watch(
      passwordResetControllerProvider.select(
        (s) => s.status == ResponseStatus.loading,
      ),
    );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthTextField(
            controller: _codeController,
            label: 'Código',
            hint: '6 dígitos',
            prefixIcon: Icons.pin_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateCode,
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _passwordController,
            label: 'Nueva contraseña',
            hint: 'Mínimo 8 caracteres',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
            onChanged: (_) => setState(() {}),
            suffixIcon: ObscureToggleButton(
              obscured: _obscurePassword,
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
          const Gap(separatorSm),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _passwordController,
            builder: (_, value, _) =>
                PasswordStrengthIndicator(password: value.text),
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _confirmController,
            label: 'Confirmar contraseña',
            hint: 'Repite tu contraseña',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirm,
            textInputAction: TextInputAction.done,
            validator: _validateConfirm,
            onSubmitted: (_) => _submit(),
            suffixIcon: ObscureToggleButton(
              obscured: _obscureConfirm,
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          const Gap(separatorXLg),
          AnimatedBuilder(
            animation: Listenable.merge([
              _codeController,
              _passwordController,
              _confirmController,
            ]),
            builder: (context, _) {
              final allFilled =
                  _codeController.text.trim().isNotEmpty &&
                  _passwordController.text.isNotEmpty &&
                  _confirmController.text.isNotEmpty;

              return AppGradientButton(
                label: 'Actualizar contraseña',
                isLoading: isLoading,
                enabled: allFilled,
                onPressed: _submit,
              );
            },
          ),
        ],
      ),
    );
  }
}
