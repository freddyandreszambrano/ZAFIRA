import '../../catalog/domain/product_model.dart';

/// Outfit completo (torso + pierna) guardado por el usuario, con la imagen
/// que ya generó el probador (se muestra sin volver a generar).
class FavoriteOutfitModel {
  const FavoriteOutfitModel({
    required this.id,
    required this.top,
    required this.bottom,
    required this.resultImageUrl,
  });

  final int id;
  final ProductModel top;
  final ProductModel bottom;
  final String resultImageUrl;

  double get totalPrice => top.price + bottom.price;

  factory FavoriteOutfitModel.fromJson(Map<String, dynamic> json) {
    return FavoriteOutfitModel(
      id: json['id'] as int,
      top: ProductModel.fromJson(json['top'] as Map<String, dynamic>),
      bottom: ProductModel.fromJson(json['bottom'] as Map<String, dynamic>),
      resultImageUrl: json['result_image_url']?.toString() ?? '',
    );
  }
}
