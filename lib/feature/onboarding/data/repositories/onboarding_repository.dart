import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../interfaces/onboarding_interface.dart';
import '../services/onboarding_service.dart';

final onboardingRepositoryProvider = Provider<IOnboardingRepository>((ref) {
  final service = ref.watch(onboardingServiceProvider);
  return OnboardingRepository(service: service);
});

class OnboardingRepository implements IOnboardingRepository {
  OnboardingRepository({required this.service});

  final OnboardingService service;

  @override
  Future<void> submit(Map<String, String> answers) => service.submit(answers);
}
