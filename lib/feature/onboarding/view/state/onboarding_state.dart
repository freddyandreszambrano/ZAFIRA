import '../../../../core/enum/response_status.dart';

class OnboardingState {
  const OnboardingState({
    required this.status,
    required this.pageIndex,
    required this.answers,
    this.errorMessage,
  });

  factory OnboardingState.initial() => const OnboardingState(
    status: ResponseStatus.initial,
    pageIndex: 0,
    answers: <String, String>{},
  );

  final ResponseStatus status;
  final int pageIndex;
  final Map<String, String> answers;
  final String? errorMessage;

  OnboardingState copyWith({
    ResponseStatus? status,
    int? pageIndex,
    Map<String, String>? answers,
    String? errorMessage,
  }) => OnboardingState(
    status: status ?? this.status,
    pageIndex: pageIndex ?? this.pageIndex,
    answers: answers ?? this.answers,
    errorMessage: errorMessage,
  );
}
