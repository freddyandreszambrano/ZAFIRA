import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/auth/view/controller/auth_controller.dart';
import '../../../../feature/auth/view/widgets/login/login_screen.dart';
import '../../../../feature/home/view/widget/home_bottom_nav.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

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
    if (index == 4) return;

    if (index == 0) {
      context.go('/');
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: colors.primary.withValues(alpha: 0.25),
                      child: Icon(
                        Icons.person_rounded,
                        size: 60,
                        color: colors.primaryLight,
                      ),
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
                    _showPersonalData(context, ref);
                  },
                ),
                const Gap(separatorSm),
                _ProfileOption(
                  icon: Icons.checkroom_rounded,
                  title: 'Preferencias',
                  subtitle: 'Tallas, estilos y colores AI',
                  onTap: () {},
                ),
                const Gap(separatorSm),
                _ProfileOption(
                  icon: Icons.settings_outlined,
                  title: 'Configuración',
                  subtitle: 'Privacidad y notificaciones',
                  onTap: () {},
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

  void _showPersonalData(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final user = ref.read(authControllerProvider).user;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.nightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(kRadiusXLg),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: kSpaceDeviceLg,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Datos personales',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Gap(separatorLg),
              _PersonalDataItem(
                label: 'Nombre',
                value: user?.firstName ?? 'No disponible',
              ),
              _PersonalDataItem(
                label: 'Apellido',
                value: user?.lastName ?? 'No disponible',
              ),
              _PersonalDataItem(
                label: 'Correo',
                value: user?.email ?? 'No disponible',
              ),
              _PersonalDataItem(
                label: 'DNI',
                value: user?.dni ?? 'No disponible',
              ),
              const Gap(separatorMd),
            ],
          ),
        );
      },
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

class _PersonalDataItem extends StatelessWidget {
  const _PersonalDataItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: kSpaceDeviceVSm,
      child: Row(
        children: [
          Text(
            '$label:',
            style: context.typography.labelMedium?.copyWith(
              color: colors.slate,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(separatorSm),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'No disponible',
              textAlign: TextAlign.right,
              style: context.typography.labelMedium?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}