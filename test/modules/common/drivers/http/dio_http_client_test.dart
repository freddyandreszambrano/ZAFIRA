import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/core/flavors/flavors_config.dart';
import 'package:zafira/modules/common/drivers/http/dio_http_client.dart';
import 'package:zafira/modules/common/drivers/storage/local_storage.dart';

class _FakeLocalStorage implements LocalStorage {
  @override
  Future<bool> containsItem(String key) async => false;

  @override
  Future<String?> getItem(String key) async => null;

  @override
  Future<void> removeAll() async {}

  @override
  Future<void> removeItem(String key) async {}

  @override
  Future<void> setItem(String key, String value) async {}
}

void main() {
  test('incluye app-version en cada solicitud HTTP', () async {
    Flavor.projectVersion = '1.2.3';
    final dio = DioHttpClient(_FakeLocalStorage())();

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.headers['app-version'], '1.2.3');
          handler.resolve(Response(requestOptions: options, statusCode: 200));
        },
      ),
    );

    await dio.get<void>('/headers');
  });
}
