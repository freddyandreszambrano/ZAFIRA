import '../../../../core/enum/response_status.dart';

class RegisterState {
  RegisterState({required this.status, this.errorMessage});

  factory RegisterState.initial() =>
      RegisterState(status: ResponseStatus.initial);

  final ResponseStatus status;
  final String? errorMessage;

  RegisterState copyWith({ResponseStatus? status, String? errorMessage}) =>
      RegisterState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
