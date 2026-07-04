import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class OnboardingOption {
  const OnboardingOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;
}

class OnboardingOptionGrid extends StatelessWidget {
  const OnboardingOptionGrid({
    required this.options,
    required this.selectedValue,
    required this.onSelected,
    super.key,
  });

  final List<OnboardingOption> options;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < options.length; index++) ...[
          _OptionCard(
            option: options[index],
            selected: options[index].value == selectedValue,
            onTap: () => onSelected(options[index].value),
          ),
          if (index < options.length - 1) const Gap(separatorMd),
        ],
      ],
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final OnboardingOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllLarge,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: kOpacityMuted)
              : colors.nightInput,
          borderRadius: kBorderRadiusAllLarge,
          border: Border.all(
            color: selected ? colors.primaryLight : colors.nightBorder,
            width: selected ? kBorderWidthLg : kBorderWidthThin,
          ),
        ),
        child: Row(
          children: [
            Icon(
              option.icon,
              color: selected ? colors.primaryLight : colors.slate,
              size: kIconMd,
            ),
            const Gap(separatorMd),
            Expanded(
              child: Text(
                option.label,
                style: context.typography.labelLarge?.copyWith(
                  color: selected ? colors.white : colors.slateSoft,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: colors.primaryLight,
                size: kIconSm,
              ),
          ],
        ),
      ),
    );
  }
}
