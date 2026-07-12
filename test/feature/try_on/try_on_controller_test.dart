import 'package:flutter_test/flutter_test.dart';
import 'package:zafira/feature/try_on/application/try_on_usecase.dart';
import 'package:zafira/feature/try_on/data/interfaces/try_on_interface.dart';
import 'package:zafira/feature/try_on/domain/try_on_job_model.dart';
import 'package:zafira/feature/try_on/view/controller/try_on_controller.dart';
import 'package:zafira/feature/try_on/view/state/try_on_state.dart';

class FakeTryOn implements ITryOn {
  FakeTryOn({required this.statuses, this.failCreate = false});

  final List<String> statuses;
  final bool failCreate;
  int polls = 0;

  @override
  Future<TryOnJobModel> createJob(List<int> productIds) async {
    if (failCreate) throw Exception('create failed');
    return const TryOnJobModel(id: 'job-1', status: 'pending');
  }

  @override
  Future<TryOnJobModel> getJob(String jobId) async {
    final status =
        statuses[polls < statuses.length ? polls : statuses.length - 1];
    polls++;
    return TryOnJobModel(
      id: jobId,
      status: status,
      resultUrl: status == 'completed' ? 'http://core.test/r.png' : null,
      errorMessage: status == 'failed' ? 'No pudimos generar tu prueba.' : '',
    );
  }
}

TryOnController buildController(FakeTryOn fake) =>
    TryOnController(TryOnUseCase(fake), pollInterval: Duration.zero);

void main() {
  test('reaches success when job completes', () async {
    final fake = FakeTryOn(statuses: ['processing', 'processing', 'completed']);
    final controller = buildController(fake);

    await controller.startTryOn([7]);

    expect(controller.state.status, TryOnStatus.success);
    expect(controller.state.job?.resultUrl, 'http://core.test/r.png');
  });

  test('reaches failure when job fails', () async {
    final fake = FakeTryOn(statuses: ['processing', 'failed']);
    final controller = buildController(fake);

    await controller.startTryOn([7]);

    expect(controller.state.status, TryOnStatus.failure);
    expect(controller.state.errorMessage, isNotEmpty);
  });

  test('create error sets failure', () async {
    final controller = buildController(
      FakeTryOn(statuses: [], failCreate: true),
    );

    await controller.startTryOn([7]);

    expect(controller.state.status, TryOnStatus.failure);
  });
}
