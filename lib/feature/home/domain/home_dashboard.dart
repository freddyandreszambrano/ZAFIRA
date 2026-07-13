import '../../../core/models/product_model.dart';

class HomeDashboard {
  const HomeDashboard({
    required this.recentProducts,
    required this.featuredProducts,
  });

  final List<ProductModel> recentProducts;
  final List<ProductModel> featuredProducts;

  factory HomeDashboard.fromProducts(List<ProductModel> products) {
    final onOffer = products.where((product) => product.priceOld != null);

    return HomeDashboard(
      recentProducts: products.take(6).toList(),
      featuredProducts: (onOffer.isNotEmpty ? onOffer : products)
          .take(4)
          .toList(),
    );
  }
}
