import '../../../../core/models/product_model.dart';

abstract class ICatalog {
  Future<List<ProductModel>> getProducts({String? gender, String? category});

  Future<ProductModel> getProductById(int id);

  /// Consulta la tienda oficial en tiempo real y devuelve precio/tallas actuales.
  Future<ProductModel> getLiveProduct(int id);
}
