import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/auth/view/controller/auth_controller.dart';
import '../../../../feature/auth/view/widgets/forgot_password/forgot_password_screen.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = '/profile/settings';

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late bool _notificationsEnabled;
  late String _language;

  @override
  void initState() {
    super.initState();

    final user = ref.read(authControllerProvider).user;
    _notificationsEnabled =
        (user?.stylePreferences['notifications_enabled'] as bool?) ?? true;
    _language = user?.language ?? 'es';
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);

    final preferences = Map<String, dynamic>.from(
      ref.read(authControllerProvider).user?.stylePreferences ?? {},
    )..['notifications_enabled'] = value;

    final ok = await ref.read(authControllerProvider.notifier).updateProfile({
      'style_preferences': preferences,
    });

    if (!mounted) return;
    if (!ok) {
      AppNotification.error(context, 'No se pudo actualizar la preferencia');
    }
  }

  Future<void> _changeLanguage(String language) async {
    setState(() => _language = language);

    final ok = await ref.read(authControllerProvider.notifier).updateProfile({
      'language': language,
    });

    if (!mounted) return;
    if (ok) {
      AppNotification.success(context, 'Idioma actualizado');
    } else {
      AppNotification.error(context, 'No se pudo actualizar el idioma');
    }
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
                        'Configuración',
                        textAlign: TextAlign.center,
                        style: context.typography.titleMedium?.copyWith(
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
                  'Privacidad y notificaciones',
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXLg),
                _SettingsCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: colors.primaryLight,
                    title: Text(
                      'Notificaciones push',
                      style: context.typography.labelLarge?.copyWith(
                        color: colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: Text(
                      'Recibir avisos de novedades y ofertas',
                      style: context.typography.bodySmall?.copyWith(
                        color: colors.slate,
                      ),
                    ),
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                  ),
                ),
                const Gap(separatorMd),
                _SettingsCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Idioma',
                        style: context.typography.labelLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(separatorSm),
                      Row(
                        children: [
                          Expanded(
                            child: _LanguageChip(
                              label: 'Español',
                              selected: _language == 'es',
                              onTap: () => _changeLanguage('es'),
                            ),
                          ),
                          const Gap(separatorSm),
                          Expanded(
                            child: _LanguageChip(
                              label: 'English',
                              selected: _language == 'en',
                              onTap: () => _changeLanguage('en'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(separatorMd),
                _SettingsCard(
                  child: InkWell(
                    onTap: () => context.push(ForgotPasswordScreen.routeName),
                    child: Row(
                      children: [
                        Icon(Icons.lock_outline_rounded, color: colors.primaryLight),
                        const Gap(separatorMd),
                        Expanded(
                          child: Text(
                            'Cambiar contraseña',
                            style: context.typography.labelLarge?.copyWith(
                              color: colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: colors.slate),
                      ],
                    ),
                  ),
                ),
                const Gap(separatorMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      padding: kSpaceDeviceMd,
      decoration: BoxDecoration(
        color: colors.nightCard.withValues(alpha: 0.72),
        borderRadius: kBorderRadiusAllMedium,
        border: Border.all(color: colors.nightBorder),
      ),
      child: child,
    );
  }
}

class _LanguageChip extends StatelessWidget {
  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      borderRadius: kBorderRadiusAllMedium,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? colors.gradientPrimary : null,
          color: selected ? null : colors.nightInput,
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: selected ? Colors.transparent : colors.nightBorder,
          ),
        ),
        child: Text(
          label,
          style: context.typography.labelMedium?.copyWith(
            color: selected ? colors.white : colors.slateSoft,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
