import 'package:dio/dio.dart';

import 'package:zafira/modules/common/drivers/http/dio_http_client.dart';
import 'package:zafira/modules/common/drivers/storage/local_storage.dart';

DioHttpClient stubDioHttpClient(Dio dio) {
  return DioHttpClient(_FakeLocalStorage(), dio: dio);
}

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
