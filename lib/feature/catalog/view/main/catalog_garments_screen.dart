import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import '../../../favorites/view/controller/favorite_controller.dart';
import '../../../favorites/view/favorite_feedback.dart';
import '../../../try_on/domain/try_on_args.dart';
import '../../../try_on/view/main/try_on_result_screen.dart';
import '../../domain/product_model.dart';
import '../controller/catalog_controller.dart';
import '../state/catalog_state.dart';
import 'product_detail_screen.dart';

class CatalogGarmentsScreen extends ConsumerStatefulWidget {
  const CatalogGarmentsScreen({
    required this.gender,
    required this.category,
    this.categoryLabel,
    this.complementProductId,
    this.complementIsUpper = false,
    super.key,
  });

  static const routeName = '/catalog/garments';

  final String gender;
  final String category;
  final String? categoryLabel;

  /// Modo "complementa tu outfit": prenda ya probada. Al tocar una prenda de
  /// esta lista se genera el outfit completo (par torso + pierna) directo.
  final int? complementProductId;

  /// true si la prenda ya probada es de torso (define el orden del par:
  /// el backend viste primero el torso y luego las piernas).
  final bool complementIsUpper;

  @override
  ConsumerState<CatalogGarmentsScreen> createState() =>
      _CatalogGarmentsScreenState();
}

class _CatalogGarmentsScreenState extends ConsumerState<CatalogGarmentsScreen> {
  bool get _isComplementMode => widget.complementProductId != null;

  /// Outfit editable para el probador (el backend viste primero el torso).
  TryOnOutfitArgs _outfitArgsWith(ProductModel product) => TryOnOutfitArgs(
    upperId: widget.complementIsUpper
        ? widget.complementProductId!
        : product.id,
    lowerId: widget.complementIsUpper
        ? product.id
        : widget.complementProductId!,
    catalogGender: widget.gender,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(catalogControllerProvider.notifier)
          .getProducts(gender: widget.gender, category: widget.category);
      if (!mounted) return;
      ref
          .read(favoriteControllerProvider.notifier)
          .syncFromProducts(ref.read(catalogControllerProvider).products);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final genderLabel = widget.gender == 'woman' ? 'Mujer' : 'Hombre';
    final displayLabel = widget.categoryLabel ?? widget.category;
    final state = ref.watch(catalogControllerProvider);

    return AppDarkScaffold(
      centerContent: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(context.gutter, 12, context.gutter, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back, color: colors.white),
                ),
                Expanded(
                  child: Text(
                    displayLabel,
                    textAlign: TextAlign.center,
                    style: context.typography.titleLarge?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const Gap(separatorLg),
            Text(
              displayLabel,
              style: context.typography.headlineSmall?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              _isComplementMode
                  ? 'Elige la prenda para completar tu outfit: se probará '
                        'junto con la que ya tienes puesta.'
                  : 'Prendas disponibles en esta categoría.',
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
              ),
            ),
            const Gap(separatorLg),
            Expanded(child: _buildContent(context, state, genderLabel)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    CatalogState state,
    String genderLabel,
  ) {
    final colors = context.appColors;

    if (state.status == ResponseStatus.loading) {
      return const AppStateView(
        icon: Icons.checkroom_rounded,
        title: 'Cargando prendas',
        message: 'Estamos consultando el catalogo disponible.',
        loading: true,
      );
    }

    if (state.status == ResponseStatus.error) {
      return AppStateView(
        icon: Icons.error_outline_rounded,
        title: 'No se pudieron cargar las prendas',
        message: state.errorMessage ?? 'Intenta nuevamente en unos segundos.',
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Text(
          'Todavía no hay prendas reales en esta categoría.',
          textAlign: TextAlign.center,
          style: context.typography.bodyMedium?.copyWith(color: colors.slate),
        ),
      );
    }

    return GridView.builder(
      itemCount: state.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns,
        mainAxisSpacing: separatorMd,
        crossAxisSpacing: separatorMd,
        childAspectRatio: context.responsive<double>(
          compact: 0.58,
          medium: 0.62,
          expanded: 0.66,
          large: 0.7,
        ),
      ),
      itemBuilder: (context, index) {
        final product = state.products[index];
        return _GarmentCard(
          product: product,
          genderLabel: genderLabel,
          actionLabel: _isComplementMode ? 'Combinar ✨' : 'Probar con IA',
          onTap: _isComplementMode
              // Complemento: generar directo el outfit con ambas prendas
              ? () => context.push(
                  TryOnResultScreen.routeName,
                  extra: _outfitArgsWith(product),
                )
              : () =>
                    context.push(ProductDetailScreen.routeName, extra: product),
        );
      },
    );
  }
}

class _GarmentCard extends ConsumerWidget {
  const _GarmentCard({
    required this.product,
    required this.genderLabel,
    required this.onTap,
    this.actionLabel = 'Probar con IA',
  });

  final ProductModel product;
  final String genderLabel;
  final VoidCallback onTap;
  final String actionLabel;

  String _storeLabel(String store) {
    switch (store.toLowerCase()) {
      case 'modarm':
        return 'Modarm';
      case 'etafashion':
        return 'Etafashion';
      default:
        return store;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final hasOffer = product.priceOld != null;
    final isFavorite = ref.watch(
      favoriteControllerProvider.select(
        (state) => state.favoriteIds.contains(product.id),
      ),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllLarge,
      child: Container(
        decoration: BoxDecoration(
          color: colors.nightCard,
          borderRadius: kBorderRadiusAllLarge,
          border: Border.all(color: colors.primary.withValues(alpha: 0.45)),
          boxShadow: colors.shadowZafira,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: colors.white),
                      child: product.firstImageUrl == null
                          ? Center(
                              child: Icon(
                                Icons.checkroom_rounded,
                                color: colors.primaryLight,
                                size: 54,
                              ),
                            )
                          : Image.network(
                              product.firstImageUrl!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
                                    child: Icon(
                                      Icons.checkroom_rounded,
                                      color: colors.primaryLight,
                                      size: 54,
                                    ),
                                  ),
                            ),
                    ),
                  ),
                  if (hasOffer)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: colors.gradientPrimary,
                          borderRadius: kBorderRadiusAllXLarge,
                        ),
                        child: Text(
                          'Oferta',
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () =>
                          toggleFavoriteWithFeedback(context, ref, product),
                      child: AnimatedScale(
                        scale: isFavorite ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colors.nightDeep.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? colors.primaryLight
                                : colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (product.store.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colors.nightDeep.withValues(alpha: 0.75),
                          borderRadius: kBorderRadiusAllXLarge,
                          border: Border.all(
                            color: colors.primaryLight.withValues(alpha: 0.6),
                          ),
                        ),
                        child: Text(
                          _storeLabel(product.store),
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.primaryLight,
                            fontWeight: FontWeight.w800,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: kSpaceDeviceSm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nombre con el precio justo debajo: llena el espacio
                    // entre el nombre y el botón de forma útil
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelMedium?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(3),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: context.typography.labelMedium?.copyWith(
                            color: colors.primaryLight,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: colors.gradientPrimary,
                          borderRadius: kBorderRadiusAllMedium,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: kBorderRadiusAllMedium,
                            onTap: onTap,
                            child: Center(
                              child: Text(
                                actionLabel,
                                style: context.typography.labelSmall?.copyWith(
                                  color: colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
