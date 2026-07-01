import '../../../../core/enum/response_status.dart';

class RegisterState {
  RegisterState({
    required this.status,
    this.errorMessage,
    this.fieldErrors = const {},
    this.validatingFields = const {},
    this.availableFields = const {},
  });

  factory RegisterState.initial() => RegisterState(
    status: ResponseStatus.initial,
    fieldErrors: const {},
    validatingFields: const {},
    availableFields: const {},
  );

  final ResponseStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;
  final Set<String> validatingFields;
  final Set<String> availableFields;

  RegisterState copyWith({
    ResponseStatus? status,
    String? errorMessage,
    Map<String, String>? fieldErrors,
    Set<String>? validatingFields,
    Set<String>? availableFields,
  }) => RegisterState(
    status: status ?? this.status,
    errorMessage: errorMessage,
    fieldErrors: fieldErrors ?? this.fieldErrors,
    validatingFields: validatingFields ?? this.validatingFields,
    availableFields: availableFields ?? this.availableFields,
  );

  RegisterState clearErrors() => copyWith(
    errorMessage: null,
    fieldErrors: const {},
    availableFields: const {},
  );
}
