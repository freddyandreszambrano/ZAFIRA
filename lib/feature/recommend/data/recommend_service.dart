import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';
import '../../../modules/common/drivers/http/dio_http_client.dart';
import '../domain/recommend_model.dart';

final recommendServiceProvider = Provider<RecommendService>((ref) {
  final http = ref.watch(dioHttpClientProvider);
  return RecommendService(http: http);
});

class RecommendService {
  RecommendService({required this.http});

  final DioHttpClient http;

  Future<RecommendResponseModel> getRecommendation({
    required String occasion,
    String store = 'all',
    String gender = 'hombre',
    List<int> excludeIds = const [],
    List<int> productIds = const [],
  }) async {
    const url = '/api/v1/recommend/';
    final body = {
      'occasion': occasion,
      'store': store,
      'gender': gender,
      'exclude_ids': excludeIds,
      // Modo favoritos: el backend combina solo estas prendas
      if (productIds.isNotEmpty) 'product_ids': productIds,
    };

    DebugLogger(runtimeType).request(url, body);
    final response = await http().post(
      url,
      data: body,
      options: Options(
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
      ),
    );
    DebugLogger(runtimeType).response(url, [response.statusCode]);

    return RecommendResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
