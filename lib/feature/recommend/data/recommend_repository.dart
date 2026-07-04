import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/recommend_model.dart';
import 'recommend_service.dart';

final recommendRepositoryProvider = Provider<RecommendRepository>((ref) {
  final service = ref.watch(recommendServiceProvider);
  return RecommendRepository(service: service);
});

class RecommendRepository {
  RecommendRepository({required this.service});

  final RecommendService service;

  Future<RecommendResponseModel> getRecommendation({
    required String occasion,
    String store = 'all',
    String gender = 'hombre',
    List<int> excludeIds = const [],
    List<int> productIds = const [],
  }) => service.getRecommendation(
    occasion: occasion,
    store: store,
    gender: gender,
    excludeIds: excludeIds,
    productIds: productIds,
  );
}
