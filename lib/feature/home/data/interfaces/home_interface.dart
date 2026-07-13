import '../../../../core/models/product_model.dart';

abstract class IHomeRepository {
  Future<List<ProductModel>> getDashboardProducts();
}
