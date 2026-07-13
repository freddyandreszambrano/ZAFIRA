import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/onboarding/data/services/onboarding_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('envía las respuestas y marca onboarding como completado', () async {
    final service = OnboardingService(
      remoteDataSource: stubDioHttpClient(
        stubDio((options) {
          final data = options.data as Map<String, Object?>;
          expect(data['gender'], 'femenino');
          expect(data['onboarding_completed'], isTrue);
          return Response<void>(requestOptions: options, statusCode: 200);
        }),
      ),
    );

    await service.submit(const {'gender': 'femenino'});
  });
}
