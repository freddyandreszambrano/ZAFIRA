import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/try_on_usecase.dart';
import '../../data/repositories/try_on_repository.dart';
import '../state/try_on_state.dart';

final tryOnControllerProvider =
    StateNotifierProvider.autoDispose<TryOnController, TryOnState>((ref) {
      final tryOnRepository = ref.watch(tryOnRepositoryProvider);

      return TryOnController(TryOnUseCase(tryOnRepository));
    });

class TryOnController extends StateNotifier<TryOnState> {
  TryOnController(
    this._tryOnUseCase, {
    // 1.5s: el resultado aparece hasta ~2s antes que con 2.5s; el costo de
    // preguntar más seguido es despreciable (consulta a BD local)
    this.pollInterval = const Duration(milliseconds: 1500),
    // Hasta 6 min: un outfit son 2 generaciones encadenadas en el proveedor,
    // y la primera llamada puede incluir el arranque del modelo remoto.
    this.maxAttempts = 240,
  }) : super(TryOnState.initial());

  final TryOnUseCase _tryOnUseCase;
  final Duration pollInterval;
  final int maxAttempts;

  Future<void> startTryOn(List<int> productIds) async {
    state = TryOnState.initial().copyWith(status: TryOnStatus.creating);

    final created = await _tryOnUseCase.createJob(productIds);

    await created.fold(
      (err) async {
        state = state.copyWith(
          status: TryOnStatus.failure,
          errorMessage:
              'No se pudo iniciar la prueba virtual. Verifica tu foto e intenta de nuevo.',
        );
      },
      (job) async {
        state = state.copyWith(status: TryOnStatus.generating, job: job);
        await _pollUntilDone(job.id);
      },
    );
  }

  Future<void> _pollUntilDone(String jobId) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      await Future<void>.delayed(pollInterval);
      if (!mounted) return;

      final response = await _tryOnUseCase.getJob(jobId);
      final job = response.fold((err) => null, (job) => job);
      if (job == null) continue;
      if (!mounted) return;

      if (job.isCompleted) {
        state = state.copyWith(status: TryOnStatus.success, job: job);
        return;
      }
      if (job.isFailed) {
        state = state.copyWith(
          status: TryOnStatus.failure,
          job: job,
          errorMessage: job.errorMessage.isEmpty
              ? 'No pudimos generar tu prueba virtual.'
              : job.errorMessage,
        );
        return;
      }
      state = state.copyWith(job: job);
    }

    if (!mounted) return;
    state = state.copyWith(
      status: TryOnStatus.failure,
      errorMessage: 'La generación tardó demasiado. Intenta de nuevo.',
    );
  }
}
