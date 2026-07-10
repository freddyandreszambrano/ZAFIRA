import 'package:either_dart/either.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/error/mixin_error_controller.dart';
import '../../catalog/domain/product_model.dart';
import '../data/interfaces/favorite_interface.dart';
import '../domain/favorite_outfit_model.dart';

class FavoriteUseCase with ErrorExceptionHandler {
  FavoriteUseCase(this.interface);

  final IFavorite interface;

  Future<Either<Exception, List<ProductModel>>> getFavorites() async {
    const String methodName = "GET_FAVORITES";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.getFavorites(),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, bool>> addFavorite(int productId) async {
    const String methodName = "ADD_FAVORITE";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.addFavorite(productId),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, bool>> removeFavorite(int productId) async {
    const String methodName = "REMOVE_FAVORITE";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.removeFavorite(productId),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, List<FavoriteOutfitModel>>>
  getFavoriteOutfits() async {
    const String methodName = "GET_FAVORITE_OUTFITS";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.getFavoriteOutfits(),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, bool>> saveFavoriteOutfit({
    required int topId,
    required int bottomId,
    required String resultImageUrl,
  }) async {
    const String methodName = "SAVE_FAVORITE_OUTFIT";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.saveFavoriteOutfit(
        topId: topId,
        bottomId: bottomId,
        resultImageUrl: resultImageUrl,
      ),
      methodName,
      runtimeType,
    );
  }

  Future<Either<Exception, bool>> removeFavoriteOutfit(int outfitId) async {
    const String methodName = "REMOVE_FAVORITE_OUTFIT";
    DebugLogger(runtimeType).methodInit(methodName);

    return await handlerApiExceptions(
      () async => await interface.removeFavoriteOutfit(outfitId),
      methodName,
      runtimeType,
    );
  }
}
