import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../modules/common/exceptions/server_exception.dart';
import '../../application/recommend_usecase.dart';
import '../../data/repositories/recommend_repository.dart';
import '../state/recommend_state.dart';

final recommendControllerProvider =
    StateNotifierProvider.autoDispose<RecommendController, RecommendState>((
      ref,
    ) {
      final repo = ref.watch(recommendRepositoryProvider);
      return RecommendController(RecommendUseCase(repo));
    });

class RecommendController extends StateNotifier<RecommendState> {
  RecommendController(this._useCase) : super(RecommendState.initial());

  final RecommendUseCase _useCase;

  Future<void> getRecommendation({
    required String occasion,
    String store = 'all',
    String gender = 'hombre',
    List<int> excludeIds = const [],
    List<int> productIds = const [],
  }) async {
    state = state.copyWith(status: ResponseStatus.loading, clearError: true);

    final result = await _useCase.getRecommendation(
      occasion: occasion,
      store: store,
      gender: gender,
      excludeIds: excludeIds,
      productIds: productIds,
    );

    result.fold(
      (error) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: _messageFor(error),
      ),
      (data) =>
          state = state.copyWith(status: ResponseStatus.success, result: data),
    );
  }

  String _messageFor(Exception error) {
    if (error is ServerException) {
      if (error.statusCode == 429) {
        return 'Demasiadas solicitudes seguidas. Espera unos segundos e '
            'intenta de nuevo.';
      }
      final body = error.message?.toString() ?? '';
      if (body.contains('torso') || body.contains('favoritos')) {
        return 'Necesitas al menos una prenda de torso y una de piernas en '
            'tus favoritos.';
      }
    }
    return 'No se pudo obtener la recomendación. Intenta de nuevo.';
  }

  void reset() => state = RecommendState.initial();
}
