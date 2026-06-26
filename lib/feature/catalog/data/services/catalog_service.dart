import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/product_model.dart';

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
  }) async {
    const url = '/api/v1/catalog/products/';
    final queryParameters = {
      if (gender != null) 'gender': gender,
      if (category != null) 'category': category,
    };

    DebugLogger(runtimeType).request(url, queryParameters);

    final response = await remoteDataSource().get(
      url,
      queryParameters: queryParameters,
    );

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List;
    return data
        .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final url = '/api/v1/catalog/products/$id/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }
}
