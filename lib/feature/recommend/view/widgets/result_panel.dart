import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import '../../../catalog/domain/product_model.dart';
import '../../domain/recommend_model.dart';
import '../state/recommend_state.dart';
import 'outfit_card.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    required this.state,
    required this.onRefresh,
    required this.onTryOn,
    this.mixTop,
    this.mixBottom,
    this.onSelectPiece,
    this.onTryOnMix,
    this.onClearMix,
    super.key,
  });

  final RecommendState state;
  final VoidCallback onRefresh;
  final ValueChanged<OutfitModel> onTryOn;

  /// Mix & match: prendas elegidas por el usuario entre los 3 outfits.
  final ProductModel? mixTop;
  final ProductModel? mixBottom;
  final void Function(ProductModel product, bool isTop)? onSelectPiece;
  final VoidCallback? onTryOnMix;
  final VoidCallback? onClearMix;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (state.status == ResponseStatus.initial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checkroom_rounded,
              size: 72,
              color: colors.slate.withValues(alpha: 0.35),
            ),
            const Gap(16),
            Text(
              'Escribe una ocasión y te\nrecomendamos hasta 3 outfits',
              textAlign: TextAlign.center,
              style: context.typography.bodyLarge?.copyWith(
                color: colors.slate,
              ),
            ),
          ],
        ),
      );
    }

    if (state.status == ResponseStatus.loading) {
      return const AppStateView(
        icon: Icons.auto_awesome_rounded,
        title: 'IA generando outfits',
        message: 'Estamos cruzando ocasion, tienda y preferencias.',
        loading: true,
      );
    }

    if (state.status == ResponseStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
              const Gap(12),
              Text(
                state.errorMessage ?? 'Error al obtener recomendación',
                textAlign: TextAlign.center,
                style: context.typography.bodyMedium?.copyWith(
                  color: colors.slate,
                ),
              ),
              const Gap(20),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh_rounded, color: colors.primary),
                label: Text(
                  'Intentar de nuevo',
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colors.primary.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final result = state.result;
    if (result == null || result.outfits.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasMix = mixTop != null || mixBottom != null;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: result.outfits.length,
            separatorBuilder: (_, _) => const Gap(12),
            itemBuilder: (context, index) => OutfitCard(
              outfit: result.outfits[index],
              number: index + 1,
              occasion: result.occasion,
              onTryOn: onTryOn,
              selectedTopId: mixTop?.id,
              selectedBottomId: mixBottom?.id,
              onSelectPiece: onSelectPiece,
            ),
          ),
        ),
        // Bottom actions — combinación propia (si hay) + "3 nuevos"
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          decoration: BoxDecoration(
            color: colors.nightCard,
            border: Border(top: BorderSide(color: colors.nightBorder)),
          ),
          child: Column(
            children: [
              if (hasMix) ...[
                Row(
                  children: [
                    Icon(
                      Icons.checkroom_rounded,
                      size: 16,
                      color: colors.primaryLight,
                    ),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        _mixSummary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typography.labelSmall?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onClearMix,
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colors.slate,
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: colors.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: onTryOnMix,
                      icon: const Icon(Icons.person_pin_rounded, size: 16),
                      label: Text(
                        mixTop != null && mixBottom != null
                            ? 'Probar mi combinación'
                            : 'Probar esta prenda',
                        style: context.typography.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(8),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onRefresh,
                  icon: Icon(
                    Icons.shuffle_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  label: Text(
                    'Generar 3 nuevos outfits',
                    style: context.typography.labelSmall?.copyWith(
                      color: colors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: colors.primary.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get _mixSummary {
    final total =
        (mixTop?.price ?? 0) + (mixBottom?.price ?? 0);
    final parts = [
      if (mixTop != null) mixTop!.name,
      if (mixBottom != null) mixBottom!.name,
    ].join(' + ');
    return '$parts  ·  \$${total.toStringAsFixed(2)}';
  }
}
