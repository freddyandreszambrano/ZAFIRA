import '../../domain/product_model.dart';

abstract class ICatalog {
  Future<List<ProductModel>> getProducts({
    String? gender,
    String? category,
  });

  Future<ProductModel> getProductById(int id);
}
