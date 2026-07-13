import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zafira/core/models/product_model.dart';
import 'package:zafira/feature/recommend/application/recommend_usecase.dart';
import 'package:zafira/feature/recommend/data/interfaces/recommend_interface.dart';
import 'package:zafira/feature/recommend/domain/recommend_model.dart';
import 'package:zafira/modules/common/exceptions/server_exception.dart';

class _MockRecommendRepo extends Mock implements IRecommend {}

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
  group('RecommendUseCase', () {
    late _MockRecommendRepo repo;
    late RecommendUseCase useCase;

    setUp(() {
      repo = _MockRecommendRepo();
      useCase = RecommendUseCase(repo);
    });

    test('propaga Right con el resultado del repositorio', () async {
      final response = RecommendResponseModel(
        occasion: 'fiesta',
        gender: 'hombre',
        store: 'all',
        outfits: [OutfitModel(top: _product())],
      );

      when(
        () => repo.getRecommendation(
          occasion: any(named: 'occasion'),
          store: any(named: 'store'),
          gender: any(named: 'gender'),
          excludeIds: any(named: 'excludeIds'),
          productIds: any(named: 'productIds'),
        ),
      ).thenAnswer((_) async => response);

      final result = await useCase.getRecommendation(occasion: 'fiesta');

      expect(result.isRight, isTrue);
      result.fold(
        (l) => fail('No debería fallar'),
        (r) => expect(r.occasion, 'fiesta'),
      );
    });

    test(
      'propaga Left(ServerException) cuando el repo lanza DioException',
      () async {
        final req = RequestOptions(path: '/api/v1/recommend/');
        when(
          () => repo.getRecommendation(
            occasion: any(named: 'occasion'),
            store: any(named: 'store'),
            gender: any(named: 'gender'),
            excludeIds: any(named: 'excludeIds'),
            productIds: any(named: 'productIds'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: req,
            response: Response(
              requestOptions: req,
              statusCode: 429,
              data: 'rate limited',
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await useCase.getRecommendation(occasion: 'fiesta');

        expect(result.isLeft, isTrue);
        result.fold(
          (l) => expect((l as ServerException).statusCode, 429),
          (r) => fail('Debería fallar'),
        );
      },
    );
  });
}
