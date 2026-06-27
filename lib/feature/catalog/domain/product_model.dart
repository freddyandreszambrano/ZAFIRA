class ColorOptionModel {
  const ColorOptionModel({
    required this.id,
    required this.color,
    required this.imageUrl,
  });

  final int id;
  final String? color;
  final String? imageUrl;

  factory ColorOptionModel.fromJson(Map<String, dynamic> json) {
    return ColorOptionModel(
      id: json['id'] as int,
      color: json['color']?.toString(),
      imageUrl: json['image_url']?.toString(),
    );
  }
}

class ProductModel {
  const ProductModel({
    required this.id,
    required this.idExternal,
    required this.name,
    required this.category,
    required this.gender,
    required this.url,
    required this.price,
    required this.priceOld,
    required this.currency,
    required this.sizes,
    required this.colors,
    required this.description,
    required this.imageUrls,
    required this.availability,
    required this.colorOptions,
    this.isFavorite = false,
  });

  final int id;
  final String idExternal;
  final String name;
  final String category;
  final String gender;
  final String url;
  final double price;
  final double? priceOld;
  final String currency;
  final List<String> sizes;
  final List<String> colors;
  final String description;
  final List<String> imageUrls;
  final String availability;
  final List<ColorOptionModel> colorOptions;
  final bool isFavorite;

  String? get firstImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  ProductModel copyWith({bool? isFavorite}) => ProductModel(
    id: id,
    idExternal: idExternal,
    name: name,
    category: category,
    gender: gender,
    url: url,
    price: price,
    priceOld: priceOld,
    currency: currency,
    sizes: sizes,
    colors: colors,
    description: description,
    imageUrls: imageUrls,
    availability: availability,
    colorOptions: colorOptions,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      idExternal: json['id_external']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      priceOld: json['price_old'] == null
          ? null
          : double.tryParse(json['price_old'].toString()),
      currency: json['currency']?.toString() ?? 'USD',
      sizes: List<String>.from(json['sizes'] as List? ?? []),
      colors: List<String>.from(json['colors'] as List? ?? []),
      description: json['description']?.toString() ?? '',
      imageUrls: List<String>.from(json['image_urls'] as List? ?? []),
      availability: json['availability']?.toString() ?? 'unknown',
      colorOptions: (json['color_options'] as List? ?? [])
          .map(
            (item) => ColorOptionModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }
}
