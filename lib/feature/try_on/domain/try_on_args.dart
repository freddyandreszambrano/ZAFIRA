import 'package:flutter/material.dart';

import '../../catalog/domain/product_model.dart';

/// Argumentos para abrir el probador virtual.
///
/// [sourceProduct] viene solo cuando la prueba es de UNA prenda desde el
/// detalle del producto: habilita "Complementa tu outfit" en el resultado.
/// Los flujos de outfit (recomendación) pasan solo los ids.
class TryOnRequestArgs {
  const TryOnRequestArgs({required this.productIds, this.sourceProduct});

  final List<int> productIds;
  final ProductModel? sourceProduct;
}

/// Outfit combinado (torso + pierna) generado desde "complementa tu outfit".
/// Conserva los ids por posición y el género del catálogo para poder
/// CAMBIAR cualquiera de las dos prendas manteniendo la otra.
class TryOnOutfitArgs {
  const TryOnOutfitArgs({
    required this.upperId,
    required this.lowerId,
    required this.catalogGender,
  });

  final int upperId;
  final int lowerId;

  /// 'woman' / 'man' — define qué categorías se ofrecen al cambiar prenda.
  final String catalogGender;
}

/// Parte del cuerpo que viste la prenda (espejo del mapeo de zafira-core).
enum GarmentSlot { upper, lower, dress }

const _dressNameKeywords = ['vestido', 'enterizo', 'jumpsuit', 'overol'];
const _lowerKeywords = [
  'pantalon',
  'pantalón',
  'jean',
  'short',
  'falda',
  'legging',
  'jogger',
  'bermuda',
];

/// Clasifica la prenda igual que el backend: la categoría manda, y en la
/// categoría mixta "FALDAS Y VESTIDOS" desambigua el nombre del producto.
GarmentSlot garmentSlotFor(ProductModel product) {
  final category = product.category.toLowerCase();
  final name = product.name.toLowerCase();

  if (category.contains('falda') && category.contains('vestido')) {
    if (_dressNameKeywords.any(name.contains)) return GarmentSlot.dress;
    if (_lowerKeywords.any(name.contains)) return GarmentSlot.lower;
    return GarmentSlot.dress;
  }
  if (_dressNameKeywords.any(category.contains)) return GarmentSlot.dress;
  if (_lowerKeywords.any(category.contains)) return GarmentSlot.lower;
  return GarmentSlot.upper;
}

/// Categoría del catálogo ofrecida para completar el look.
class ComplementCategory {
  const ComplementCategory(this.label, this.icon, this.categoryQuery);

  final String label;
  final IconData icon;
  final String categoryQuery;
}

/// Género del catálogo ('woman' / 'man') a partir del producto probado.
String catalogGenderFor(ProductModel product) {
  final gender = product.gender.toLowerCase();
  if (gender.startsWith('f') || gender.contains('mujer')) return 'woman';
  if (product.category.toUpperCase().startsWith('MUJERES')) return 'woman';
  return 'man';
}

/// Categorías complementarias: si se probó torso ofrece piernas y viceversa.
/// Vestidos no se complementan (ya son el outfit completo) → lista vacía.
/// Las categorías son las mismas del catálogo (catalog_screen).
List<ComplementCategory> complementCategoriesFor(
  GarmentSlot slot,
  String catalogGender,
) {
  final isWoman = catalogGender == 'woman';
  switch (slot) {
    case GarmentSlot.upper:
      return [
        const ComplementCategory(
          'Pantalones',
          Icons.shopping_bag_rounded,
          'JEANS Y PANTALONES',
        ),
        if (!isWoman)
          const ComplementCategory(
            'Shorts',
            Icons.accessibility_new_rounded,
            'SHORTS Y BERMUDAS',
          ),
      ];
    case GarmentSlot.lower:
      return isWoman
          ? [
              const ComplementCategory(
                'Blusas',
                Icons.dry_cleaning_rounded,
                'BLUSAS',
              ),
              const ComplementCategory(
                'Chaquetas',
                Icons.layers_rounded,
                'BLAZERS Y CONJUNTOS',
              ),
            ]
          : [
              const ComplementCategory(
                'Camisas',
                Icons.checkroom_rounded,
                'CAMISAS',
              ),
              const ComplementCategory(
                'Camisetas',
                Icons.dry_cleaning_rounded,
                'CAMISETAS Y POLOS',
              ),
              const ComplementCategory(
                'Chaquetas',
                Icons.layers_rounded,
                'CHAQUETAS Y ABRIGOS',
              ),
            ];
    case GarmentSlot.dress:
      return const [];
  }
}
