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
    final (label, color, fraction) = switch (_strength(password)) {
      0 => ('Débil', colors.error, 0.33),
      1 => ('Media', colors.warning, 0.66),
      _ => ('Fuerte', colors.success, 1.0),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Seguridad de la contraseña',
                style: context.typography.bodySmall?.copyWith(
                  color: colors.slate,
                ),
              ),
            ),
            Text(
              label,
              style: context.typography.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Gap(separatorXSm),
        ClipRRect(
          borderRadius: kBorderRadiusAllSmall,
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 4,
            backgroundColor: colors.nightBorder.withValues(alpha: 0.5),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  int _strength(String pwd) {
    var hasUpper = false;
    var hasLower = false;
    var hasDigit = false;
    var hasSpecial = false;

    for (final c in pwd.codeUnits) {
      if (c >= 65 && c <= 90) {
        hasUpper = true;
      } else if (c >= 97 && c <= 122) {
        hasLower = true;
      } else if (c >= 48 && c <= 57) {
        hasDigit = true;
      } else {
        hasSpecial = true;
      }
    }

    final variety = [
      hasUpper,
      hasLower,
      hasDigit,
      hasSpecial,
    ].where((e) => e).length;

    var score = 0;
    if (pwd.length >= 8 && variety >= 2) score++;
    if (pwd.length >= 12 && variety >= 3) score++;
    return score;
  }
}
