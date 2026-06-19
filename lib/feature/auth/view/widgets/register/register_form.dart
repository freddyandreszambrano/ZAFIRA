import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/enum/response_status.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../domain/register_request.dart';
import '../../controller/register_controller.dart';
import '../../state/register_state.dart';
import '../../../../../modules/common/widget/buttons/app_gradient_button.dart';
import '../shared/auth_text_field.dart';
import '../shared/obscure_toggle_button.dart';
import 'password_strength_indicator.dart';
import 'register_success_screen.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dniController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Timer? _usernameDebounce;
  Timer? _dniDebounce;
  Timer? _emailDebounce;

  @override
  void dispose() {
    _usernameDebounce?.cancel();
    _dniDebounce?.cancel();
    _emailDebounce?.cancel();
    _nameController.dispose();
    _usernameController.dispose();
    _dniController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      AppNotification.error(
        context,
        'Completa todos los campos obligatorios para continuar.',
      );
      return;
    }

    final passwordError = _validateStrongPassword(_passwordController.text);
    if (passwordError != null) {
      AppNotification.error(context, passwordError);
      return;
    }

    final names = _nameController.text
        .trim()
        .split(' ')
        .where((part) => part.isNotEmpty)
        .toList();

    ref.read(registerControllerProvider.notifier).register(
      RegisterRequest(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        dni: _dniController.text.trim(),
        password: _passwordController.text,
        firstName: names.isEmpty ? '' : names.first,
        lastName: names.length > 1 ? names.sublist(1).join(' ') : '',
      ),
    );
  }

  void _clearFieldError(String field) {
    ref.read(registerControllerProvider.notifier).clearFieldError(field);
  }

  void _debouncedValidateField({
    required String field,
    required String value,
    required bool Function(String text) canValidate,
  }) {
    switch (field) {
      case 'username':
        _usernameDebounce?.cancel();
        break;
      case 'dni':
        _dniDebounce?.cancel();
        break;
      case 'email':
        _emailDebounce?.cancel();
        break;
    }

    _clearFieldError(field);

    final text = value.trim();

    if (!canValidate(text)) return;

    final timer = Timer(
      const Duration(milliseconds: 700),
          () {
        ref.read(registerControllerProvider.notifier).validateField(
          field: field,
          value: text,
        );
      },
    );

    switch (field) {
      case 'username':
        _usernameDebounce = timer;
        break;
      case 'dni':
        _dniDebounce = timer;
        break;
      case 'email':
        _emailDebounce = timer;
        break;
    }
  }

  String? _validateFullName(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Este campo es obligatorio';
    }

    final names =
    text.split(' ').where((e) => e.isNotEmpty).toList();

    if (names.length < 2) {
      return 'Ingrese nombre y apellido';
    }

    if (text.length < 5) {
      return 'Ingrese un nombre válido';
    }

    return null;
  }

  String? _validateUsername(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Ingrese un usuario';
    if (text.length < 4) return 'El usuario debe tener al menos 4 caracteres';
    if (text.length > 20) return 'El usuario no puede superar los 20 caracteres';

    final valid = RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(text);
    if (!valid) {
      return 'Solo puede contener letras, números y guion bajo';
    }

    return null;
  }

  String? _validateDni(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Ingrese su cédula';
    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return 'La cédula solo debe contener números';
    }
    if (text.length != 10) {
      return 'La cédula debe tener 10 dígitos';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) return 'Ingrese su correo electrónico';

    final valid = RegExp(
      r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$',
    ).hasMatch(text);

    if (!valid) return 'Ingrese un correo válido';

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

    final commonPasswords = {
      '12345678',
      '123456789',
      '1234567890',
      'password',
      'password123',
      'qwerty',
      'qwerty123',
      'admin123',
      'admin1234',
    };

    if (commonPasswords.contains(password.toLowerCase())) {
      return 'Contraseña demasiado fácil. Usa una contraseña más segura';
    }

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

    ref.listen<RegisterState>(registerControllerProvider, (previous, next) {
      if (next.status == ResponseStatus.success) {
        context.go(RegisterSuccessScreen.routeName);
      } else if (next.status == ResponseStatus.error &&
          (next.errorMessage ?? '').isNotEmpty) {
        AppNotification.error(
          context,
          next.errorMessage ?? 'No se pudo crear la cuenta',
        );
      }
    });

    final state = ref.watch(registerControllerProvider);
    final isLoading = state.status == ResponseStatus.loading;
    final fieldErrors = state.fieldErrors;

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
            hint: 'Ej. Melissa Quinde',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: _validateFullName,
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _usernameController,
            label: 'Usuario',
            hint: 'Nombre de usuario',
            prefixIcon: Icons.alternate_email_rounded,
            textInputAction: TextInputAction.next,
            validator: _validateUsername,
            errorText: fieldErrors['username'],
            successText: state.availableFields.contains('username')
                ? 'Usuario disponible'
                : null,
            isChecking: state.validatingFields.contains('username'),
            onChanged: (value) {
              _debouncedValidateField(
                field: 'username',
                value: value,
                canValidate: (text) => text.length >= 4,
              );
            },
          ),
          const Gap(separatorLg),
          AuthTextField(
            controller: _dniController,
            label: 'Cédula',
            hint: 'Número de cédula',
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: _validateDni,
            errorText: fieldErrors['dni'],
            successText: state.availableFields.contains('dni')
                ? 'Cédula disponible'
                : null,
            isChecking: state.validatingFields.contains('dni'),
            onChanged: (value) {
              _debouncedValidateField(
                field: 'dni',
                value: value,
                canValidate: (text) => text.length == 10,
              );
            },
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
            errorText: fieldErrors['email'],
            successText: state.availableFields.contains('email')
                ? 'Correo disponible'
                : null,
            isChecking: state.validatingFields.contains('email'),
            onChanged: (value) {
              _debouncedValidateField(
                field: 'email',
                value: value,
                canValidate: (text) => text.contains('@'),
              );
            },
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
            errorText: fieldErrors['password'],
            onChanged: (_) {
              _clearFieldError('password');
              setState(() {});
            },
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
          AppGradientButton(
            label: 'Crear cuenta',
            isLoading: isLoading,
            onPressed: fieldErrors.isEmpty ? _submit : () {},
          ),
        ],
      ),
    );
  }
}