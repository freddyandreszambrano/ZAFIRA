import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/utils/error_parser.dart';
import '../../../../core/utils/logger.dart';
import '../../application/server_usecase.dart';
import '../../application/token_usecase.dart';
import '../../data/repositories/auth_repository.dart';
import '../state/auth_state.dart';

final authControllerProvider =
StateNotifierProvider<AuthController, AuthState>((ref) {
  final userRepository = ref.watch(authRepositoryProvider);

  return AuthController(
    ServerUseCase(userRepository),
    TokenUseCase(userRepository),
  );
});

final canViewClientDataProvider = Provider<bool>((ref) {
  return ref.watch(
    authControllerProvider.select(
          (s) => s.user?.canViewClientData ?? false,
    ),
  );
});

class AuthController extends StateNotifier<AuthState> {
  AuthController(
      this._serverUseCase,
      this._tokenUseCase,
      ) : super(AuthState.initial());

  final ServerUseCase _serverUseCase;
  final TokenUseCase _tokenUseCase;

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
            user: model.user,
          );
        },
      );
    } catch (err) {
      await _tokenUseCase.removeToken();

      state = state.copyWith(
        status: ResponseStatus.error,
        isTokenExist: false,
        errorMessage: 'Ocurrió un error, intente nuevamente.',
      );
    }
  }

  Future<void> logout() async {
    await _tokenUseCase.removeToken();
    state = AuthState.initial();
  }

  Future<void> bootstrap({required bool isWeb}) async {
    _serverUseCase();
    await getVersion();

    final hasToken = await _tokenUseCase.checkToken();

    state = state.copyWith(
      isTokenExist: hasToken,
      status: hasToken ? ResponseStatus.success : ResponseStatus.initial,
    );
  }

  Future<void> getVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      state = state.copyWith(
        version: packageInfo.version,
      );
    } catch (err) {
      ErrorLogger(runtimeType).regular(err);
    }
  }
}