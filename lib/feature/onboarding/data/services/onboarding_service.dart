import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return OnboardingService(remoteDataSource: remoteDataSource);
});

class OnboardingService {
  OnboardingService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<void> submit(Map<String, String> answers) async {
    const url = '/api/v1/auth/profile/update/';
    final body = <String, Object>{...answers, 'onboarding_completed': true};

    DebugLogger(runtimeType).request(url, body);
    final response = await remoteDataSource().patch<void>(url, data: body);
    DebugLogger(runtimeType).response(url, [response.statusCode]);
  }
}
