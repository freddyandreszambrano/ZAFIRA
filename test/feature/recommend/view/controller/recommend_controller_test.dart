import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zafira/core/enum/response_status.dart';
import 'package:zafira/feature/recommend/data/interfaces/recommend_interface.dart';
import 'package:zafira/feature/recommend/data/repositories/recommend_repository.dart';
import 'package:zafira/feature/recommend/domain/recommend_model.dart';
import 'package:zafira/feature/recommend/view/controller/recommend_controller.dart';

DioException _dioError({required int statusCode, required String message}) {
  final req = RequestOptions(path: '/api/v1/recommend/');
  return DioException(
    requestOptions: req,
    response: Response(
      requestOptions: req,
      statusCode: statusCode,
      data: message,
    ),
    type: DioExceptionType.badResponse,
  );
}

class _MockRecommendRepo extends Mock implements IRecommend {}

void main() {
  group('RecommendController', () {
    late _MockRecommendRepo repo;

    setUp(() {
      repo = _MockRecommendRepo();
    });

    ProviderContainer makeContainer() {
      return ProviderContainer(
        overrides: [recommendRepositoryProvider.overrideWithValue(repo)],
      );
    }

    void stubGetRecommendation(
      Future<RecommendResponseModel> Function() answer,
    ) {
      when(
        () => repo.getRecommendation(
          occasion: any(named: 'occasion'),
          store: any(named: 'store'),
          gender: any(named: 'gender'),
          excludeIds: any(named: 'excludeIds'),
          productIds: any(named: 'productIds'),
        ),
      ).thenAnswer((_) => answer());
    }

    test('pasa loading -> success cuando el repo responde', () async {
      stubGetRecommendation(
        () async => const RecommendResponseModel(
          occasion: 'fiesta',
          gender: 'hombre',
          store: 'all',
          outfits: [],
        ),
      );

      final c = makeContainer();
      addTearDown(c.dispose);

      final future = c
          .read(recommendControllerProvider.notifier)
          .getRecommendation(occasion: 'fiesta');

      expect(
        c.read(recommendControllerProvider).status,
        ResponseStatus.loading,
      );

      await future;

      final state = c.read(recommendControllerProvider);
      expect(state.status, ResponseStatus.success);
      expect(state.result?.occasion, 'fiesta');
    });

    test('error 429 muestra el mensaje de rate limit', () async {
      when(
        () => repo.getRecommendation(
          occasion: any(named: 'occasion'),
          store: any(named: 'store'),
          gender: any(named: 'gender'),
          excludeIds: any(named: 'excludeIds'),
          productIds: any(named: 'productIds'),
        ),
      ).thenThrow(_dioError(statusCode: 429, message: 'rate limited'));

      final c = makeContainer();
      addTearDown(c.dispose);

      await c
          .read(recommendControllerProvider.notifier)
          .getRecommendation(occasion: 'fiesta');

      final state = c.read(recommendControllerProvider);
      expect(state.status, ResponseStatus.error);
      expect(state.errorMessage, contains('Demasiadas solicitudes'));
    });

    test(
      'error con prendas insuficientes en favoritos muestra mensaje dedicado',
      () async {
        when(
          () => repo.getRecommendation(
            occasion: any(named: 'occasion'),
            store: any(named: 'store'),
            gender: any(named: 'gender'),
            excludeIds: any(named: 'excludeIds'),
            productIds: any(named: 'productIds'),
          ),
        ).thenThrow(
          _dioError(
            statusCode: 400,
            message: 'Necesitas prendas de torso y favoritos',
          ),
        );

        final c = makeContainer();
        addTearDown(c.dispose);

        await c
            .read(recommendControllerProvider.notifier)
            .getRecommendation(occasion: 'fiesta');

        final state = c.read(recommendControllerProvider);
        expect(state.status, ResponseStatus.error);
        expect(state.errorMessage, contains('torso y una de piernas'));
      },
    );

    test('error genérico muestra el mensaje por defecto', () async {
      when(
        () => repo.getRecommendation(
          occasion: any(named: 'occasion'),
          store: any(named: 'store'),
          gender: any(named: 'gender'),
          excludeIds: any(named: 'excludeIds'),
          productIds: any(named: 'productIds'),
        ),
      ).thenThrow(Exception('boom'));

      final c = makeContainer();
      addTearDown(c.dispose);

      await c
          .read(recommendControllerProvider.notifier)
          .getRecommendation(occasion: 'fiesta');

      final state = c.read(recommendControllerProvider);
      expect(state.status, ResponseStatus.error);
      expect(
        state.errorMessage,
        'No se pudo obtener la recomendación. Intenta de nuevo.',
      );
    });
  });
}
