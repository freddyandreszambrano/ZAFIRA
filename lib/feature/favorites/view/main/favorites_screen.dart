import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../catalog/domain/product_model.dart';
import '../../../catalog/view/main/product_detail_screen.dart';
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

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Padding(
            padding: kSpaceDeviceHLg,
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
                  'Tus prendas guardadas',
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Prendas que marcaste con el corazón.',
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorLg),
                Expanded(child: _buildContent(context, state)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FavoriteState state) {
    final colors = context.appColors;

    if (state.status == ResponseStatus.loading ||
        state.status == ResponseStatus.initial) {
      return Center(
        child: CircularProgressIndicator(color: colors.primaryLight),
      );
    }

    if (state.status == ResponseStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'No se pudieron cargar tus favoritos.',
          textAlign: TextAlign.center,
          style: context.typography.bodyMedium?.copyWith(color: colors.slate),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              color: colors.slate,
              size: 48,
            ),
            const Gap(separatorSm),
            Text(
              'Todavía no tienes prendas favoritas.',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              'Toca el corazón en una prenda para guardarla aquí.',
              textAlign: TextAlign.center,
              style: context.typography.bodySmall?.copyWith(
                color: colors.slate,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      itemCount: state.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: separatorMd,
        crossAxisSpacing: separatorMd,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (gridItemContext, index) {
        final product = state.products[index];
        return _FavoriteCard(
          product: product,
          onTap: () => gridItemContext.push(
            ProductDetailScreen.routeName,
            extra: product,
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
            Expanded(
              flex: 4,
              child: Padding(
                padding: kSpaceDeviceSm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                'Probar con IA',
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
