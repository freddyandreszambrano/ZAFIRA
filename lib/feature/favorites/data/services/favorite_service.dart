import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../../catalog/domain/product_model.dart';

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

    final response = await remoteDataSource().get(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List;
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addFavorite(int productId) async {
    const url = '/api/v1/catalog/favorites/';
    final body = {'product_id': productId};

    DebugLogger(runtimeType).request(url, body);

    final response = await remoteDataSource().post(url, data: body);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 201;
  }

  Future<bool> removeFavorite(int productId) async {
    final url = '/api/v1/catalog/favorites/$productId/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().delete(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return response.statusCode == 200;
  }
}
