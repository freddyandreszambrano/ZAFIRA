import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/utils/error_parser.dart';
import '../../application/password_reset_usecase.dart';
import '../../data/repositories/password_reset_repository.dart';
import '../../domain/password_reset_confirm.dart';
import '../state/password_reset_state.dart';

final passwordResetControllerProvider =
    StateNotifierProvider.autoDispose<PasswordResetController,
        PasswordResetState>((ref) {
  return PasswordResetController(
    PasswordResetUseCase(ref.watch(passwordResetRepositoryProvider)),
  );
});

class PasswordResetController extends StateNotifier<PasswordResetState> {
  PasswordResetController(this._useCase) : super(PasswordResetState.initial());

  final PasswordResetUseCase _useCase;

  Future<void> requestCode(String email) async {
    state = state.copyWith(status: ResponseStatus.loading);
    final result = await _useCase.requestCode(email);
    result.fold(
      (err) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: parseErrorMessage(err),
      ),
      (_) => state = state.copyWith(status: ResponseStatus.success),
    );
  }

  Future<void> confirmReset(PasswordResetConfirm data) async {
    state = state.copyWith(status: ResponseStatus.loading);
    final result = await _useCase.confirmReset(data);
    result.fold(
      (err) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: parseErrorMessage(err),
      ),
      (_) => state = state.copyWith(status: ResponseStatus.success),
    );
  }
}
