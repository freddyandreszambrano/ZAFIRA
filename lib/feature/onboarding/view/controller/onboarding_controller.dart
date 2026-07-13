import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../application/onboarding_usecase.dart';
import '../state/onboarding_state.dart';

final onboardingControllerProvider =
    StateNotifierProvider.autoDispose<OnboardingController, OnboardingState>(
      (ref) => OnboardingController(ref.watch(onboardingUseCaseProvider)),
    );

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._onboardingUseCase)
    : super(OnboardingState.initial());

  final OnboardingUseCase _onboardingUseCase;

  void setAnswer(String field, String value) {
    final answers = Map<String, String>.from(state.answers)..[field] = value;
    state = state.copyWith(answers: answers);
  }

  void goTo(int index) => state = state.copyWith(pageIndex: index);

  Future<void> submit() async {
    state = state.copyWith(status: ResponseStatus.loading, errorMessage: null);

    final response = await _onboardingUseCase.submit(state.answers);

    response.fold(
      (_) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: 'No pudimos guardar tu información. Inténtalo de nuevo.',
      ),
      (_) => state = state.copyWith(
        status: ResponseStatus.success,
        errorMessage: null,
      ),
    );
  }
}
