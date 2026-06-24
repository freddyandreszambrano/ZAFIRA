import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import 'catalog_categories_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  static const routeName = '/catalog';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: colors.authBackground,
        ),
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: colors.white,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Catálogo',
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
                  'Elige una sección',
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Gap(separatorXSm),

                Text(
                  'Selecciona el tipo de prendas que deseas explorar.',
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.slate,
                  ),
                ),

                const Gap(separatorLg),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 260,
                          child: _GenderCatalogCard(
                            icon: Icons.female_rounded,
                            title: 'Mujer',
                            subtitle: 'Vestidos, blusas, faldas y más',
                            onTap: () => context.push(
                              CatalogCategoriesScreen.routeName,
                              extra: 'woman',
                            ),
                          ),
                        ),

                        const Gap(separatorLg),

                        SizedBox(
                          height: 260,
                          child: _GenderCatalogCard(
                            icon: Icons.male_rounded,
                            title: 'Hombre',
                            subtitle:
                            'Camisas, pantalones, chaquetas y más',
                            onTap: () => context.push(
                              CatalogCategoriesScreen.routeName,
                              extra: 'man',
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
        ),
      ),
    );
  }
}

class _GenderCatalogCard extends StatelessWidget {
  const _GenderCatalogCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllXLarge,
      child: Container(
        width: double.infinity,
        padding: kSpaceDeviceLg,
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllXLarge,
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.45),
            width: 1.4,
          ),
          boxShadow: colors.shadowZafira,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -12,
              top: -12,
              child: Icon(
                icon,
                size: 130,
                color: colors.primary.withValues(alpha: 0.13),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: colors.gradientPrimary,
                  ),
                  child: Icon(
                    icon,
                    color: colors.white,
                    size: 34,
                  ),
                ),

                const Gap(separatorLg),

                Text(
                  title,
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Gap(separatorXSm),

                Text(
                  subtitle,
                  style: context.typography.bodyMedium?.copyWith(
                    color: colors.slateSoft,
                  ),
                ),

                const Gap(separatorMd),

                Row(
                  children: [
                    Text(
                      'Explorar prendas',
                      style: context.typography.labelMedium?.copyWith(
                        color: colors.primaryLight,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Gap(separatorSm),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: colors.primaryLight,
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}