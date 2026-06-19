import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});

  final String password;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final colors = context.appColors;

    final requirements = [
      _PasswordRequirement(
        label: 'Al menos 8 caracteres',
        valid: password.length >= 8,
      ),
      _PasswordRequirement(
        label: 'Al menos una letra mayúscula',
        valid: RegExp(r'[A-Z]').hasMatch(password),
      ),
      _PasswordRequirement(
        label: 'Al menos una letra minúscula',
        valid: RegExp(r'[a-z]').hasMatch(password),
      ),
      _PasswordRequirement(
        label: 'Al menos un número',
        valid: RegExp(r'\d').hasMatch(password),
      ),
      _PasswordRequirement(
        label: 'Al menos un carácter especial',
        valid: RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\];]').hasMatch(password),
      ),
    ];

    final validCount = requirements.where((item) => item.valid).length;
    final isStrong = validCount == requirements.length;

    return Container(
      width: double.infinity,
      padding: kSpaceDeviceMd,
      decoration: BoxDecoration(
        color: colors.nightCard.withValues(alpha: 0.75),
        borderRadius: kBorderRadiusAllMedium,
        border: Border.all(
          color: isStrong
              ? colors.success.withValues(alpha: 0.45)
              : colors.nightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'La contraseña debe cumplir:',
            style: context.typography.bodySmall?.copyWith(
              color: colors.slateSoft,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(separatorSm),
          for (final requirement in requirements) ...[
            _RequirementRow(requirement: requirement),
            const Gap(separatorXSm),
          ],
        ],
      ),
    );
  }
}

class _PasswordRequirement {
  const _PasswordRequirement({
    required this.label,
    required this.valid,
  });

  final String label;
  final bool valid;
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.requirement});

  final _PasswordRequirement requirement;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = requirement.valid ? colors.success : colors.error;

    return Row(
      children: [
        Icon(
          requirement.valid
              ? Icons.check_circle_rounded
              : Icons.cancel_rounded,
          size: 16,
          color: color,
        ),
        const Gap(separatorSm),
        Expanded(
          child: Text(
            requirement.label,
            style: context.typography.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}