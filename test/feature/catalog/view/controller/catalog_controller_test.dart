import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zafira/feature/catalog/data/interfaces/catalog_interface.dart';
import 'package:zafira/feature/catalog/data/repositories/catalog_repository.dart';
import 'package:zafira/core/models/product_model.dart';
import 'package:zafira/feature/catalog/view/controller/catalog_controller.dart';

class _MockCatalogRepo extends Mock implements ICatalog {}

ProductModel _product({int id = 1}) => ProductModel(
  id: id,
  idExternal: 'ext-$id',
  name: 'Camisa',
  category: 'torso',
  gender: 'hombre',
  url: 'https://tienda.test/$id',
  price: 19.99,
  priceOld: null,
  currency: 'USD',
  sizes: const ['M'],
  colors: const ['negro'],
  description: '',
  imageUrls: const [],
  availability: 'in_stock',
  colorOptions: const [],
);

void main() {
  group('CatalogController.getLiveProduct', () {
    late _MockCatalogRepo repo;

    setUp(() {
      repo = _MockCatalogRepo();
    });

    ProviderContainer makeContainer() {
      return ProviderContainer(
        overrides: [catalogRepositoryProvider.overrideWithValue(repo)],
      );
    }

    test('devuelve el producto cuando la tienda responde OK', () async {
      when(() => repo.getLiveProduct(1)).thenAnswer((_) async => _product());

      final c = makeContainer();
      addTearDown(c.dispose);

      final result = await c
          .read(catalogControllerProvider.notifier)
          .getLiveProduct(1);

      expect(result?.id, 1);
    });

    test('devuelve null cuando la verificación en vivo falla', () async {
      when(() => repo.getLiveProduct(1)).thenThrow(Exception('down'));

      final c = makeContainer();
      addTearDown(c.dispose);

      final result = await c
          .read(catalogControllerProvider.notifier)
          .getLiveProduct(1);

      expect(result, isNull);
    });
  });
}
