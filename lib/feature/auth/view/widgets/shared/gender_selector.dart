import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

class GenderSelector extends StatelessWidget {
  const GenderSelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género',
          style: context.typography.labelMedium?.copyWith(
            color: colors.slateSoft,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(separatorSm),
        Row(
          children: [
            Expanded(
              child: _GenderChip(
                label: 'Masculino',
                value: 'masculino',
                selectedValue: value,
                onTap: onChanged,
              ),
            ),
            const Gap(separatorSm),
            Expanded(
              child: _GenderChip(
                label: 'Femenino',
                value: 'femenino',
                selectedValue: value,
                onTap: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = value == selectedValue;

    return InkWell(
      onTap: () => onTap(value),
      borderRadius: kBorderRadiusAllMedium,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.22)
              : colors.nightInput,
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: selected ? colors.primaryLight : colors.nightBorder,
          ),
        ),
        child: Text(
          label,
          style: context.typography.labelMedium?.copyWith(
            color: selected ? colors.primaryLight : colors.slateSoft,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
