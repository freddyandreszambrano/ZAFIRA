import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/utils/error_parser.dart';
import '../../application/token_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../state/auth_state.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
  final userRepository = ref.watch(authRepositoryProvider);

  return AuthController(
    TokenUseCase(userRepository),
  );
});

final canViewClientDataProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(
    authControllerProvider.select((s) => s.user?.canViewClientData ?? false),
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(
    // this._serverUseCase,
    this._tokenUseCase,
    // this._profileUseCase,
    // this._webUseCase,
  ) : super(AuthState.initial());

  // final ServerUseCase _serverUseCase;
  final TokenUseCase _tokenUseCase;

  // final ProfileUseCase _profileUseCase;
  // final WebUseCase _webUseCase;

  Future<void> getToken(String username, String password) async {
    try {
      state = state.copyWith(
        status: ResponseStatus.loading,
        errorMessage: null,
      );

      final response = await _tokenUseCase.getToken(username, password);

      await response.fold<Future<void>>(
        (err) async {
          await _tokenUseCase.removeToken();
          state = state.copyWith(
            status: ResponseStatus.error,
            isTokenExist: false,
            errorMessage: parseErrorMessage(err),
          );
        },
        (model) async {
          if (model.token.isEmpty) {
            state = state.copyWith(
              status: ResponseStatus.error,
              isTokenExist: false,
              errorMessage: 'Token inválido',
            );
            return;
          }

          await _tokenUseCase.saveToken(model.token);

          state = state.copyWith(
            status: ResponseStatus.success,
            isTokenExist: true,
          );
        },
      );
    } catch (err) {
      await _tokenUseCase.removeToken();

      String message = 'Ocurrió un error, intente nuevamente.';

      state = state.copyWith(
        status: ResponseStatus.error,
        isTokenExist: false,
        errorMessage: message,
      );
    }
  }
}
