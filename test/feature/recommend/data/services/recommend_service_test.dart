import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/recommend/data/services/recommend_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte un outfit recomendado en modelo de dominio', () async {
    final service = RecommendService(
      http: stubDioHttpClient(
        stubDioOk({
          'occasion': 'fiesta',
          'gender': 'hombre',
          'store': 'all',
          'outfits': [
            {
              'top': {
                'id': 1,
                'name': 'Camisa',
                'price': '20',
                'sizes': <String>[],
                'colors': <String>[],
                'image_urls': <String>[],
                'color_options': <Object?>[],
              },
            },
          ],
        }),
      ),
    );

    final result = await service.getRecommendation(occasion: 'fiesta');

    expect(result.outfits.single.top.name, 'Camisa');
  });
}
