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
    state = state.copyWith(status: ResponseStatus.loading);
    final result = await _registerUseCase.register(request);
    result.fold(
      (err) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: parseErrorMessage(err),
      ),
      (_) => state = state.copyWith(status: ResponseStatus.success),
    );
  }
}
