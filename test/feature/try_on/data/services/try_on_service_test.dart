import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/try_on/data/services/try_on_service.dart';

import '../../../../helpers/http_test_client.dart';
import '../../../../helpers/http_test_dio.dart';

void main() {
  test('convierte la respuesta de creación de trabajo', () async {
    final service = TryOnService(
      remoteDataSource: stubDioHttpClient(
        stubDioOk({
          'job': {'id': 'job-1', 'status': 'pending'},
        }),
      ),
    );

    final job = await service.createJob(const [1, 2]);

    expect(job.id, 'job-1');
    expect(job.status, 'pending');
  });
}
