import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../../../favorites/view/controller/favorite_controller.dart';
import '../../../favorites/view/favorite_feedback.dart';
import '../../../try_on/view/main/try_on_result_screen.dart';
import '../../../try_on/view/main/upload_photo_screen.dart';
import '../../domain/product_model.dart';
import '../controller/catalog_controller.dart';

Future<void> _openOfficialStore(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null ||
      !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
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
      .map(
        (word) => word.isEmpty
            ? word
            : word == 'y'
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
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
  late ProductModel _product = widget.product;
  bool _verifyingLive = true;
  bool _liveOk = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteControllerProvider.notifier).syncFromProducts([
        widget.product,
      ]);
    });
    _loadLiveData();
  }

  /// Consulta la tienda oficial para traer precio y tallas en tiempo real.
  Future<void> _loadLiveData() async {
    final live = await ref
        .read(catalogControllerProvider.notifier)
        .getLiveProduct(widget.product.id);
    if (!mounted) return;

    if (live == null) {
      // No se pudo verificar con la tienda: se mantienen los datos guardados
      setState(() => _verifyingLive = false);
      return;
    }

    setState(() {
      _product = live;
      _verifyingLive = false;
      _liveOk = true;
      // Si la talla elegida ya no existe en la tienda, deseleccionar
      if (selectedSize != null && !live.sizes.contains(selectedSize)) {
        selectedSize = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final product = _product;
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
                          color: isFavorite
                              ? colors.primaryLight
                              : colors.white,
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
                        height: context.responsive<double>(
                          compact: 380,
                          medium: 460,
                          expanded: 520,
                        ),
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
                        Row(
                          children: [
                            Text(
                              'Tallas disponibles',
                              style: context.typography.titleMedium?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Gap(8),
                            if (_verifyingLive)
                              SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.primary,
                                ),
                              )
                            else if (_liveOk)
                              Icon(
                                Icons.verified_rounded,
                                size: 15,
                                color: colors.primary,
                              ),
                          ],
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
                                  gradient: selected
                                      ? colors.gradientPrimary
                                      : null,
                                  color: selected ? null : colors.nightCard,
                                  borderRadius: kBorderRadiusAllMedium,
                                  border: Border.all(
                                    color: selected
                                        ? Colors.transparent
                                        : colors.primary.withValues(
                                            alpha: 0.45,
                                          ),
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: context.typography.labelSmall
                                      ?.copyWith(
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
                          onPressed: () =>
                              _openOfficialStore(context, product.url),
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
                child: AppGradientAction(
                  label: 'Probar con IA',
                  icon: Icons.auto_awesome_rounded,
                  onTap: () {
                    final user = ref.read(authControllerProvider).user;
                    final hasPhoto = (user?.tryOnPhoto ?? '').trim().isNotEmpty;
                    if (!hasPhoto) {
                      AppNotification.info(
                        context,
                        'Primero sube tu foto para el probador virtual',
                      );
                      context.push(UploadPhotoScreen.routeName);
                      return;
                    }
                    context.push(
                      TryOnResultScreen.routeName,
                      extra: [product.id],
                    );
                  },
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
