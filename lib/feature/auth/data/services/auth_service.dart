import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/auth_token_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return AuthService(
    remoteDataSource: remoteDataSource,
  );
});

class AuthService {
  AuthService({
    required this.remoteDataSource,
  });

  final DioHttpClient remoteDataSource;

  Future<AuthTokenModel> getToken(String username, String password) async {
    const url = "/api-auth-token";
    final body = {"username": username, "password": password};
    DebugLogger(runtimeType).request(url, body);
    final response = await remoteDataSource().post(url, data: body);
    DebugLogger(runtimeType)
        .response(url, [response.statusCode, response.data]);
    return AuthTokenModel.fromJson(response.data);
  }

  void showServerUrl() {
    InformationLogger(runtimeType)
        .regular("server_url: ${remoteDataSource().options.baseUrl}");
  }
}
