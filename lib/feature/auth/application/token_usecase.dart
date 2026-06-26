import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../../../modules/common/exceptions/regular_exception.dart';
import '../data/interfaces/auth_interface.dart';
import '../domain/auth_token_model.dart';

class TokenUseCase with ErrorExceptionHandler {
  TokenUseCase(this.interface);

  final IAuth interface;

  Future<Either<Exception, AuthTokenModel>> getToken(
    String user,
    String password,
  ) async {
    const String methodName = "GET_TOKEN";
    DebugLogger(runtimeType).methodInit(methodName);
    return await handlerApiExceptions(
      () async => await interface.getToken(user, password),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> getCurrentUser() async {
    const String methodName = "GET_CURRENT_USER";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.getCurrentUser(),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> updateProfile(
      Map<String, dynamic> data,
      ) async {
    const String methodName = "UPDATE_PROFILE";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.updateProfile(data),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> updateAvatar(
      String filePath,
      ) async {
    const String methodName = "UPDATE_AVATAR";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.updateAvatar(filePath),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> deleteAvatar() async {
    const String methodName = "DELETE_AVATAR";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.deleteAvatar(),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> updateTryOnPhoto(
      String filePath,
      ) async {
    const String methodName = "UPDATE_TRY_ON_PHOTO";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.updateTryOnPhoto(filePath),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, AuthTokenModel>> deleteTryOnPhoto() async {
    const String methodName = "DELETE_TRY_ON_PHOTO";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
          () async => await interface.deleteTryOnPhoto(),
      methodName,
      runtimeType,
    );
  }

  Future<void> removeToken() async {
    try {
      return await interface.removeToken();
    } catch (err) {
      throw RegularException.fromError(
        err,
        "removeToken",
        runtimeType,
      );
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await interface.saveToken(token);
    } catch (err) {
      throw RegularException.fromError(
        err,
        "saveToken",
        runtimeType,
      );
    }
  }

  Future<bool> checkToken() async {
    try {
      return await interface.checkToken();
    } catch (err) {
      throw RegularException.fromError(
        err,
        "checkToken",
        runtimeType,
      );
    }
  }
}
