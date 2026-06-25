import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../data/interfaces/catalog_interface.dart';
import '../domain/product_model.dart';

class CatalogUseCase with ErrorExceptionHandler {
  CatalogUseCase(this.interface);

  final ICatalog interface;

  Future<Either<Exception, List<ProductModel>>> getProducts({
    required String gender,
    required String category,
  }) async {
    const String methodName = "GET_PRODUCTS";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.getProducts(
        gender: gender,
        category: category,
      ),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, ProductModel>> getProductById(int id) async {
    const String methodName = "GET_PRODUCT_BY_ID";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.getProductById(id),
      methodName,
      runtimeType,
    );
  }
}
