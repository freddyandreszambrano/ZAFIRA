import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/onboarding_interface.dart';
import '../data/repositories/onboarding_repository.dart';

final onboardingUseCaseProvider = Provider<OnboardingUseCase>((ref) {
  final repository = ref.watch(onboardingRepositoryProvider);
  return OnboardingUseCase(repository);
});

class OnboardingUseCase with ErrorExceptionHandler {
  OnboardingUseCase(this._repository);

  final IOnboardingRepository _repository;

  Future<Either<Exception, void>> submit(Map<String, String> answers) {
    const methodName = 'SUBMIT_ONBOARDING';
    DebugLogger(runtimeType).methodInit(methodName);

    return handlerApiExceptions(
      () => _repository.submit(answers),
      methodName,
      runtimeType,
    );
  }
}
