import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/try_on/view/main/upload_photo_screen.dart';
import '../../../../feature/profile/view/main/profile_screen.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../widget/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) return;

    if (index == 4) {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_rounded, color: colors.white),
                    const Spacer(),
                    Text(
                      'Zafira',
                      style: context.typography.titleLarge?.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.notifications_none_rounded, color: colors.white),
                  ],
                ),
                const Gap(separatorLg),

                Text(
                  'Hola, Sofía',
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
                const Gap(separatorLg),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: colors.nightInput,
                    borderRadius: kBorderRadiusAllXLarge,
                    border: Border.all(color: colors.nightBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: colors.slate, size: 20),
                      const Gap(separatorSm),
                      Expanded(
                        child: Text(
                          'Buscar prendas, estilos o colores...',
                          style: context.typography.bodySmall?.copyWith(
                            color: colors.slate,
                          ),
                        ),
                      ),
                      Icon(Icons.tune_rounded, color: colors.slate, size: 20),
                    ],
                  ),
                ),
                const Gap(separatorLg),

                Row(
                  children: [
                    Expanded(
                      child: _DashboardActionCard(
                        icon: Icons.add_a_photo_outlined,
                        title: 'Subir foto',
                        subtitle: 'Desde galería',
                        onTap: () => _goToUpload(context),
                      ),
                    ),
                    const Gap(separatorMd),
                    Expanded(
                      child: _DashboardActionCard(
                        icon: Icons.photo_camera_outlined,
                        title: 'Tomarse foto',
                        subtitle: 'Usar cámara',
                        highlighted: true,
                        onTap: () => _goToUpload(context),
                      ),
                    ),
                  ],
                ),
                const Gap(separatorMd),

                Container(
                  width: double.infinity,
                  padding: kSpaceDeviceMd,
                  decoration: BoxDecoration(
                    color: colors.nightCard.withValues(alpha: 0.65),
                    borderRadius: kBorderRadiusAllMedium,
                    border: Border.all(color: colors.nightBorder),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: colors.primary.withValues(alpha: 0.18),
                        child: Icon(
                          Icons.checkroom_rounded,
                          color: colors.primaryLight,
                        ),
                      ),
                      const Gap(separatorMd),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mi selección',
                              style: context.typography.labelLarge?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Tus looks guardados aparecerán aquí',
                              style: context.typography.bodySmall?.copyWith(
                                color: colors.slate,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded, color: colors.slate),
                    ],
                  ),
                ),
                const Gap(separatorXLg),

                Row(
                  children: [
                    Text(
                      'Prendas destacadas',
                      style: context.typography.titleMedium?.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Ver todo',
                      style: context.typography.labelSmall?.copyWith(
                        color: colors.primaryLight,
                      ),
                    ),
                  ],
                ),
                const Gap(separatorMd),

                const Row(
                  children: [
                    Expanded(child: _GarmentCard(title: 'Vestido neón')),
                    Gap(separatorMd),
                    Expanded(child: _GarmentCard(title: 'Chaqueta urbana')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 0,
        onTap: (index) => _onNavTap(context, index),
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
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllMedium,
      child: Container(
        height: 118,
        padding: kSpaceDeviceMd,
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: highlighted ? colors.primaryLight : colors.nightBorder,
            width: highlighted ? 1.4 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: highlighted ? colors.primaryLight : colors.white,
              size: 28,
            ),
            const Spacer(),
            Text(
              title,
              style: context.typography.labelLarge?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              subtitle,
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