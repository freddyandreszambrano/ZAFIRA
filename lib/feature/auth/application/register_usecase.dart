import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/register_interface.dart';
import '../domain/register_request.dart';

class RegisterUseCase with ErrorExceptionHandler {
  RegisterUseCase(this._repository);

  final IRegister _repository;

  Future<Either<Exception, void>> register(RegisterRequest request) async {
    const methodName = 'REGISTER_USER';
    DebugLogger(runtimeType).methodInit(methodName);

    return handlerApiExceptions(
          () async => await _repository.createUser(request),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, Map<String, dynamic>>> validateField({
    required String field,
    required String value,
  }) async {
    const methodName = 'VALIDATE_REGISTER_FIELD';
    DebugLogger(runtimeType).methodInit(methodName);

    return handlerApiExceptions(
          () async => await _repository.validateField(
        field: field,
        value: value,
      ),
      methodName,
      runtimeType,
    );
  }
}