import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../core/models/product_model.dart';
import '../../../../feature/auth/view/main/profile_screen.dart';
import '../../../../feature/auth/view/main/upload_photo_screen.dart';
import '../../../../feature/auth/view/state/auth_session_provider.dart';
import '../../../../feature/catalog/view/main/catalog_screen.dart';
import '../../../../feature/catalog/view/main/product_detail_screen.dart';
import '../../../../feature/favorites/view/main/favorites_screen.dart';
import '../../../../feature/recommend/view/main/recommend_screen.dart';
import '../../../../modules/common/widget/layout/app_screen_shell.dart';
import '../../../../modules/common/widget/navigation/home_bottom_nav.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../controller/home_controller.dart';
import 'home_load_error.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _carouselController = PageController();

  int _carouselPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(homeControllerProvider.notifier).loadDashboardProducts(),
    );
  }

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;

    if (index == 1) {
      context.push(CatalogScreen.routeName);
      return;
    }

    if (index == 2) {
      context.push(FavoritesScreen.routeName);
      return;
    }

    if (index == 3) {
      context.go(ProfileScreen.routeName);
      return;
    }

    AppNotification.info(
      context,
      '${HomeBottomNav.items[index].label} disponible próximamente',
    );
  }

  void _goToUpload(BuildContext context) {
    context.push(UploadPhotoScreen.routeName);
  }

  void _goToProduct(BuildContext context, ProductModel product) {
    context.push(ProductDetailScreen.routeName, extra: product);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final homeState = ref.watch(homeControllerProvider);
    final recentProducts = homeState.recentProducts;
    final featuredProducts = homeState.featuredProducts;
    final user = ref.watch(currentSessionUserProvider);

    final firstName = (user?.firstName ?? '').trim();
    final fullName = (user?.fullName ?? '').trim();

    final displayName = firstName.isNotEmpty
        ? firstName
        : fullName.isNotEmpty
        ? fullName.split(' ').first
        : 'usuario';
    final displayImage = user?.displayImage ?? '';

    return AppDarkScaffold(
      centerContent: true,
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(context.gutter, 12, context.gutter, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppBrandHeader(),
            const Gap(separatorLg),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, $displayName',
                        style: context.typography.headlineSmall?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Gap(separatorXSm),
                      Text(
                        '¿Qué look vamos a probar hoy?',
                        style: context.typography.bodyMedium?.copyWith(
                          color: colors.slate,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(separatorMd),
                GestureDetector(
                  onTap: () => context.push(ProfileScreen.routeName),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: colors.primary.withValues(alpha: 0.25),
                    backgroundImage: displayImage.isNotEmpty
                        ? NetworkImage(displayImage)
                        : null,
                    child: displayImage.isEmpty
                        ? Text(
                            user?.fullInitialName ?? 'Z',
                            style: context.typography.labelLarge?.copyWith(
                              color: colors.primaryLight,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
            const Gap(separatorLg),

            // Home minimalista: explorar prendas vive en la pestaña Catálogo
            // de abajo; aquí solo las dos acciones principales, centradas
            _DashboardActionCard(
              icon: Icons.add_a_photo_outlined,
              title: 'Mi foto',
              subtitle: 'Gestionar foto',
              fullWidth: true,
              onTap: () => _goToUpload(context),
            ),
            const Gap(separatorMd),
            _DashboardActionCard(
              icon: Icons.auto_awesome_rounded,
              title: 'Recomendación IA',
              subtitle: 'Outfit personalizado con IA',
              highlighted: true,
              fullWidth: true,
              onTap: () => context.push(RecommendScreen.routeName),
            ),
            const Gap(separatorXLg),

            if (recentProducts.isNotEmpty) ...[
              Text(
                'Nuevo en Zafira',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Gap(separatorMd),
              SizedBox(
                height: context.responsive<double>(
                  compact: 210,
                  medium: 280,
                  expanded: 320,
                ),
                child: PageView.builder(
                  controller: _carouselController,
                  itemCount: recentProducts.length,
                  onPageChanged: (index) =>
                      setState(() => _carouselPage = index),
                  itemBuilder: (context, index) {
                    final product = recentProducts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: _HeroCarouselCard(
                        product: product,
                        onTap: () => _goToProduct(context, product),
                      ),
                    );
                  },
                ),
              ),
              const Gap(separatorSm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(recentProducts.length, (index) {
                  final isActive = index == _carouselPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: isActive ? 16 : 5,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? colors.primaryLight
                          : colors.nightBorder,
                      borderRadius: kBorderRadiusAllXLarge,
                    ),
                  );
                }),
              ),
              const Gap(separatorXLg),
            ],

            Text(
              'Destacadas para ti',
              style: context.typography.titleMedium?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Gap(separatorMd),

            if (homeState.status == ResponseStatus.loading)
              const Center(child: CircularProgressIndicator())
            else if (homeState.status == ResponseStatus.error)
              HomeLoadError(
                message: homeState.errorMessage,
                onRetry: () => ref
                    .read(homeControllerProvider.notifier)
                    .loadDashboardProducts(),
              )
            else if (featuredProducts.isEmpty)
              Row(
                children: const [
                  Expanded(child: _GarmentCard(title: 'Vestido neón')),
                  Gap(separatorMd),
                  Expanded(child: _GarmentCard(title: 'Chaqueta urbana')),
                ],
              )
            else
              Column(
                children: [
                  for (final product in featuredProducts) ...[
                    _FeaturedProductRow(
                      product: product,
                      onTap: () => _goToProduct(context, product),
                    ),
                    const Gap(separatorMd),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DashboardActionCard extends StatelessWidget {
  const _DashboardActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
    this.fullWidth = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllMedium,
      child: Container(
        width: fullWidth ? double.infinity : null,
        constraints: BoxConstraints(
          minHeight: fullWidth
              ? context.cardMinHeight
              : context.cardMinHeightTall,
        ),
        clipBehavior: Clip.hardEdge,
        padding: kSpaceDeviceMd,
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: highlighted ? colors.primaryLight : colors.nightBorder,
            width: highlighted ? 1.4 : 1,
          ),
        ),
        child: fullWidth
            ? Row(
                children: [
                  Icon(
                    icon,
                    color: highlighted ? colors.primaryLight : colors.white,
                    size: 28,
                  ),
                  const Gap(separatorMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelLarge?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Gap(separatorXSm),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(separatorSm),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: colors.primaryLight,
                    size: 16,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: highlighted ? colors.primaryLight : colors.white,
                    size: 28,
                  ),
                  const Gap(separatorSm),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelLarge?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(separatorXSm),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelSmall?.copyWith(
                      color: colors.slate,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _HeroCarouselCard extends StatelessWidget {
  const _HeroCarouselCard({required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasOffer = product.priceOld != null;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: kBorderRadiusAllLarge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: colors.white,
              child: product.firstImageUrl == null
                  ? Center(
                      child: Icon(
                        Icons.checkroom_rounded,
                        color: colors.primaryLight,
                        size: 64,
                      ),
                    )
                  : Image.network(
                      product.firstImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.checkroom_rounded,
                          color: colors.primaryLight,
                          size: 64,
                        ),
                      ),
                    ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    colors.nightDeep.withValues(alpha: 0.85),
                  ],
                  stops: const [0.5, 1],
                ),
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.titleMedium?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (hasOffer) ...[
                    const Gap(separatorXSm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
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
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedProductRow extends StatelessWidget {
  const _FeaturedProductRow({required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasOffer = product.priceOld != null;

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
                child: product.firstImageUrl == null
                    ? Center(
                        child: Icon(
                          Icons.checkroom_rounded,
                          color: colors.primaryLight,
                          size: 24,
                        ),
                      )
                    : Image.network(
                        product.firstImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.checkroom_rounded,
                            color: colors.primaryLight,
                            size: 24,
                          ),
                        ),
                      ),
              ),
            ),
            const Gap(separatorMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelMedium?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            if (hasOffer)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: colors.gradientPrimary,
                  borderRadius: kBorderRadiusAllXLarge,
                ),
                child: Text(
                  'Oferta',
                  style: context.typography.labelSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GarmentCard extends StatelessWidget {
  const _GarmentCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 164,
      decoration: BoxDecoration(
        color: colors.nightCard,
        borderRadius: kBorderRadiusAllLarge,
        border: Border.all(color: colors.primary.withValues(alpha: 0.45)),
        boxShadow: colors.shadowZafira,
      ),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.checkroom_rounded,
                color: colors.primaryLight,
                size: 58,
              ),
            ),
          ),
          Padding(
            padding: kSpaceDeviceSm,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typography.labelMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
