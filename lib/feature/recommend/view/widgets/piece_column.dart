import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/helpers/context_helper.dart';
import '../../../catalog/domain/product_model.dart';
import '../../../catalog/view/main/product_detail_screen.dart';
import 'product_image.dart';

class PieceColumn extends StatelessWidget {
  const PieceColumn({
    required this.label,
    required this.product,
    this.selected = false,
    this.onSelect,
    super.key,
  });

  final String label;
  final ProductModel product;

  /// Mix & match: la prenda está elegida para la combinación del usuario.
  final bool selected;

  /// Si viene, la imagen muestra el círculo para elegir la prenda
  /// (los vestidos no lo tienen: no se combinan).
  final VoidCallback? onSelect;

  Color _storeColor(BuildContext context) {
    final colors = context.appColors;
    switch (product.store.toLowerCase()) {
      case 'etafashion':
        return colors.secondary;
      case 'modarm':
        return colors.success;
      default:
        return colors.slate;
    }
  }

  String get _storeName {
    switch (product.store.toLowerCase()) {
      case 'etafashion':
        return 'Etafashion';
      case 'modarm':
        return 'Modarm';
      default:
        return product.store;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final storeColor = _storeColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typography.labelSmall?.copyWith(
            color: colors.slate,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const Gap(6),
        // Imagen — toca para ver el detalle; el círculo elige la prenda
        // para la combinación propia (mix & match entre outfits)
        GestureDetector(
          onTap: () =>
              context.push(ProductDetailScreen.routeName, extra: product),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? colors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ProductImage(urls: product.imageUrls),
                ),
              ),
              if (onSelect != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onSelect,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selected
                            ? colors.primary
                            : colors.nightDeep.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? colors.primary : colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        selected
                            ? Icons.check_rounded
                            : Icons.add_rounded,
                        color: colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Gap(6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: storeColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _storeName,
            style: context.typography.labelSmall?.copyWith(
              color: storeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(4),
        // Nombre — toca para ver el detalle de la prenda
        GestureDetector(
          onTap: () =>
              context.push(ProductDetailScreen.routeName, extra: product),
          child: Text(
            product.name,
            style: context.typography.labelSmall?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(3),
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: context.typography.labelMedium?.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(6),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _openUrl(product.url),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primaryLight,
              side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Comprar',
              style: context.typography.labelSmall?.copyWith(
                color: colors.primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
