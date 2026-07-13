import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/auth/data/services/auth_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte la respuesta de login en token tipado', () async {
    final service = AuthService(
      remoteDataSource: stubDioHttpClient(stubDioOk({'token': 'jwt-token'})),
    );

    final token = await service.getToken('zafira', 'secret');

    expect(token.token, 'jwt-token');
  });
}
