import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

/// Campo de texto del flujo de autenticación (tema oscuro del login).
///
/// La decoración vive en un único lugar (acá), evitando repetir
/// `InputDecoration` en cada campo. Solo usa tokens de
/// `context.appColors` / `context.typography` y constantes de `app_numbers`.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.textInputAction,
    this.validator,
    this.suffixIcon,
    this.labelTrailing,
    this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;

  /// Acción opcional alineada a la derecha del label (ej. "¿Olvidaste...?").
  final Widget? labelTrailing;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: context.typography.labelMedium?.copyWith(
                  color: colors.slateSoft,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (labelTrailing != null) labelTrailing!,
          ],
        ),
        const Gap(separatorSm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onFieldSubmitted: onSubmitted,
          cursorColor: colors.primary,
          style: context.typography.bodyLarge?.copyWith(color: colors.white),
          decoration: _decoration(context),
        ),
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final colors = context.appColors;

    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: kBorderRadiusAllMedium,
          borderSide: BorderSide(color: color, width: width),
        );

    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: colors.nightInput,
      hintText: hint,
      hintStyle: context.typography.bodyMedium?.copyWith(color: colors.slate),
      prefixIcon: Icon(prefixIcon, color: colors.slate, size: 20),
      suffixIcon: suffixIcon,
      contentPadding: kSpaceDeviceHVMd,
      enabledBorder: border(colors.nightBorder),
      focusedBorder: border(colors.primary, 1.4),
      errorBorder: border(colors.error),
      focusedErrorBorder: border(colors.error, 1.4),
      errorStyle: context.typography.bodySmall?.copyWith(color: colors.error),
    );
  }
}
