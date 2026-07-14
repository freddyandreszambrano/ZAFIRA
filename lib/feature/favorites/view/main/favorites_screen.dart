import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/images/app_cached_image.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../../core/models/product_model.dart';
import '../../../catalog/view/main/product_detail_screen.dart';
import '../../domain/favorite_outfit_model.dart';
import '../controller/favorite_controller.dart';
import '../favorite_feedback.dart';
import '../state/favorite_state.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  static const routeName = '/favorites';

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // 0 = prendas sueltas · 1 = outfits completos guardados
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoriteControllerProvider.notifier).loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = ref.watch(favoriteControllerProvider);

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
                    'Favoritos',
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
              'Tu clóset guardado',
              style: context.typography.headlineSmall?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              'Prendas y outfits que marcaste con el corazón.',
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
              ),
            ),
            const Gap(separatorMd),
            _buildTabs(context),
            const Gap(separatorLg),
            Expanded(child: _buildContent(context, state)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs(BuildContext context) {
    final colors = context.appColors;
    final tabs = ['Prendas', 'Outfits'];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.nightCard,
        borderRadius: kBorderRadiusAllXLarge,
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = index == _tabIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tabIndex = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  gradient: isSelected ? colors.gradientPrimary : null,
                  borderRadius: kBorderRadiusAllXLarge,
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: context.typography.labelMedium?.copyWith(
                    color: isSelected ? colors.white : colors.slate,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoriteState state) {
    if (state.status == ResponseStatus.loading ||
        state.status == ResponseStatus.initial) {
      return const AppStateView(
        icon: Icons.favorite_rounded,
        title: 'Cargando favoritos',
        message: 'Estamos preparando tu clóset guardado.',
        loading: true,
      );
    }

    if (state.status == ResponseStatus.error) {
      return AppStateView(
        icon: Icons.error_outline_rounded,
        title: 'No se pudieron cargar tus favoritos',
        message: state.errorMessage ?? 'Intenta nuevamente en unos segundos.',
        actionLabel: 'Reintentar',
        onAction: () =>
            ref.read(favoriteControllerProvider.notifier).loadFavorites(),
      );
    }

    if (_tabIndex == 1) {
      return _buildOutfitsTab(context, state);
    }
    if (state.products.isEmpty) {
      return _emptyState(
        context,
        title: 'Todavía no tienes prendas favoritas.',
        hint: 'Toca el corazón en una prenda para guardarla aquí.',
      );
    }
    return _buildGrid(context, state);
  }

  Widget _emptyState(
    BuildContext context, {
    required String title,
    required String hint,
  }) {
    final colors = context.appColors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border_rounded, color: colors.slate, size: 48),
          const Gap(separatorSm),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
          const Gap(separatorXSm),
          Text(
            hint,
            textAlign: TextAlign.center,
            style: context.typography.bodySmall?.copyWith(color: colors.slate),
          ),
        ],
      ),
    );
  }

  Future<void> _openStore(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        AppNotification.info(
          context,
          'No se pudo abrir el enlace de la tienda.',
        );
      }
    }
  }

  /// Panel del outfit guardado: la foto generada en grande y cada prenda
  /// con su precio y enlace de compra. Favoritos = ver y comprar, sin
  /// regenerar (eso vive en el probador y la recomendación).
  void _showOutfitDetails(FavoriteOutfitModel outfit) {
    final colors = context.appColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.nightCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tu outfit guardado',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(12),
              if (outfit.resultImageUrl.isNotEmpty) ...[
                Center(
                  child: ClipRRect(
                    borderRadius: kBorderRadiusAllLarge,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 340),
                      child: AppCachedImage(url: outfit.resultImageUrl),
                    ),
                  ),
                ),
                const Gap(16),
              ],
              _outfitPieceRow(sheetContext, outfit.top),
              const Gap(10),
              _outfitPieceRow(sheetContext, outfit.bottom),
              const Gap(14),
              Row(
                children: [
                  Text(
                    'Total del outfit',
                    style: context.typography.labelMedium?.copyWith(
                      color: colors.slate,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '\$${outfit.totalPrice.toStringAsFixed(2)}',
                    style: context.typography.titleSmall?.copyWith(
                      color: colors.primaryLight,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outfitPieceRow(BuildContext sheetContext, ProductModel product) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colors.nightInput,
        borderRadius: kBorderRadiusAllLarge,
        border: Border.all(color: colors.nightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.typography.labelMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(2),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: context.typography.labelSmall?.copyWith(
                    color: colors.primaryLight,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Gap(10),
          OutlinedButton(
            onPressed: () => _openStore(product.url),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primaryLight,
              side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: kBorderRadiusAllMedium,
              ),
            ),
            child: Text(
              'Comprar',
              style: context.typography.labelSmall?.copyWith(
                color: colors.primaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutfitsTab(BuildContext context, FavoriteState state) {
    if (state.outfits.isEmpty) {
      return _emptyState(
        context,
        title: 'Todavía no has guardado outfits.',
        hint:
            'Prueba un outfit completo en el probador y toca el corazón '
            'para guardarlo aquí con tu foto.',
      );
    }

    return GridView.builder(
      itemCount: state.outfits.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.gridColumns,
        mainAxisSpacing: separatorMd,
        crossAxisSpacing: separatorMd,
        childAspectRatio: context.responsive<double>(
          compact: 0.52,
          medium: 0.56,
          expanded: 0.6,
          large: 0.64,
        ),
      ),
      itemBuilder: (gridItemContext, index) {
        final outfit = state.outfits[index];
        return _OutfitCard(
          outfit: outfit,
          onViewDetails: () => _showOutfitDetails(outfit),
          // Context de la pantalla: el item desaparece al instante al
          // eliminar (actualización optimista) y su context queda unmounted
          onRemove: () async {
            final removed = await ref
                .read(favoriteControllerProvider.notifier)
                .removeOutfit(outfit);
            if (!context.mounted) return;
            if (removed) {
              AppNotification.success(
                context,
                'Outfit eliminado de favoritos.',
              );
            } else {
              AppNotification.warning(
                context,
                'No se pudo eliminar el outfit.',
              );
            }
          },
        );
      },
    );
  }

  Widget _buildGrid(BuildContext context, FavoriteState state) {
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
      itemBuilder: (gridItemContext, index) {
        final product = state.products[index];
        return _FavoriteCard(
          product: product,
          // showTryOn=false: desde favoritos el detalle es ver y comprar
          onTap: () => gridItemContext.push(
            ProductDetailScreen.routeName,
            extra: ProductDetailArgs(product: product, showTryOn: false),
          ),
          // Usamos el context de la pantalla (no el del item del grid):
          // el item desaparece de inmediato al quitar el favorito
          // (actualización optimista), por lo que su context queda
          // unmounted antes de que termine la llamada al backend.
          onToggleFavorite: () =>
              toggleFavoriteWithFeedback(context, ref, product),
        );
      },
    );
  }
}

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({
    required this.outfit,
    required this.onViewDetails,
    required this.onRemove,
  });

  final FavoriteOutfitModel outfit;
  final VoidCallback onViewDetails;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onViewDetails,
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
              flex: 6,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: colors.white),
                      child: outfit.resultImageUrl.isEmpty
                          ? Center(
                              child: Icon(
                                Icons.checkroom_rounded,
                                color: colors.primaryLight,
                                size: 54,
                              ),
                            )
                          : AppCachedImage(
                              url: outfit.resultImageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.nightDeep.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: colors.primaryLight,
                          size: 18,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outfit.top.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '+ ${outfit.bottom.name}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.slate,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          '\$${outfit.totalPrice.toStringAsFixed(2)}',
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
                            onTap: onViewDetails,
                            child: Center(
                              child: Text(
                                'Ver y comprar',
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

class _FavoriteCard extends StatelessWidget {
  const _FavoriteCard({
    required this.product,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final genderLabel = product.gender == 'woman' ? 'Mujer' : 'Hombre';
    final hasOffer = product.priceOld != null;

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
              flex: 6,
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
                          : AppCachedImage(url: product.firstImageUrl!),
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
                      onTap: onToggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colors.nightDeep.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: colors.primaryLight,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.nightDeep.withValues(alpha: 0.6),
                        borderRadius: kBorderRadiusAllXLarge,
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Text(
                        genderLabel,
                        style: context.typography.labelSmall?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Imagen protagonista (flex 6) y ficha compacta: nombre con su
            // precio justo debajo — sin huecos muertos
            Expanded(
              flex: 3,
              child: Padding(
                padding: kSpaceDeviceSm,
                child: Column(
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
                    const Gap(4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: context.typography.labelLarge?.copyWith(
                        color: colors.primaryLight,
                        fontWeight: FontWeight.w900,
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
