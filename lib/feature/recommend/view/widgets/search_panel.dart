import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/context_helper.dart';
import 'gender_chip.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    required this.controller,
    required this.selectedStore,
    required this.selectedGender,
    required this.onStoreChanged,
    required this.onGenderChanged,
    required this.onRecommend,
    required this.isLoading,
    this.isFavoritesMode = false,
    super.key,
  });

  final TextEditingController controller;
  final String selectedStore;
  final String selectedGender;
  final ValueChanged<String?> onStoreChanged;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onRecommend;
  final bool isLoading;
  final bool isFavoritesMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.nightCard,
        border: Border(bottom: BorderSide(color: colors.nightBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender toggle (no aplica en modo favoritos: las prendas ya están elegidas)
          if (!isFavoritesMode) ...[
            Row(
              children: [
                GenderChip(
                  label: 'Hombre',
                  icon: Icons.male_rounded,
                  selected: selectedGender == 'hombre',
                  onTap: () => onGenderChanged('hombre'),
                ),
                const Gap(10),
                GenderChip(
                  label: 'Mujer',
                  icon: Icons.female_rounded,
                  selected: selectedGender == 'mujer',
                  onTap: () => onGenderChanged('mujer'),
                ),
              ],
            ),
            const Gap(12),
          ],
          Text(
            '¿Para qué ocasión buscas outfit?',
            style: context.typography.labelMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(8),
          TextField(
            controller: controller,
            style: context.typography.bodyMedium?.copyWith(color: colors.white),
            decoration: InputDecoration(
              hintText: 'Ej: fiesta, boda, cita romántica...',
              hintStyle: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
              ),
              filled: true,
              fillColor: colors.nightInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.nightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.nightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
              prefixIcon: Icon(
                Icons.auto_awesome_rounded,
                color: colors.primary,
              ),
              isDense: true,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onRecommend(),
          ),
          if (!isFavoritesMode) ...[
            const Gap(10),
            Row(
              children: [
                Text(
                  'Tienda:',
                  style: context.typography.labelSmall?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedStore,
                    dropdownColor: colors.nightCard,
                    style: context.typography.labelSmall?.copyWith(
                      color: colors.white,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.nightInput,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colors.nightBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: colors.nightBorder),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Todas las tiendas'),
                      ),
                      DropdownMenuItem(value: 'modarm', child: Text('Modarm')),
                      DropdownMenuItem(
                        value: 'etafashion',
                        child: Text('Etafashion'),
                      ),
                    ],
                    onChanged: onStoreChanged,
                  ),
                ),
              ],
            ),
          ],
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onRecommend,
              icon: isLoading
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.white,
                      ),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 20),
              label: Text(
                isLoading ? 'Generando outfits...' : 'Recomendar outfits',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
