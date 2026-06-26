import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../favorites/view/controller/favorite_controller.dart';
import '../../../favorites/view/favorite_feedback.dart';
import '../../domain/product_model.dart';

Future<void> _openOfficialStore(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    if (context.mounted) {
      AppNotification.info(context, 'No se pudo abrir el enlace de la tienda.');
    }
  }
}

String _cleanDescription(String raw) {
  var text = raw.replaceFirst('DETALLES DEL PRODUCTO', '').trim();
  text = text.replaceAll(
    RegExp(r'(Nuestra|Nuestro|La) modelo mide[^.]*\.?', caseSensitive: false),
    '',
  );
  text = text.replaceAllMapped(
    RegExp(r'(?<=[a-záéíóúñ0-9])(?=[A-ZÁÉÍÓÚÑ])'),
    (match) => '\n',
  );
  return text.trim();
}

String _formatCategory(String raw) {
  final segments = raw
      .split('/')
      .map((segment) => segment.trim())
      .where((segment) => segment.isNotEmpty)
      .toList();

  if (segments.isEmpty) return raw;

  final unique = <String>[];
  for (final segment in segments) {
    if (unique.isEmpty || unique.last != segment) {
      unique.add(segment);
    }
  }

  final last = unique.last.toLowerCase();
  return last
      .split(' ')
      .map((word) => word.isEmpty
          ? word
          : word == 'y'
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.product, super.key});

  static const routeName = '/catalog/product';

  final ProductModel product;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  String? selectedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteControllerProvider.notifier).syncFromProducts(
            [widget.product],
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = widget.product;
    final genderLabel = product.gender == 'woman' ? 'Mujer' : 'Hombre';
    final hasOffer = product.priceOld != null;
    final isFavorite = ref.watch(
      favoriteControllerProvider.select(
        (state) => state.favoriteIds.contains(product.id),
      ),
    );

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: kSpaceDeviceHLg,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          toggleFavoriteWithFeedback(context, ref, product),
                      child: AnimatedScale(
                        scale: isFavorite ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? colors.primaryLight : colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: kSpaceDeviceHLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 380,
                        decoration: BoxDecoration(
                          color: colors.white,
                          borderRadius: kBorderRadiusAllLarge,
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.45),
                          ),
                          boxShadow: colors.shadowZafira,
                        ),
                        child: product.firstImageUrl == null
                            ? Center(
                                child: Icon(
                                  Icons.checkroom_rounded,
                                  color: colors.primaryLight,
                                  size: 96,
                                ),
                              )
                            : ClipRRect(
                                borderRadius: kBorderRadiusAllLarge,
                                child: Image.network(
                                  product.firstImageUrl!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Icon(
                                      Icons.checkroom_rounded,
                                      color: colors.primaryLight,
                                      size: 96,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const Gap(separatorLg),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: colors.gradientPrimary,
                              borderRadius: kBorderRadiusAllXLarge,
                            ),
                            child: Text(
                              genderLabel,
                              style: context.typography.labelSmall?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Gap(separatorSm),
                          if (product.colors.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.nightCard,
                                borderRadius: kBorderRadiusAllXLarge,
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Text(
                                product.colors.first,
                                style: context.typography.labelSmall?.copyWith(
                                  color: colors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          const Gap(separatorSm),
                          if (hasOffer)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.nightCard,
                                borderRadius: kBorderRadiusAllXLarge,
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Text(
                                'Oferta',
                                style: context.typography.labelSmall?.copyWith(
                                  color: colors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Gap(separatorMd),
                      Text(
                        product.name,
                        style: context.typography.headlineSmall?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Gap(separatorXSm),
                      Text(
                        _formatCategory(product.category),
                        style: context.typography.bodyMedium?.copyWith(
                          color: colors.slate,
                        ),
                      ),
                      const Gap(separatorMd),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: context.typography.headlineSmall?.copyWith(
                              color: colors.primaryLight,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          if (hasOffer) ...[
                            const Gap(separatorSm),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '\$${product.priceOld!.toStringAsFixed(2)}',
                                style: context.typography.bodyMedium?.copyWith(
                                  color: colors.slate,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (product.sizes.isNotEmpty) ...[
                        const Gap(separatorLg),
                        Text(
                          'Tallas disponibles',
                          style: context.typography.titleMedium?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(separatorSm),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: product.sizes.map((size) {
                            final selected = selectedSize == size;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient:
                                      selected ? colors.gradientPrimary : null,
                                  color: selected ? null : colors.nightCard,
                                  borderRadius: kBorderRadiusAllMedium,
                                  border: Border.all(
                                    color: selected
                                        ? Colors.transparent
                                        : colors.primary.withValues(alpha: 0.45),
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: context.typography.labelSmall?.copyWith(
                                    color: colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const Gap(separatorLg),
                      Text(
                        'Descripción',
                        style: context.typography.titleMedium?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(separatorXSm),
                      Text(
                        product.description.isEmpty
                            ? 'Sin descripción disponible.'
                            : _cleanDescription(product.description),
                        style: context.typography.bodyMedium?.copyWith(
                          color: colors.slate,
                          height: 1.5,
                        ),
                      ),
                      if (product.url.isNotEmpty) ...[
                        const Gap(separatorLg),
                        OutlinedButton.icon(
                          onPressed: () => _openOfficialStore(context, product.url),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                            side: BorderSide(
                              color: colors.primary.withValues(alpha: 0.45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: kBorderRadiusAllMedium,
                            ),
                          ),
                          icon: Icon(
                            Icons.open_in_new_rounded,
                            color: colors.primaryLight,
                            size: 18,
                          ),
                          label: Text(
                            'Comprar en la tienda oficial',
                            style: context.typography.labelMedium?.copyWith(
                              color: colors.primaryLight,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                      const Gap(separatorXLg),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: kSpaceDeviceHLg,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: colors.gradientPrimary,
                      borderRadius: kBorderRadiusAllMedium,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: kBorderRadiusAllMedium,
                        onTap: () => AppNotification.info(
                          context,
                          'Try-On con IA disponible próximamente',
                        ),
                        child: Center(
                          child: Text(
                            'Probar con IA',
                            style: context.typography.labelLarge?.copyWith(
                              color: colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(separatorMd),
            ],
          ),
        ),
      ),
    );
  }
}
