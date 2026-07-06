import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/context_helper.dart';
import '../../domain/recommend_model.dart';
import 'piece_column.dart';

class OutfitCard extends StatelessWidget {
  const OutfitCard({
    required this.outfit,
    required this.number,
    required this.occasion,
    required this.onTryOn,
    super.key,
  });

  final OutfitModel outfit;
  final int number;
  final String occasion;
  final ValueChanged<OutfitModel> onTryOn;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.nightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.nightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: colors.nightBorder)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: colors.primary,
                ),
                const Gap(6),
                Text(
                  'Outfit $number',
                  style: context.typography.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${outfit.totalPrice.toStringAsFixed(2)} total',
                  style: context.typography.labelSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: outfit.isComplete
                // Vestido / enterizo: una sola prenda centrada
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: PieceColumn(label: 'VESTIDO', product: outfit.top),
                    ),
                  )
                // Combinación normal: torso + piernas lado a lado
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PieceColumn(label: 'TORSO', product: outfit.top),
                      ),
                      const Gap(10),
                      Expanded(
                        child: PieceColumn(
                          label: 'PIERNAS',
                          product: outfit.bottom!,
                        ),
                      ),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onTryOn(outfit),
                icon: const Icon(Icons.person_pin_rounded, size: 16),
                label: Text(
                  'Probar este outfit',
                  style: context.typography.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.secondary,
                  foregroundColor: colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
