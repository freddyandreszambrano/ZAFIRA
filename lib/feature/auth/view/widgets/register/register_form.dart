import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../shared/auth_gradient_button.dart';
import '../shared/auth_text_field.dart';
import '../shared/obscure_toggle_button.dart';
import 'password_strength_indicator.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // TODO: conectar al endpoint de registro cuando exista en el backend.
    AppNotification.info(context, 'Registro disponible próximamente');
  }

  String? _validateName(String? value) =>
      (value?.trim() ?? '').isEmpty ? 'Ingrese su nombre completo' : null;

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Ingrese su correo electrónico';
    if (!text.contains('@')) return 'Ingrese un correo válido';
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Ingrese una contraseña';
    if (text.length < 8) return 'Mínimo 8 caracteres';
    return null;
  }

  String? _validateConfirm(String? value) {
    if ((value ?? '').isEmpty) return 'Confirme su contraseña';
    if (value != _passwordController.text) return 'Las contraseñas no coinciden';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Únete a Zafira',
            style: context.typography.displaySmall?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(separatorXSm),
          Text(
            'Crea tu cuenta para comenzar a explorar el armario virtual.',
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _nameController,
            label: 'Nombre completo',
            hint: 'Ej. Ana García',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: _validateName,
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _emailController,
            label: 'Correo electrónico',
            hint: 'tu@email.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: _validateEmail,
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _passwordController,
            label: 'Contraseña',
            hint: 'Mínimo 8 caracteres',
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.next,
            validator: _validatePassword,
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
          AuthGradientButton(label: 'Crear cuenta', onPressed: _submit),
        ],
      ),
    );
  }
}
