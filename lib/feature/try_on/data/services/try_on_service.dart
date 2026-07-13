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

  Future<TryOnJobModel> createJob(List<int> productIds) async {
    const url = '/api/v1/tryon/';

    DebugLogger(runtimeType).request(url, {'product_ids': productIds});

    final response = await remoteDataSource().post<Map<String, Object?>>(
      url,
      data: {'product_ids': productIds},
    );

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as Map<String, Object?>;
    return TryOnJobModel.fromJson(data['job'] as Map<String, Object?>);
  }

  Future<TryOnJobModel> getJob(String jobId) async {
    final url = '/api/v1/tryon/$jobId/';

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get<Map<String, Object?>>(url);

    DebugLogger(runtimeType).response(url, [response.statusCode]);

    final data = response.data as Map<String, Object?>;
    return TryOnJobModel.fromJson(data['job'] as Map<String, Object?>);
  }
}
