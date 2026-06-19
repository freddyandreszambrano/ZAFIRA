import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/register_request.dart';

final registerServiceProvider = Provider<RegisterService>((ref) {
  return RegisterService(remoteDataSource: ref.watch(dioHttpClientProvider));
});

class RegisterService {
  RegisterService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<void> createUser(RegisterRequest request) async {
    const url = '/api/v1/user/create/';
    DebugLogger(runtimeType).request(url);
    final response = await remoteDataSource().post(url, data: request.toJson());
    DebugLogger(runtimeType).response(url, [response.statusCode]);
  }

  Future<Map<String, dynamic>> validateField({
    required String field,
    required String value,
  }) async {
    const url = '/api/v1/user/validate-field/';
    final body = {
      'field': field,
      'value': value,
    };

    DebugLogger(runtimeType).request(url, body);

    final response = await remoteDataSource().post(url, data: body);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return Map<String, dynamic>.from(response.data);
  }
}