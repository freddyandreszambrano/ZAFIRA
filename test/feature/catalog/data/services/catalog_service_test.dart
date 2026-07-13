import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/catalog/data/services/catalog_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte la lista HTTP en productos tipados', () async {
    final service = CatalogService(
      remoteDataSource: stubDioHttpClient(
        stubDioOk([
          {
            'id': 1,
            'name': 'Chaqueta',
            'price': '25',
            'sizes': <String>[],
            'colors': <String>[],
            'image_urls': <String>[],
            'color_options': <Object?>[],
          },
        ]),
      ),
    );

    final products = await service.getProducts();

    expect(products.single.name, 'Chaqueta');
  });
}
