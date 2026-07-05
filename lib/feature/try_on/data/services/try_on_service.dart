import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/try_on_job_model.dart';

final tryOnServiceProvider = Provider<TryOnService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return TryOnService(remoteDataSource: remoteDataSource);
});

class TryOnService {
  TryOnService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<TryOnJobModel> createJob(int productId) async {
    const url = '/api/v1/tryon/';

    DebugLogger(runtimeType).request(url, {'product_ids': productId});

    final response = await remoteDataSource().post(
      url,
      data: {
        'product_ids': [productId],
      },
    );

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as Map<String, dynamic>;
    return TryOnJobModel.fromJson(data['job'] as Map<String, dynamic>);
  }

  Future<TryOnJobModel> getJob(String jobId) async {
    final url = '/api/v1/tryon/$jobId/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as Map<String, dynamic>;
    return TryOnJobModel.fromJson(data['job'] as Map<String, dynamic>);
  }
}
