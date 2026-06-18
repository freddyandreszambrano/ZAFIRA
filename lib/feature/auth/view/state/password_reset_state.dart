import '../../../../core/enum/response_status.dart';

class PasswordResetState {
  PasswordResetState({
    required this.status,
    this.errorMessage,
  });

  factory PasswordResetState.initial() =>
      PasswordResetState(status: ResponseStatus.initial);

  final ResponseStatus status;
  final String? errorMessage;

  PasswordResetState copyWith({
    ResponseStatus? status,
    String? errorMessage,
  }) {
    return PasswordResetState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}