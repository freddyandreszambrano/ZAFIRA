import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../../../core/models/product_model.dart';
import '../../domain/favorite_outfit_model.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return FavoriteService(remoteDataSource: remoteDataSource);
});

class FavoriteService {
  FavoriteService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<List<ProductModel>> getFavorites() async {
    const url = '/api/v1/catalog/favorites/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<List<Object?>>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List<Object?>;
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, Object?>))
        .toList();
  }

  Future<bool> addFavorite(int productId) async {
    const url = '/api/v1/catalog/favorites/';
    final body = {'product_id': productId};

    DebugLogger(runtimeType).request(url, body);

    final response = await remoteDataSource().post<void>(url, data: body);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 201;
  }

  Future<bool> removeFavorite(int productId) async {
    final url = '/api/v1/catalog/favorites/$productId/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().delete<void>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 200;
  }

  Future<List<FavoriteOutfitModel>> getFavoriteOutfits() async {
    const url = '/api/v1/catalog/favorites/outfits/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<List<Object?>>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List<Object?>;
    return data
        .map(
          (item) => FavoriteOutfitModel.fromJson(item as Map<String, Object?>),
        )
        .toList();
  }

  Future<bool> saveFavoriteOutfit({
    required int topId,
    required int bottomId,
    required String resultImageUrl,
  }) async {
    const url = '/api/v1/catalog/favorites/outfits/';
    final body = {
      'top_id': topId,
      'bottom_id': bottomId,
      'result_image_url': resultImageUrl,
    };

    DebugLogger(runtimeType).request(url, body);

    final response = await remoteDataSource().post<void>(url, data: body);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 201;
  }

  Future<bool> removeFavoriteOutfit(int outfitId) async {
    final url = '/api/v1/catalog/favorites/outfits/$outfitId/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().delete<void>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 200;
  }
}
