import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/favorites/data/services/favorite_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte favoritos recibidos del servicio HTTP', () async {
    final service = FavoriteService(
      remoteDataSource: stubDioHttpClient(
        stubDioOk([
          {
            'id': 7,
            'name': 'Pantalón',
            'price': '30',
            'sizes': <String>[],
            'colors': <String>[],
            'image_urls': <String>[],
            'color_options': <Object?>[],
          },
        ]),
      ),
    );

    final products = await service.getFavorites();

    expect(products.single.id, 7);
  });
}
