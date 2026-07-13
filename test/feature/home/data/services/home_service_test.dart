import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/home/data/services/home_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte la respuesta del catálogo en productos del inicio', () async {
    final service = HomeService(
      remoteDataSource: stubDioHttpClient(
        stubDioOk([
          {
            'id': 1,
            'name': 'Camisa',
            'price': '19.99',
            'sizes': <String>[],
            'colors': <String>[],
            'image_urls': <String>[],
            'color_options': <Object?>[],
          },
        ]),
      ),
    );

    final products = await service.getDashboardProducts();

    expect(products, hasLength(1));
    expect(products.single.name, 'Camisa');
  });

  test('propaga el error HTTP sin tocar la red', () async {
    final service = HomeService(
      remoteDataSource: stubDioHttpClient(stubDioError()),
    );

    expect(service.getDashboardProducts, throwsA(isA<DioException>()));
  });
}
