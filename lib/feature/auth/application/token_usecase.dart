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

  Future<void> removeToken() async {
    try {
      return await interface.removeToken();
    } catch (err) {
      throw RegularException.fromError(err, "removeToken", runtimeType);
    }
  }

  Future<void> saveToken(String token) async {
    try {
      await interface.saveToken(token);
    } catch (err) {
      throw RegularException.fromError(err, "saveToken", runtimeType);
    }
  }

  Future<bool> checkToken() async {
    try {
      return await interface.checkToken();
    } catch (err) {
      throw RegularException.fromError(err, "checkToken", runtimeType);
    }
  }
}
