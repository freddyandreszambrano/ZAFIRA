import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/utils/logger.dart';
import '../../../../modules/common/exceptions/regular_exception.dart';
import '../../../../modules/common/exceptions/server_exception.dart';
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
            failedLoginAttempts: state.failedLoginAttempts + 1,
            errorMessage: _extractLoginErrorMessage(err),
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
            failedLoginAttempts: 0,
            errorMessage: null,
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

  String _extractLoginErrorMessage(Exception err) {
    const fallback =
        'No pudimos iniciar sesión. Verifica tu usuario y contraseña e inténtalo nuevamente.';

    dynamic data;
    if (err is ServerException) {
      data = err.message;
    } else if (err is RegularException) {
      data = err.message;
    }

    if (data is Map && data['message'] is String) {
      final message = data['message'] as String;
      if (message.isNotEmpty) return message;
    }

    return fallback;
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    state = state.copyWith(
      profileState: ResponseStatus.loading,
      errorMessage: null,
    );

    final response = await _tokenUseCase.updateProfile(data);

    return response.fold(
          (err) {
        state = state.copyWith(
          profileState: ResponseStatus.error,
          errorMessage: 'No se pudo actualizar el perfil.',
        );

        return false;
      },
          (model) {
        state = state.copyWith(
          profileState: ResponseStatus.success,
          user: model.user,
          errorMessage: null,
        );

        return true;
      },
    );
  }

  Future<bool> updateAvatar(String filePath) async {
    state = state.copyWith(
      profileState: ResponseStatus.loading,
      errorMessage: null,
    );

    final response = await _tokenUseCase.updateAvatar(filePath);

    return response.fold(
      (err) {
        state = state.copyWith(
          profileState: ResponseStatus.error,
          errorMessage: 'No se pudo actualizar la foto de perfil.',
        );

        return false;
      },
      (model) {
        state = state.copyWith(
          profileState: ResponseStatus.success,
          user: model.user,
          errorMessage: null,
        );

        return true;
      },
    );
  }

  Future<bool> deleteAvatar() async {
    state = state.copyWith(
      profileState: ResponseStatus.loading,
      errorMessage: null,
    );

    final response = await _tokenUseCase.deleteAvatar();

    return response.fold(
      (err) {
        state = state.copyWith(
          profileState: ResponseStatus.error,
          errorMessage: 'No se pudo eliminar la foto de perfil.',
        );

        return false;
      },
      (model) {
        state = state.copyWith(
          profileState: ResponseStatus.success,
          user: model.user,
          errorMessage: null,
        );

        return true;
      },
    );
  }

  Future<bool> updateTryOnPhoto(String filePath) async {
    state = state.copyWith(
      profileState: ResponseStatus.loading,
      errorMessage: null,
    );

    final response = await _tokenUseCase.updateTryOnPhoto(filePath);

    return response.fold(
      (err) {
        state = state.copyWith(
          profileState: ResponseStatus.error,
          errorMessage: 'No se pudo guardar la foto.',
        );

        return false;
      },
      (model) {
        state = state.copyWith(
          profileState: ResponseStatus.success,
          user: model.user,
          errorMessage: null,
        );

        return true;
      },
    );
  }

  Future<bool> deleteTryOnPhoto() async {
    state = state.copyWith(
      profileState: ResponseStatus.loading,
      errorMessage: null,
    );

    final response = await _tokenUseCase.deleteTryOnPhoto();

    return response.fold(
      (err) {
        state = state.copyWith(
          profileState: ResponseStatus.error,
          errorMessage: 'No se pudo eliminar la foto.',
        );

        return false;
      },
      (model) {
        state = state.copyWith(
          profileState: ResponseStatus.success,
          user: model.user,
          errorMessage: null,
        );

        return true;
      },
    );
  }

  Future<void> logout() async {
    await _tokenUseCase.removeToken();
    state = AuthState.initial();
  }

  void clearLoginError() {
    if (state.errorMessage == null) return;

    state = state.copyWith(
      clearErrorMessage: true,
    );
  }

  Future<void> bootstrap({required bool isWeb}) async {
    _serverUseCase();
    await getVersion();

    try {
      final hasToken = await _tokenUseCase.checkToken();

      state = state.copyWith(
        isTokenExist: hasToken,
        status: hasToken ? ResponseStatus.success : ResponseStatus.initial,
      );

      if (hasToken) {
        await _loadCurrentUser();
      }
    } catch (_) {
      state = state.copyWith(
        isTokenExist: false,
        status: ResponseStatus.initial,
      );
    }
  }

  Future<void> _loadCurrentUser() async {
    final response = await _tokenUseCase.getCurrentUser();

    await response.fold<Future<void>>(
      (err) async {
        final isUnauthorized = err is ServerException && err.statusCode == 401;
        if (isUnauthorized) {
          await logout();
        }
        // Si falló por otra razón (ej. sin conexión), se mantiene la
        // sesión local y se reintentará en la próxima pantalla.
      },
      (model) async {
        state = state.copyWith(user: model.user);
      },
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