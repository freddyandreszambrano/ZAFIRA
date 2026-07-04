import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import 'onboarding_step_shell.dart';

class SizeStep extends StatelessWidget {
  const SizeStep({
    required this.value,
    required this.answered,
    required this.onChanged,
    super.key,
  });

  final String value;
  final bool answered;
  final ValueChanged<String> onChanged;

  static const _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];

  @override
  Widget build(BuildContext context) {
    return OnboardingStepShell(
      icon: Icons.checkroom_rounded,
      title: '¿Cuál es tu talla habitual?',
      subtitle: 'Priorizaremos prendas disponibles en tu talla.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: separatorSm,
            runSpacing: separatorSm,
            children: [
              for (final size in _sizes)
                _SizeChip(
                  label: size,
                  selected: value == size,
                  onTap: () => onChanged(size),
                ),
            ],
          ),
          const Gap(separatorLg),
          _UnsureButton(
            selected: answered && value.isEmpty,
            onTap: () => onChanged(''),
          ),
        ],
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  const _SizeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllMedium,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 64,
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? colors.gradientPrimary : null,
          color: selected ? null : colors.nightInput,
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: selected ? Colors.transparent : colors.nightBorder,
          ),
        ),
        child: Text(
          label,
          style: context.typography.titleMedium?.copyWith(
            color: selected ? colors.white : colors.slateSoft,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _UnsureButton extends StatelessWidget {
  const _UnsureButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllMedium,
      child: Padding(
        padding: kSpaceDeviceVXSm,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? colors.primaryLight : colors.slate,
              size: kIconSm,
            ),
            const Gap(separatorSm),
            Text(
              'No estoy seguro/a de mi talla',
              style: context.typography.bodyMedium?.copyWith(
                color: selected ? colors.white : colors.slate,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
