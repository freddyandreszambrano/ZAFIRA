enum OnboardingStep {
  gender('gender'),
  size('preferred_size');

  const OnboardingStep(this.field);

  final String field;

  static OnboardingStep? fromField(String field) {
    for (final step in OnboardingStep.values) {
      if (step.field == field) return step;
    }
    return null;
  }

  static List<OnboardingStep> fromFields(List<String> fields) {
    final steps = <OnboardingStep>[];
    for (final field in fields) {
      final step = fromField(field);
      if (step != null && !steps.contains(step)) steps.add(step);
    }
    return steps.isEmpty ? OnboardingStep.values.toList() : steps;
  }
}
