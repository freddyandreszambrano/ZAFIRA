import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../state/recommend_state.dart';
import 'outfit_card.dart';

class ResultPanel extends StatelessWidget {
  const ResultPanel({
    required this.state,
    required this.onRefresh,
    required this.onTryOn,
    super.key,
  });

  final RecommendState state;
  final VoidCallback onRefresh;
  final VoidCallback onTryOn;

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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primary),
            const Gap(16),
            Text(
              'IA generando outfits...',
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
              ),
            ),
          ],
        ),
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
            ),
          ),
        ),
        // Bottom actions — solo "3 nuevos"
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          decoration: BoxDecoration(
            color: colors.nightCard,
            border: Border(top: BorderSide(color: colors.nightBorder)),
          ),
          child: SizedBox(
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
                side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
