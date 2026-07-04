import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../data/recommend_repository.dart';
import '../state/recommend_state.dart';

final recommendControllerProvider =
    StateNotifierProvider<RecommendController, RecommendState>((ref) {
      final repo = ref.watch(recommendRepositoryProvider);
      return RecommendController(repo);
    });

class RecommendController extends StateNotifier<RecommendState> {
  RecommendController(this._repo) : super(RecommendState.initial());

  final dynamic _repo;

  Future<void> getRecommendation({
    required String occasion,
    String store = 'all',
    String gender = 'hombre',
    List<int> excludeIds = const [],
    List<int> productIds = const [],
  }) async {
    state = state.copyWith(
      status: ResponseStatus.loading,
      clearError: true,
    );

    try {
      final result = await _repo.getRecommendation(
        occasion: occasion,
        store: store,
        gender: gender,
        excludeIds: excludeIds,
        productIds: productIds,
      );
      state = state.copyWith(
        status: ResponseStatus.success,
        result: result,
      );
    } catch (e) {
      final msg = e.toString();
      final isRateLimit = msg.contains('429') || msg.contains('rate') || msg.contains('limit');
      final isFavoritesIssue = msg.contains('torso') || msg.contains('favoritos');
      state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: isFavoritesIssue
            ? 'Necesitas al menos una prenda de torso y una de piernas en tus favoritos.'
            : isRateLimit
                ? 'Demasiadas solicitudes seguidas. Espera unos segundos e intenta de nuevo.'
                : 'No se pudo obtener la recomendación. Intenta de nuevo.',
      );
    }
  }

  void reset() => state = RecommendState.initial();
}
