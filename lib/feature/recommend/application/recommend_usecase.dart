import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/recommend_interface.dart';
import '../domain/recommend_model.dart';

class RecommendUseCase with ErrorExceptionHandler {
  RecommendUseCase(this._repository);

  final IRecommend _repository;

  Future<Either<Exception, RecommendResponseModel>> getRecommendation({
    required String occasion,
    String store = 'all',
    String gender = 'hombre',
    List<int> excludeIds = const [],
    List<int> productIds = const [],
  }) async {
    const methodName = 'GET_RECOMMENDATION';
    DebugLogger(runtimeType).methodInit(methodName);

    return handlerApiExceptions(
      () => _repository.getRecommendation(
        occasion: occasion,
        store: store,
        gender: gender,
        excludeIds: excludeIds,
        productIds: productIds,
      ),
      methodName,
      runtimeType,
    );
  }
}
