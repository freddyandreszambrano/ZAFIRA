import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../domain/product_model.dart';
import '../controller/catalog_controller.dart';
import '../state/catalog_state.dart';
import 'product_detail_screen.dart';

class CatalogGarmentsScreen extends ConsumerStatefulWidget {
  const CatalogGarmentsScreen({
    required this.gender,
    required this.category,
    super.key,
  });

  static const routeName = '/catalog/garments';

  final String gender;
  final String category;

  @override
  ConsumerState<CatalogGarmentsScreen> createState() =>
      _CatalogGarmentsScreenState();
}

class _CatalogGarmentsScreenState extends ConsumerState<CatalogGarmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(catalogControllerProvider.notifier).getProducts(
        gender: widget.gender,
        category: widget.category,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final genderLabel = widget.gender == 'woman' ? 'Mujer' : 'Hombre';
    final state = ref.watch(catalogControllerProvider);

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
                        widget.category,
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
                  widget.category,
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Prendas disponibles en esta categoría.',
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorLg),
                Expanded(
                  child: _buildContent(context, state, genderLabel),
                ),
              ],
            ),
          ),
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
      return Center(
        child: CircularProgressIndicator(color: colors.primaryLight),
      );
    }

    if (state.status == ResponseStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'No se pudieron cargar las prendas.',
          textAlign: TextAlign.center,
          style: context.typography.bodyMedium?.copyWith(color: colors.slate),
        ),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: separatorMd,
        crossAxisSpacing: separatorMd,
        childAspectRatio: 0.58,
      ),
      itemBuilder: (context, index) {
        final product = state.products[index];
        return _GarmentCard(
          product: product,
          genderLabel: genderLabel,
          onTap: () => context.push(
            ProductDetailScreen.routeName,
            extra: product,
          ),
        );
      },
    );
  }
}

class _GarmentCard extends StatefulWidget {
  const _GarmentCard({
    required this.product,
    required this.genderLabel,
    required this.onTap,
  });

  final ProductModel product;
  final String genderLabel;
  final VoidCallback onTap;

  @override
  State<_GarmentCard> createState() => _GarmentCardState();
}

class _GarmentCardState extends State<_GarmentCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasOffer = widget.product.priceOld != null;

    return InkWell(
      onTap: widget.onTap,
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
                      decoration: BoxDecoration(
                        color: colors.white,
                      ),
                      child: widget.product.firstImageUrl == null
                          ? Center(
                        child: Icon(
                          Icons.checkroom_rounded,
                          color: colors.primaryLight,
                          size: 54,
                        ),
                      )
                          : Image.network(
                        widget.product.firstImageUrl!,
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
                      onTap: () => setState(() => isFavorite = !isFavorite),
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
                            color: isFavorite ? colors.primaryLight : colors.white,
                            size: 18,
                          ),
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
                        widget.genderLabel,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelMedium?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(separatorXSm),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: context.typography.labelLarge?.copyWith(
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
                            onTap: widget.onTap,
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