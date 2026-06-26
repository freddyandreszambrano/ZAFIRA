import '../../../catalog/domain/product_model.dart';

abstract class IFavorite {
  Future<List<ProductModel>> getFavorites();

  Future<bool> addFavorite(int productId);

  Future<bool> removeFavorite(int productId);
}
