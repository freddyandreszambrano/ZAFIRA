import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../../../core/models/product_model.dart';

final catalogServiceProvider = Provider<CatalogService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return CatalogService(remoteDataSource: remoteDataSource);
});

class CatalogService {
  CatalogService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<List<ProductModel>> getProducts({
    String? gender,
    String? category,
    int? limit,
    int? offset,
  }) async {
    const url = '/api/v1/catalog/products/';
    final queryParameters = {
      'gender': ?gender,
      'category': ?category,
      if (limit != null) 'limit': '$limit',
      if (offset != null) 'offset': '$offset',
    };

    DebugLogger(runtimeType).request(url, queryParameters);

    final response = await remoteDataSource().get<List<Object?>>(
      url,
      queryParameters: queryParameters,
    );

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List<Object?>;
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, Object?>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final url = '/api/v1/catalog/products/$id/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<Map<String, Object?>>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return ProductModel.fromJson(response.data as Map<String, Object?>);
  }

  /// Consulta la página oficial de la tienda en este momento y devuelve
  /// el producto con precio y tallas reales.
  Future<ProductModel> getLiveProduct(int id) async {
    final url = '/api/v1/catalog/products/$id/live/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<Map<String, Object?>>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as Map<String, Object?>;
    return ProductModel.fromJson(data['product'] as Map<String, Object?>);
  }
}
