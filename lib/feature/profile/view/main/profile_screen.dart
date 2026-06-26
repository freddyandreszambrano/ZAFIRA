import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'edit_profile_screen.dart';
import 'preferences_screen.dart';
import 'settings_screen.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/auth/view/controller/auth_controller.dart';
import '../../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../../feature/catalog/view/main/catalog_screen.dart';
import '../../../../feature/favorites/view/main/favorites_screen.dart';
import '../../../../feature/home/view/widget/home_bottom_nav.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  Future<void> _pickAndUploadAvatar(
    BuildContext context,
    WidgetRef ref,
    bool hasAvatar,
  ) async {
    final action = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(hasAvatar ? 'Cambiar foto' : 'Foto de perfil'),
        content: Text(
          hasAvatar ? '¿Deseas cambiar tu foto?' : '¿Deseas seleccionar una imagen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          if (hasAvatar)
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, 'delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              child: const Text('Eliminar foto'),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, 'select'),
            child: Text(hasAvatar ? 'Cambiar foto' : 'Seleccionar imagen'),
          ),
        ],
      ),
    );

    if (action == null || !context.mounted) return;

    if (action == 'delete') {
      final ok = await ref.read(authControllerProvider.notifier).deleteAvatar();

      if (!context.mounted) return;

      if (ok) {
        AppNotification.success(context, 'Foto de perfil eliminada');
      } else {
        AppNotification.error(context, 'No se pudo eliminar la foto de perfil');
      }
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null || !context.mounted) return;

    final colors = context.appColors;
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar foto',
          toolbarColor: colors.nightDeep,
          toolbarWidgetColor: colors.white,
          backgroundColor: colors.nightDeep,
          activeControlsWidgetColor: colors.primary,
          cropFrameColor: colors.primary,
          cropGridColor: colors.primary.withValues(alpha: 0.4),
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Ajustar foto',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (cropped == null || !context.mounted) return;

    final ok = await ref
        .read(authControllerProvider.notifier)
        .updateAvatar(cropped.path);

    if (!context.mounted) return;

    if (ok) {
      AppNotification.success(context, 'Foto de perfil actualizada');
    } else {
      AppNotification.error(context, 'No se pudo actualizar la foto de perfil');
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final preferences = await SharedPreferences.getInstance();

    await ref.read(authControllerProvider.notifier).logout();

    await preferences.clear();

    if (!context.mounted) return;

    while (context.canPop()) {
      context.pop();
    }

    context.go(LoginScreen.routeName);
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 0) {
      context.go('/');
      return;
    }

    if (index == 1) {
      context.push(CatalogScreen.routeName);
      return;
    }

    if (index == 2) {
      context.push(FavoritesScreen.routeName);
      return;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final user = ref.watch(authControllerProvider).user;

    final fullName = [
      user?.firstName ?? '',
      user?.lastName ?? '',
    ].where((value) => value.trim().isNotEmpty).join(' ');

    final displayName = fullName.isNotEmpty ? fullName : 'Usuario Zafira';
    final displayEmail =
    (user?.email ?? '').isNotEmpty ? user!.email : 'Correo no disponible';

    final initials = [
      user?.firstName ?? '',
      user?.lastName ?? '',
    ]
        .where((e) => e.trim().isNotEmpty)
        .map((e) => e.trim()[0].toUpperCase())
        .join();

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
                GestureDetector(
                  onTap: () => _pickAndUploadAvatar(
                    context,
                    ref,
                    (user?.image ?? '').isNotEmpty,
                  ),
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: colors.primary.withValues(alpha: 0.25),
                        backgroundImage: (user?.image ?? '').isNotEmpty
                            ? NetworkImage(user!.image)
                            : null,
                        child: (user?.image ?? '').isEmpty
                            ? Text(
                                initials.isNotEmpty ? initials : 'Z',
                                style: context.typography.headlineMedium?.copyWith(
                                  color: colors.primaryLight,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            : null,
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colors.nightCard,
                        child: Icon(
                          Icons.edit_rounded,
                          size: 14,
                          color: colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(separatorMd),
                Text(
                  displayName,
                  style: context.typography.titleMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  displayEmail,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.18),
                    borderRadius: kBorderRadiusAllLarge,
                  ),
                  child: Text(
                    'Usuario Mobile',
                    style: context.typography.labelSmall?.copyWith(
                      color: colors.primaryLight,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Gap(separatorLg),
                _ProfileOption(
                  icon: Icons.lock_outline,
                  title: 'Datos personales',
                  subtitle: 'Gestiona tu información básica',
                  onTap: () {
                    context.push(EditProfileScreen.routeName);
                  },
                ),
                const Gap(separatorSm),
                _ProfileOption(
                  icon: Icons.checkroom_rounded,
                  title: 'Preferencias',
                  subtitle: 'Tallas, estilos y colores AI',
                  onTap: () {
                    context.push(PreferencesScreen.routeName);
                  },
                ),
                const Gap(separatorSm),
                _ProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  subtitle: 'Privacidad y notificaciones',
                  onTap: () {
                    context.push(SettingsScreen.routeName);
                  },
                ),
                const Gap(separatorXLg),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Cerrar sesión'),
                          content: const Text(
                            '¿Estás seguro de que deseas cerrar sesión?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext, false),
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(dialogContext, true),
                              child: const Text('Sí'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await _logout(context, ref);
                      }
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Cerrar sesión'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: BorderSide(
                        color: Colors.redAccent.withValues(alpha: 0.5),
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: kBorderRadiusAllSmall,
                      ),
                    ),
                  ),
                    ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: 4,
        onTap: (index) => _onNavTap(context, index),
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
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
      borderRadius: kBorderRadiusAllMedium,
      child: Container(
        padding: kSpaceDeviceMd,
        decoration: BoxDecoration(
          color: colors.nightCard.withValues(alpha: 0.72),
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(color: colors.nightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: colors.primaryLight),
            const Gap(separatorMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.typography.labelLarge?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.slate,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colors.slate),
          ],
        ),
      ),
    );
  }
}
