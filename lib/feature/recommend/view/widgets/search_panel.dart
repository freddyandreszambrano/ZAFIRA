import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import 'gender_chip.dart';
import 'occasion_filters.dart';

class SearchPanel extends StatelessWidget {
  const SearchPanel({
    required this.controller,
    required this.selectedStore,
    required this.selectedGender,
    required this.selectedOccasionGroup,
    required this.selectedOccasionSub,
    required this.showFreeText,
    required this.onStoreChanged,
    required this.onGenderChanged,
    required this.onOccasionGroupTap,
    required this.onOccasionSubTap,
    required this.onToggleFreeText,
    required this.onRecommend,
    required this.isLoading,
    this.isFavoritesMode = false,
    super.key,
  });

  final TextEditingController controller;
  final String selectedStore;
  final String selectedGender;
  final OccasionGroup? selectedOccasionGroup;
  final OccasionOption? selectedOccasionSub;
  final bool showFreeText;
  final ValueChanged<String?> onStoreChanged;
  final ValueChanged<String> onGenderChanged;
  final ValueChanged<OccasionGroup> onOccasionGroupTap;
  final ValueChanged<OccasionOption> onOccasionSubTap;
  final VoidCallback onToggleFreeText;
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
          OccasionFilters(
            selectedGroup: selectedOccasionGroup,
            selectedSub: selectedOccasionSub,
            onGroupTap: onOccasionGroupTap,
            onSubTap: onOccasionSubTap,
          ),
          const Gap(2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onToggleFreeText,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: Icon(
                showFreeText ? Icons.expand_less_rounded : Icons.edit_rounded,
                size: 15,
                color: colors.slate,
              ),
              label: Text(
                showFreeText ? 'Usar los filtros' : '¿Otra ocasión? Escríbela',
                style: context.typography.labelSmall?.copyWith(
                  color: colors.slate,
                  decoration: TextDecoration.underline,
                  decorationColor: colors.slate,
                ),
              ),
            ),
          ),
          if (showFreeText) ...[
            const Gap(4),
            TextField(
              controller: controller,
              autofocus: true,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.white,
              ),
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
          ],
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
          AppGradientAction(
            label: isLoading ? 'Generando outfits...' : 'Recomendar outfits',
            icon: Icons.auto_awesome_rounded,
            loading: isLoading,
            onTap: onRecommend,
          ),
        ],
      ),
    );
  }
}
