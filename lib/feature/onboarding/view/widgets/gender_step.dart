import 'package:flutter/material.dart';

import 'onboarding_option_grid.dart';
import 'onboarding_step_shell.dart';

class GenderStep extends StatelessWidget {
  const GenderStep({required this.value, required this.onChanged, super.key});

  final String value;
  final ValueChanged<String> onChanged;

  static const _options = [
    OnboardingOption(
      value: 'femenino',
      label: 'Femenino',
      icon: Icons.female_rounded,
    ),
    OnboardingOption(
      value: 'masculino',
      label: 'Masculino',
      icon: Icons.male_rounded,
    ),
    OnboardingOption(
      value: 'otro',
      label: 'Otro',
      icon: Icons.transgender_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return OnboardingStepShell(
      icon: Icons.person_outline_rounded,
      title: '¿Con qué género te identificas?',
      subtitle:
          'Nos ayuda a recomendarte prendas y tallas que se ajusten mejor a ti.',
      child: OnboardingOptionGrid(
        options: _options,
        selectedValue: value,
        onSelected: onChanged,
      ),
    );
  }
}
