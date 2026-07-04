import '../../domain/recommend_model.dart';

abstract class IRecommend {
  Future<RecommendResponseModel> getRecommendation({
    required String occasion,
    String store,
    String gender,
    List<int> excludeIds,
    List<int> productIds,
  });
}
