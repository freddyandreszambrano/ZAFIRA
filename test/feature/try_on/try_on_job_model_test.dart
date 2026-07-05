import 'package:flutter_test/flutter_test.dart';
import 'package:zafira/feature/try_on/domain/try_on_job_model.dart';

void main() {
  test('fromJson parses job payload', () {
    final job = TryOnJobModel.fromJson({
      'id': 'abc-123',
      'status': 'completed',
      'product_id': 7,
      'result_url': 'http://core.test/media/try_on_results/x.png',
      'error_message': '',
      'created_at': '2026-07-05T10:00:00',
    });

    expect(job.id, 'abc-123');
    expect(job.isCompleted, isTrue);
    expect(job.isFailed, isFalse);
    expect(job.resultUrl, 'http://core.test/media/try_on_results/x.png');
  });

  test('fromJson tolerates missing fields', () {
    final job = TryOnJobModel.fromJson({'id': 'abc'});

    expect(job.status, 'pending');
    expect(job.resultUrl, isNull);
    expect(job.errorMessage, '');
  });
}
