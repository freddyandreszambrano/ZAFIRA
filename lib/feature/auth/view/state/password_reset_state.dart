import '../../../../core/enum/response_status.dart';

class PasswordResetState {
  const PasswordResetState({
    required this.status,
    this.errorMessage,
  });

  factory PasswordResetState.initial() => const PasswordResetState(
    status: ResponseStatus.initial,
    errorMessage: null,
  );

  final ResponseStatus status;
  final String? errorMessage;

  PasswordResetState copyWith({
    ResponseStatus? status,
    String? errorMessage,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}