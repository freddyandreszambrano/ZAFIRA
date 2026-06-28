import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/auth/view/controller/auth_controller.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

const _availableColors = [
  'Negro',
  'Blanco',
  'Azul',
  'Rojo',
  'Verde',
  'Amarillo',
  'Rosado',
  'Gris',
  'Café',
  'Beige',
  'Morado',
  'Naranja',
  'Celeste',
  'Vino',
];

const _availableCategories = [
  'Vestidos y faldas',
  'Blusas',
  'Pantalones',
  'Chaquetas',
  'Camisas',
  'Camisetas',
  'Shorts',
];

class PreferencesScreen extends ConsumerStatefulWidget {
  const PreferencesScreen({super.key});

  static const routeName = '/profile/preferences';

  @override
  ConsumerState<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends ConsumerState<PreferencesScreen> {
  late Set<String> _selectedColors;
  late Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();

    final preferences =
        ref.read(authControllerProvider).user?.stylePreferences ?? {};

    _selectedColors = {
      ...List<String>.from(preferences['colors'] as List? ?? const []),
    };
    _selectedCategories = {
      ...List<String>.from(preferences['categories'] as List? ?? const []),
    };
  }

  Future<void> _save() async {
    final ok = await ref.read(authControllerProvider.notifier).updateProfile({
      'style_preferences': {
        'colors': _selectedColors.toList(),
        'categories': _selectedCategories.toList(),
      },
    });

    if (!mounted) return;

    if (ok) {
      AppNotification.success(
        context,
        'Preferencias actualizadas correctamente',
      );
      context.pop();
    } else {
      AppNotification.error(
        context,
        'No se pudieron actualizar las preferencias',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final isLoading = ref.watch(
      authControllerProvider.select(
        (state) => state.profileState == ResponseStatus.loading,
      ),
    );

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
                        'Preferencias',
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
                  'Personaliza tu estilo',
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Esto ayudará a la IA a recomendarte prendas que se ajusten a tu gusto.',
                  textAlign: TextAlign.start,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slate,
                    height: 1.35,
                  ),
                ),
                const Gap(separatorXLg),
                Text(
                  'Colores favoritos',
                  style: context.typography.labelLarge?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(separatorSm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    final selected = _selectedColors.contains(color);
                    return _PreferenceChip(
                      label: color,
                      selected: selected,
                      onTap: () => setState(() {
                        selected
                            ? _selectedColors.remove(color)
                            : _selectedColors.add(color);
                      }),
                    );
                  }).toList(),
                ),
                const Gap(separatorXLg),
                Text(
                  'Categorías favoritas',
                  style: context.typography.labelLarge?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(separatorSm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableCategories.map((category) {
                    final selected = _selectedCategories.contains(category);
                    return _PreferenceChip(
                      label: category,
                      selected: selected,
                      onTap: () => setState(() {
                        selected
                            ? _selectedCategories.remove(category)
                            : _selectedCategories.add(category);
                      }),
                    );
                  }).toList(),
                ),
                const Gap(separatorXLg),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: colors.gradientPrimary,
                      borderRadius: kBorderRadiusAllLarge,
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: kBorderRadiusAllLarge,
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.white,
                              ),
                            )
                          : Text(
                              'Guardar preferencias',
                              style: context.typography.labelLarge?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w900,
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
      ),
    );
  }
}

class _PreferenceChip extends StatelessWidget {
  const _PreferenceChip({
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
      borderRadius: kBorderRadiusAllXLarge,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: selected ? colors.gradientPrimary : null,
          color: selected ? null : colors.nightInput,
          borderRadius: kBorderRadiusAllXLarge,
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
