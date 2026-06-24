import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import 'catalog_garments_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.garment, super.key});

  static const routeName = '/catalog/product';

  final Garment garment;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final garment = widget.garment;
    final genderLabel = garment.gender == 'woman' ? 'Mujer' : 'Hombre';

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: kSpaceDeviceHLg,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => isFavorite = !isFavorite),
                      child: AnimatedScale(
                        scale: isFavorite ? 1.15 : 1.0,
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutBack,
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorite ? colors.primaryLight : colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: kSpaceDeviceHLg,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 320,
                        decoration: BoxDecoration(
                          color: colors.nightCard,
                          borderRadius: kBorderRadiusAllLarge,
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.45),
                          ),
                          boxShadow: colors.shadowZafira,
                        ),
                        child: garment.imageUrl == null
                            ? Center(
                          child: Icon(
                            Icons.checkroom_rounded,
                            color: colors.primaryLight,
                            size: 96,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: kBorderRadiusAllLarge,
                          child: Image.network(
                            garment.imageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const Gap(separatorLg),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: colors.gradientPrimary,
                              borderRadius: kBorderRadiusAllXLarge,
                            ),
                            child: Text(
                              genderLabel,
                              style: context.typography.labelSmall?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const Gap(separatorSm),
                          if (garment.badgeLabel != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colors.nightCard,
                                borderRadius: kBorderRadiusAllXLarge,
                                border: Border.all(
                                  color: colors.primary.withValues(alpha: 0.45),
                                ),
                              ),
                              child: Text(
                                garment.badgeLabel!,
                                style: context.typography.labelSmall?.copyWith(
                                  color: colors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const Gap(separatorMd),
                      Text(
                        garment.name,
                        style: context.typography.headlineSmall?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Gap(separatorXSm),
                      Text(
                        garment.category,
                        style: context.typography.bodyMedium?.copyWith(
                          color: colors.slate,
                        ),
                      ),
                      const Gap(separatorMd),
                      Text(
                        '\$${garment.price.toStringAsFixed(2)}',
                        style: context.typography.headlineSmall?.copyWith(
                          color: colors.primaryLight,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Gap(separatorLg),
                      Text(
                        'Descripción',
                        style: context.typography.titleMedium?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(separatorXSm),
                      Text(
                        garment.description,
                        style: context.typography.bodyMedium?.copyWith(
                          color: colors.slate,
                        ),
                      ),
                      const Gap(separatorXLg),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: kSpaceDeviceHLg,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: colors.gradientPrimary,
                      borderRadius: kBorderRadiusAllMedium,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: kBorderRadiusAllMedium,
                        onTap: () => AppNotification.info(
                          context,
                          'Try-On con IA disponible próximamente',
                        ),
                        child: Center(
                          child: Text(
                            'Probar con IA',
                            style: context.typography.labelLarge?.copyWith(
                              color: colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(separatorMd),
            ],
          ),
        ),
      ),
    );
  }
}