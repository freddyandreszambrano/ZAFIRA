import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../controller/catalog_controller.dart';
import 'catalog_garments_screen.dart';

class _CategoryEntry {
  const _CategoryEntry(this.label, this.icon, this.categoryQuery);

  final String label;
  final IconData icon;
  final String categoryQuery;
}

class _GenderSection {
  const _GenderSection(this.label, this.gender, this.categories);

  final String label;
  final String gender;
  final List<_CategoryEntry> categories;
}

const _genderSections = [
  _GenderSection('Mujer', 'woman', [
    _CategoryEntry(
      'Vestidos y faldas',
      Icons.checkroom_rounded,
      'FALDAS Y VESTIDOS',
    ),
    _CategoryEntry('Blusas', Icons.dry_cleaning_rounded, 'BLUSAS'),
    _CategoryEntry(
      'Pantalones',
      Icons.shopping_bag_rounded,
      'JEANS Y PANTALONES',
    ),
    _CategoryEntry('Chaquetas', Icons.layers_rounded, 'BLAZERS Y CONJUNTOS'),
  ]),
  _GenderSection('Hombre', 'man', [
    _CategoryEntry('Camisas', Icons.checkroom_rounded, 'CAMISAS'),
    _CategoryEntry(
      'Camisetas',
      Icons.dry_cleaning_rounded,
      'CAMISETAS Y POLOS',
    ),
    _CategoryEntry(
      'Pantalones',
      Icons.shopping_bag_rounded,
      'JEANS Y PANTALONES',
    ),
    _CategoryEntry(
      'Shorts',
      Icons.accessibility_new_rounded,
      'SHORTS Y BERMUDAS',
    ),
    _CategoryEntry('Chaquetas', Icons.layers_rounded, 'CHAQUETAS Y ABRIGOS'),
  ]),
];

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  static const routeName = '/catalog';

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selectedSection = _genderSections[_selectedIndex];

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
                    Text(
                      'Categorías',
                      style: context.typography.titleLarge?.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const Gap(separatorMd),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colors.nightCard,
                    borderRadius: kBorderRadiusAllXLarge,
                  ),
                  child: Row(
                    children: List.generate(_genderSections.length, (index) {
                      final isSelected = index == _selectedIndex;
                      final section = _genderSections[index];

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedIndex = index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? colors.gradientPrimary
                                  : null,
                              borderRadius: kBorderRadiusAllXLarge,
                            ),
                            child: Text(
                              section.label,
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
                ),
                const Gap(separatorLg),
                Expanded(
                  child: ListView.separated(
                    itemCount: selectedSection.categories.length,
                    separatorBuilder: (_, _) => const Gap(separatorMd),
                    itemBuilder: (context, index) {
                      final entry = selectedSection.categories[index];

                      return _CategoryRow(
                        gender: selectedSection.gender,
                        entry: entry,
                        onTap: () => context.push(
                          CatalogGarmentsScreen.routeName,
                          extra: {
                            'gender': selectedSection.gender,
                            'category': entry.categoryQuery,
                            'categoryLabel': entry.label,
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow({
    required this.gender,
    required this.entry,
    required this.onTap,
  });

  final String gender;
  final _CategoryEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllLarge,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllLarge,
          border: Border.all(color: colors.primary.withValues(alpha: 0.45)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: kBorderRadiusAllMedium,
              child: Container(
                width: 52,
                height: 52,
                color: colors.white,
                child: FutureBuilder<String?>(
                  future: ref
                      .read(catalogControllerProvider.notifier)
                      .getCategoryThumbnail(
                        gender: gender,
                        category: entry.categoryQuery,
                      ),
                  builder: (context, snapshot) {
                    final imageUrl = snapshot.data;
                    if (imageUrl == null) {
                      return Icon(
                        entry.icon,
                        color: colors.primaryLight,
                        size: 24,
                      );
                    }
                    return Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        entry.icon,
                        color: colors.primaryLight,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Gap(separatorMd),
            Expanded(
              child: Text(
                entry.label,
                style: context.typography.labelMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.slate),
          ],
        ),
      ),
    );
  }
}
