import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import 'catalog_garments_screen.dart';

class CatalogCategoriesScreen extends StatelessWidget {
  const CatalogCategoriesScreen({
    required this.gender,
    super.key,
  });

  static const routeName = '/catalog/categories';

  final String gender;

  bool get isWoman => gender == 'woman';

  List<CatalogCategory> get categories => isWoman
      ? const [
          CatalogCategory('Vestidos', Icons.checkroom_rounded),
          CatalogCategory('Blusas', Icons.dry_cleaning_rounded),
          CatalogCategory('Faldas', Icons.straighten_rounded),
          CatalogCategory('Pantalones', Icons.shopping_bag_rounded),
          CatalogCategory('Chaquetas', Icons.layers_rounded),
        ]
      : const [
          CatalogCategory('Camisas', Icons.checkroom_rounded),
          CatalogCategory('Camisetas', Icons.dry_cleaning_rounded),
          CatalogCategory('Pantalones', Icons.shopping_bag_rounded),
          CatalogCategory('Shorts', Icons.accessibility_new_rounded),
          CatalogCategory('Chaquetas', Icons.layers_rounded),
        ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final title = isWoman ? 'Mujer' : 'Hombre';

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
                        title,
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
                  'Categorías $title',
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Elige una categoría para explorar prendas.',
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorLg),
                Expanded(
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: separatorMd,
                      crossAxisSpacing: separatorMd,
                      childAspectRatio: 0.92,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      return _CategoryCard(
                        category: category,
                        onTap: () => context.push(
                          CatalogGarmentsScreen.routeName,
                          extra: {
                            'gender': gender,
                            'category': category.name,
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

class CatalogCategory {
  const CatalogCategory(this.name, this.icon);

  final String name;
  final IconData icon;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final CatalogCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllLarge,
      child: Container(
        padding: kSpaceDeviceMd,
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllLarge,
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.45),
          ),
          boxShadow: colors.shadowZafira,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.gradientPrimary,
              ),
              child: Icon(
                category.icon,
                color: colors.white,
                size: 30,
              ),
            ),
            const Gap(separatorMd),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: context.typography.labelLarge?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              'Ver prendas',
              style: context.typography.labelSmall?.copyWith(
                color: colors.primaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
