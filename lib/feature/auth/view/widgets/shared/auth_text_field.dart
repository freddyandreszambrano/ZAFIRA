import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

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
    this.errorText,
    this.onChanged,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.successText,
    this.isChecking = false,
    this.hasExternalError = false,
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
  final Widget? labelTrailing;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode autovalidateMode;

  // NUEVO
  final String? successText;
  final bool isChecking;
  final bool hasExternalError;

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
            ?labelTrailing,
          ],
        ),
        const Gap(separatorSm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          textInputAction: textInputAction,
          validator: validator,
          autovalidateMode: autovalidateMode,
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          cursorColor: colors.primary,
          style: context.typography.bodyLarge?.copyWith(color: colors.white),
          decoration: _decoration(context),
        ),

        // Loader mientras valida
        if (isChecking) ...[
          const Gap(separatorXSm),
          Row(
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
              const Gap(separatorSm),
              Text(
                'Verificando...',
                style: context.typography.bodySmall?.copyWith(
                  color: colors.slate,
                ),
              ),
            ],
          ),
        ],

        // Mensaje verde
        if (!isChecking && successText != null && successText!.isNotEmpty) ...[
          const Gap(separatorXSm),
          Row(
            children: [
              Icon(Icons.check_circle_rounded, size: 16, color: colors.success),
              const Gap(separatorSm),
              Text(
                successText!,
                style: context.typography.bodySmall?.copyWith(
                  color: colors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
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
      enabledBorder: border(
        hasExternalError ? colors.error : colors.nightBorder,
        hasExternalError ? 1.4 : 1,
      ),
      focusedBorder: border(
        hasExternalError ? colors.error : colors.primary,
        1.4,
      ),
      errorBorder: border(colors.error),
      focusedErrorBorder: border(colors.error, 1.4),
      errorText: errorText,
      errorStyle: context.typography.bodySmall?.copyWith(color: colors.error),
    );
  }
}
