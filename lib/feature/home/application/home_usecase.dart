import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/home_interface.dart';
import '../data/repositories/home_repository.dart';
import '../domain/home_dashboard.dart';

final homeUseCaseProvider = Provider<HomeUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeUseCase(repository);
});

class HomeUseCase with ErrorExceptionHandler {
  HomeUseCase(this._repository);

  final IHomeRepository _repository;

  Future<Either<Exception, HomeDashboard>> getDashboardProducts() {
    const methodName = 'GET_HOME_DASHBOARD_PRODUCTS';
    DebugLogger(runtimeType).methodInit(methodName);

    return handlerApiExceptions(
      () async =>
          HomeDashboard.fromProducts(await _repository.getDashboardProducts()),
      methodName,
      runtimeType,
    );
  }
}
