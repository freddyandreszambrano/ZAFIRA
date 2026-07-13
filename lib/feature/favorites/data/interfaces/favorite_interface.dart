import '../../../../core/models/product_model.dart';
import '../../domain/favorite_outfit_model.dart';

abstract class IFavorite {
  Future<List<ProductModel>> getFavorites();

  Future<bool> addFavorite(int productId);

  Future<bool> removeFavorite(int productId);

  Future<List<FavoriteOutfitModel>> getFavoriteOutfits();

  Future<bool> saveFavoriteOutfit({
    required int topId,
    required int bottomId,
    required String resultImageUrl,
  });

  Future<bool> removeFavoriteOutfit(int outfitId);
}
