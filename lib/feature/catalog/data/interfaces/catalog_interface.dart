import '../../domain/product_model.dart';

abstract class ICatalog {
  Future<List<ProductModel>> getProducts({
    required String gender,
    required String category,
  });

  Future<ProductModel> getProductById(int id);
}
