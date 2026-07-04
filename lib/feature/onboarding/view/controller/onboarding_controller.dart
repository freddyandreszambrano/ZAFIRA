import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../state/onboarding_state.dart';

final onboardingControllerProvider =
    StateNotifierProvider.autoDispose<OnboardingController, OnboardingState>(
      (ref) => OnboardingController(ref),
    );

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._ref) : super(OnboardingState.initial());

  final Ref _ref;

  void setAnswer(String field, String value) {
    final answers = Map<String, String>.from(state.answers)..[field] = value;
    state = state.copyWith(answers: answers);
  }

  void goTo(int index) => state = state.copyWith(pageIndex: index);

  Future<bool> submit() async {
    state = state.copyWith(status: ResponseStatus.loading, errorMessage: null);

    final ok = await _ref.read(authControllerProvider.notifier).updateProfile({
      ...state.answers,
      'onboarding_completed': true,
    });

    state = state.copyWith(
      status: ok ? ResponseStatus.success : ResponseStatus.error,
      errorMessage: ok
          ? null
          : 'No pudimos guardar tu información. Inténtalo de nuevo.',
    );

    return ok;
  }
}
