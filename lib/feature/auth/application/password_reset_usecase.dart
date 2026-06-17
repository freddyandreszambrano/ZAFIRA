import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/password_reset_interface.dart';
import '../domain/password_reset_confirm.dart';

class PasswordResetUseCase with ErrorExceptionHandler {
  PasswordResetUseCase(this._repository);

  final IPasswordReset _repository;

  Future<Either<Exception, void>> requestCode(String email) async {
    const methodName = 'PASSWORD_RESET_REQUEST';
    DebugLogger(runtimeType).methodInit(methodName);
    return handlerApiExceptions(
      () async => await _repository.requestCode(email),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, void>> confirmReset(PasswordResetConfirm data) async {
    const methodName = 'PASSWORD_RESET_CONFIRM';
    DebugLogger(runtimeType).methodInit(methodName);
    return handlerApiExceptions(
      () async => await _repository.confirmReset(data),
      methodName,
      runtimeType,
    );
  }
}
