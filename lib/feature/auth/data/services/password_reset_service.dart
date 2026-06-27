import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/password_reset_confirm.dart';

final passwordResetServiceProvider = Provider<PasswordResetService>((ref) {
  return PasswordResetService(
    remoteDataSource: ref.watch(dioHttpClientProvider),
  );
});

class PasswordResetService {
  PasswordResetService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<void> requestCode(String email) async {
    const url = '/api/v1/auth/password-reset/request/';
    DebugLogger(runtimeType).request(url);
    final response = await remoteDataSource().post(url, data: {'email': email});
    DebugLogger(runtimeType).response(url, [response.statusCode]);
  }

  Future<void> confirmReset(PasswordResetConfirm data) async {
    const url = '/api/v1/auth/password-reset/confirm/';
    DebugLogger(runtimeType).request(url);
    final response = await remoteDataSource().post(url, data: data.toJson());
    DebugLogger(runtimeType).response(url, [response.statusCode]);
  }
}
