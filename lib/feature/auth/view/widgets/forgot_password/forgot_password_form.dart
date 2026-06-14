import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/enum/response_status.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/buttons/app_gradient_button.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../../controller/password_reset_controller.dart';
import '../../state/password_reset_state.dart';
import '../reset_password/reset_password_screen.dart';
import '../shared/auth_text_field.dart';

class ForgotPasswordForm extends ConsumerStatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  ConsumerState<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends ConsumerState<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref
        .read(passwordResetControllerProvider.notifier)
        .requestCode(_emailController.text.trim());
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingrese su correo electrónico';
    if (!text.contains('@')) return 'Ingrese un correo válido';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    ref.listen<PasswordResetState>(passwordResetControllerProvider, (_, next) {
      if (next.status == ResponseStatus.success) {
        AppNotification.info(context, 'Te enviamos un código a tu correo');
        context.go(
          ResetPasswordScreen.routeName,
          extra: _emailController.text.trim(),
        );
      } else if (next.status == ResponseStatus.error) {
        AppNotification.error(
          context,
          next.errorMessage ?? 'No se pudo enviar el código',
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
          Row(
            children: [
              Icon(
                Icons.mail_outline_rounded,
                color: colors.secondaryMid,
                size: 22,
              ),
              const Gap(separatorSm),
              Expanded(
                child: Text(
                  'Ingresa tu correo electrónico',
                  style: context.typography.titleMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(separatorSm),
          Text(
            'Te enviaremos un código para que puedas crear una nueva contraseña.',
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            hint: 'tu@email.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            validator: _validateEmail,
            onSubmitted: (_) => _submit(),
          ),
          const Gap(separatorLg),
          AppGradientButton(
            label: 'Enviar enlace',
            isLoading: isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
