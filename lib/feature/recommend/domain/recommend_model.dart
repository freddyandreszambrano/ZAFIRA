import '../../catalog/domain/product_model.dart';

class OutfitModel {
  const OutfitModel({required this.top, this.bottom});

  final ProductModel top;
  final ProductModel? bottom;

  bool get isComplete => bottom == null;

  double get totalPrice => top.price + (bottom?.price ?? 0);

  factory OutfitModel.fromJson(Map<String, dynamic> json) {
    return OutfitModel(
      top: ProductModel.fromJson(json['top'] as Map<String, dynamic>),
      bottom: json['bottom'] != null
          ? ProductModel.fromJson(json['bottom'] as Map<String, dynamic>)
          : null,
    );
  }

  List<int> get productIds => [top.id, if (bottom != null) bottom!.id];
}

class RecommendResponseModel {
  const RecommendResponseModel({
    required this.occasion,
    required this.gender,
    required this.store,
    required this.outfits,
  });

  final String occasion;
  final String gender;
  final String store;
  final List<OutfitModel> outfits;

  List<int> get allProductIds => outfits.expand((o) => o.productIds).toList();

  factory RecommendResponseModel.fromJson(Map<String, dynamic> json) {
    return RecommendResponseModel(
      occasion: json['occasion']?.toString() ?? '',
      gender: json['gender']?.toString() ?? 'hombre',
      store: json['store']?.toString() ?? 'all',
      outfits: (json['outfits'] as List? ?? [])
          .map((o) => OutfitModel.fromJson(o as Map<String, dynamic>))
          .toList(),
    );
  }
}
