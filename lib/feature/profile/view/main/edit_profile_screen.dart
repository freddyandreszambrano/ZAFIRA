import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../feature/auth/view/controller/auth_controller.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/profile/edit';

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _dniController;
  late final TextEditingController _countryController;
  late final TextEditingController _sizeController;

  String _gender = '';

  @override
  void initState() {
    super.initState();

    final user = ref.read(authControllerProvider).user;

    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _dniController = TextEditingController(text: user?.dni ?? '');
    _countryController = TextEditingController(text: user?.country ?? 'Ecuador');
    _sizeController = TextEditingController(text: user?.preferredSize ?? '');
    _gender = user?.gender ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dniController.dispose();
    _countryController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await ref.read(authControllerProvider.notifier).updateProfile({
      'first_name': _firstNameController.text.trim(),
      'last_name': _lastNameController.text.trim(),
      'gender': _gender,
      'country': _countryController.text.trim(),
      'preferred_size': _sizeController.text.trim(),
    });

    if (!mounted) return;

    if (ok) {
      AppNotification.success(context, 'Perfil actualizado correctamente');
      context.pop();
    } else {
      AppNotification.error(context, 'No se pudo actualizar el perfil');
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
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(Icons.arrow_back, color: colors.white),
                      ),
                      Expanded(
                        child: Text(
                          'Editar perfil',
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
                    'Datos personales',
                    style: context.typography.headlineSmall?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Gap(separatorXSm),
                  Text(
                    'Actualiza la información que usará Zafira para personalizar tu experiencia.',
                    textAlign: TextAlign.center,
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.slate,
                      height: 1.35,
                    ),
                  ),
                  const Gap(separatorXLg),
                  _EditField(
                    controller: _firstNameController,
                    label: 'Nombre',
                    hint: 'Ingresa tu nombre',
                    icon: Icons.person_outline_rounded,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  const Gap(separatorMd),
                  _EditField(
                    controller: _lastNameController,
                    label: 'Apellido',
                    hint: 'Ingresa tu apellido',
                    icon: Icons.badge_outlined,
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Ingrese su apellido';
                      }
                      return null;
                    },
                  ),
                  const Gap(separatorMd),
                  _EditField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    hint: 'Correo',
                    icon: Icons.email_outlined,
                    readOnly: true,
                  ),
                  const Gap(separatorMd),
                  _EditField(
                    controller: _dniController,
                    label: 'Cédula',
                    hint: 'Cédula',
                    icon: Icons.credit_card_rounded,
                    readOnly: true,
                  ),
                  const Gap(separatorMd),
                  _GenderSelector(
                    value: _gender,
                    onChanged: (value) {
                      setState(() => _gender = value);
                    },
                  ),
                  const Gap(separatorMd),
                  _EditField(
                    controller: _countryController,
                    label: 'País',
                    hint: 'Ecuador',
                    icon: Icons.public_rounded,
                  ),
                  const Gap(separatorMd),
                  _EditField(
                    controller: _sizeController,
                    label: 'Talla preferida',
                    hint: 'Ej: S, M, L, XL',
                    icon: Icons.checkroom_rounded,
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
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                            borderRadius: kBorderRadiusAllLarge,
                          ),
                        ),
                        icon: isLoading
                            ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.white,
                          ),
                        )
                            : Icon(
                          Icons.save_outlined,
                          color: colors.white,
                        ),
                        label: Text(
                          isLoading ? 'Guardando...' : 'Guardar cambios',
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
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.readOnly = false,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.typography.labelMedium?.copyWith(
            color: colors.slateSoft,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(separatorSm),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          validator: validator,
          cursorColor: colors.primary,
          style: context.typography.bodyMedium?.copyWith(
            color: readOnly ? colors.slateSoft : colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly
                ? colors.nightInput.withValues(alpha: 0.55)
                : colors.nightInput,
            hintText: hint,
            hintStyle: context.typography.bodySmall?.copyWith(
              color: colors.slate,
            ),
            prefixIcon: Icon(
              readOnly ? Icons.lock_outline_rounded : icon,
              color: readOnly ? colors.slate : colors.primaryLight,
              size: 20,
            ),
            suffixIcon: readOnly
                ? Icon(
              Icons.lock_rounded,
              color: colors.slate,
              size: 18,
            )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: kBorderRadiusAllMedium,
              borderSide: BorderSide(color: colors.nightBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: kBorderRadiusAllMedium,
              borderSide: BorderSide(color: colors.primaryLight, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: kBorderRadiusAllMedium,
              borderSide: BorderSide(color: colors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: kBorderRadiusAllMedium,
              borderSide: BorderSide(color: colors.error, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género',
          style: context.typography.labelMedium?.copyWith(
            color: colors.slateSoft,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Gap(separatorSm),
        Row(
          children: [
            Expanded(
              child: _GenderChip(
                label: 'Masculino',
                value: 'M',
                selectedValue: value,
                onTap: onChanged,
              ),
            ),
            const Gap(separatorSm),
            Expanded(
              child: _GenderChip(
                label: 'Femenino',
                value: 'F',
                selectedValue: value,
                onTap: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onTap,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = value == selectedValue;

    return InkWell(
      onTap: () => onTap(value),
      borderRadius: kBorderRadiusAllMedium,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.22)
              : colors.nightInput,
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(
            color: selected ? colors.primaryLight : colors.nightBorder,
          ),
        ),
        child: Text(
          label,
          style: context.typography.labelMedium?.copyWith(
            color: selected ? colors.primaryLight : colors.slateSoft,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}