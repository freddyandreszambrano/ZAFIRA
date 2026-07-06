import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/try_on_interface.dart';
import '../domain/try_on_job_model.dart';

class TryOnUseCase with ErrorExceptionHandler {
  TryOnUseCase(this.interface);

  final ITryOn interface;

  Future<Either<Exception, TryOnJobModel>> createJob(
    List<int> productIds,
  ) async {
    const String methodName = "CREATE_TRY_ON_JOB";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.createJob(productIds),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, TryOnJobModel>> getJob(String jobId) async {
    const String methodName = "GET_TRY_ON_JOB";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.getJob(jobId),
      methodName,
      runtimeType,
    );
  }
}
