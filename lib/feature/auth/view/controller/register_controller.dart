import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/utils/error_parser.dart';
import '../../application/register_usecase.dart';
import '../../data/repositories/register_repository.dart';
import '../../domain/register_request.dart';
import '../state/register_state.dart';

final registerControllerProvider =
StateNotifierProvider.autoDispose<RegisterController, RegisterState>((ref) {
  return RegisterController(
    RegisterUseCase(ref.watch(registerRepositoryProvider)),
  );
});

class RegisterController extends StateNotifier<RegisterState> {
  RegisterController(this._registerUseCase) : super(RegisterState.initial());

  final RegisterUseCase _registerUseCase;

  Future<void> register(RegisterRequest request) async {
    state = state.copyWith(
      status: ResponseStatus.loading,
      errorMessage: null,
      fieldErrors: const {},
      availableFields: const {},
    );

    final result = await _registerUseCase.register(request);

    result.fold(
          (err) {
        final fieldErrors = parseFieldErrors(err);

        state = state.copyWith(
          status: ResponseStatus.error,
          errorMessage: fieldErrors.isEmpty ? parseErrorMessage(err) : null,
          fieldErrors: fieldErrors,
          availableFields: const {},
        );
      },
          (_) => state = state.copyWith(
        status: ResponseStatus.success,
        errorMessage: null,
        fieldErrors: const {},
        validatingFields: const {},
        availableFields: const {},
      ),
    );
  }

  Future<void> validateField({
    required String field,
    required String value,
  }) async {
    final text = value.trim();

    if (text.isEmpty) {
      clearFieldStatus(field);
      return;
    }

    final validating = Set<String>.from(state.validatingFields)..add(field);

    state = state.copyWith(
      validatingFields: validating,
      errorMessage: null,
    );

    final result = await _registerUseCase.validateField(
      field: field,
      value: text,
    );

    final validatingFinished = Set<String>.from(state.validatingFields)
      ..remove(field);

    result.fold(
          (_) {
        state = state.copyWith(
          validatingFields: validatingFinished,
        );
      },
          (data) {
        final exists = data['exists'] == true;
        final message = (data['message'] ?? '').toString();

        final updatedErrors = Map<String, String>.from(state.fieldErrors);
        final updatedAvailable = Set<String>.from(state.availableFields);

        if (exists && message.isNotEmpty) {
          updatedErrors[field] = message;
          updatedAvailable.remove(field);
        } else {
          updatedErrors.remove(field);
          updatedAvailable.add(field);
        }

        state = state.copyWith(
          fieldErrors: updatedErrors,
          validatingFields: validatingFinished,
          availableFields: updatedAvailable,
          errorMessage: null,
        );
      },
    );
  }

  void clearFieldStatus(String field) {
    final updatedErrors = Map<String, String>.from(state.fieldErrors)
      ..remove(field);

    final updatedAvailable = Set<String>.from(state.availableFields)
      ..remove(field);

    final updatedValidating = Set<String>.from(state.validatingFields)
      ..remove(field);

    state = state.copyWith(
      fieldErrors: updatedErrors,
      availableFields: updatedAvailable,
      validatingFields: updatedValidating,
      errorMessage: null,
    );
  }

  void clearFieldError(String field) {
    clearFieldStatus(field);
  }
}