import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product_model.dart';
import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';

final homeServiceProvider = Provider<HomeService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return HomeService(remoteDataSource: remoteDataSource);
});

class HomeService {
  HomeService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<List<ProductModel>> getDashboardProducts() async {
    const url = '/api/v1/catalog/products/';
    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<List<Object?>>(url);
    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as List<Object?>;
    return data
        .whereType<Map<String, Object?>>()
        .map(ProductModel.fromJson)
        .toList();
  }
}
