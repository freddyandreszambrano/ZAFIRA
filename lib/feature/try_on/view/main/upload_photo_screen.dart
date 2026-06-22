import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import 'photo_preview_screen.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  static const routeName = '/upload-photo';

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  static const _photoKey = 'try_on_user_photo_path';

  final ImagePicker _picker = ImagePicker();

  bool _loading = false;
  String? _savedPhotoPath;

  @override
  void initState() {
    super.initState();
    _loadSavedPhoto();
  }

  Future<void> _loadSavedPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_photoKey);

    if (!mounted) return;

    setState(() {
      _savedPhotoPath = path;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_loading) return;

    if (_savedPhotoPath != null) {
      final replace = await _confirmReplacePhoto();
      if (!replace) return;
    }

    setState(() => _loading = true);

    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
      );

      if (!mounted) return;

      if (image == null) {
        AppNotification.info(context, 'No seleccionaste ninguna foto');
        return;
      }

      final saved = await context.push<bool>(
        PhotoPreviewScreen.routeName,
        extra: image.path,
      );

      if (saved == true) {
        await _loadSavedPhoto();
      }
    } catch (_) {
      if (!mounted) return;

      AppNotification.error(
        context,
        source == ImageSource.camera
            ? 'No se pudo abrir la cámara'
            : 'No se pudo abrir la galería',
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<bool> _confirmReplacePhoto() async {
    final colors = context.appColors;

    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: colors.nightCard,
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllLarge,
          ),
          title: Text(
            '¿Deseas reemplazar tu foto actual?',
            style: context.typography.titleMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Tu foto actual dejará de utilizarse para las pruebas virtuales.',
            style: context.typography.bodyMedium?.copyWith(
              color: colors.slate,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: colors.slateSoft),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(
                'Reemplazar',
                style: TextStyle(
                  color: colors.primaryLight,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    ) ??
        false;
  }

  void _goToCatalog() {
    AppNotification.info(
      context,
      'El catálogo de prendas estará disponible próximamente',
    );
  }

  Future<void> _showChangePhotoOptions() async {
    final colors = context.appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.nightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: kSpaceDeviceMd,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.nightBorder,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const Gap(separatorLg),
                Text(
                  '¿Cómo deseas actualizar tu foto?',
                  textAlign: TextAlign.center,
                  style: context.typography.titleMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorLg),
                _PhotoOptionTile(
                  icon: Icons.photo_camera_outlined,
                  title: 'Tomar una foto',
                  subtitle: 'Usar la cámara del dispositivo',
                  onTap: () {
                    context.pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                const Gap(separatorSm),
                _PhotoOptionTile(
                  icon: Icons.image_outlined,
                  title: 'Elegir desde galería',
                  subtitle: 'Seleccionar una imagen guardada',
                  onTap: () {
                    context.pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
                const Gap(separatorMd),
                TextButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: colors.slateSoft,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDeletePhoto() async {
    final colors = context.appColors;

    final delete = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: colors.nightCard,
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllLarge,
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colors.error,
              ),
              const Gap(separatorSm),
              Expanded(
                child: Text(
                  '¿Eliminar tu foto actual?',
                  style: context.typography.titleMedium?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Si eliminas tu foto, deberás agregar una nueva antes de realizar pruebas virtuales.',
            style: context.typography.bodyMedium?.copyWith(
              color: colors.slate,
              height: 1.35,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: colors.slateSoft,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(true),
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: colors.error,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (delete != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_photoKey);

    if (!mounted) return;

    setState(() {
      _savedPhotoPath = null;
    });

    AppNotification.success(
      context,
      'Foto eliminada correctamente',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasPhoto =
        _savedPhotoPath != null && File(_savedPhotoPath!).existsSync();

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
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Mi foto',
                        textAlign: TextAlign.center,
                        style: context.typography.titleMedium?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Gap(separatorLg),
                Text(
                  'Mi foto',
                  textAlign: TextAlign.center,
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Esta foto se utilizará para probarte prendas virtualmente.',
                  textAlign: TextAlign.center,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slate,
                    height: 1.35,
                  ),
                ),
                const Gap(separatorLg),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: hasPhoto ? kSpaceDeviceSm : kSpaceDeviceMd,
                    decoration: BoxDecoration(
                      color: colors.nightCard.withValues(alpha: 0.65),
                      borderRadius: kBorderRadiusAllXLarge,
                      border: Border.all(
                        color: hasPhoto
                            ? colors.success.withValues(alpha: 0.45)
                            : colors.primary.withValues(alpha: 0.45),
                        width: 1.4,
                      ),
                      boxShadow: hasPhoto ? colors.shadowZafira : null,
                    ),
                    child: hasPhoto
                        ? ClipRRect(
                      borderRadius: kBorderRadiusAllLarge,
                      child: Image.file(
                        File(_savedPhotoPath!),
                        fit: BoxFit.cover,
                      ),
                    )
                        : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          color: colors.primaryLight,
                          size: 58,
                        ),
                        const Gap(separatorMd),
                        Text(
                          'Selecciona tu foto',
                          style: context.typography.labelLarge?.copyWith(
                            color: colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Gap(separatorXSm),
                        Text(
                          'Usa una foto de cuerpo completo, buena iluminación y fondo limpio.',
                          textAlign: TextAlign.center,
                          style: context.typography.bodySmall?.copyWith(
                            color: colors.slate,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(separatorMd),
                if (hasPhoto) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: colors.success,
                        size: 18,
                      ),
                      const Gap(separatorSm),
                      Text(
                        'Foto configurada',
                        style: context.typography.bodySmall?.copyWith(
                          color: colors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Gap(separatorLg),
                  _UploadButton(
                    label: 'Seleccionar prendas',
                    icon: Icons.checkroom_rounded,
                    loading: _loading,
                    onTap: _goToCatalog,
                  ),
                  const Gap(separatorSm),
                  _UploadButton(
                    label: 'Cambiar foto',
                    icon: Icons.cached_rounded,
                    outlined: true,
                    loading: _loading,
                    onTap: _showChangePhotoOptions,
                  ),
                  const Gap(separatorSm),

                  _UploadButton(
                    label: 'Eliminar foto',
                    icon: Icons.delete_outline_rounded,
                    loading: _loading,
                    outlined: true,
                    onTap: _confirmDeletePhoto,
                  ),

                ] else ...[
                  _UploadButton(
                    label: 'Tomar foto',
                    icon: Icons.photo_camera_outlined,
                    outlined: true,
                    loading: _loading,
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  const Gap(separatorSm),
                  _UploadButton(
                    label: 'Subir desde galería',
                    icon: Icons.image_outlined,
                    loading: _loading,
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                ],
                const Gap(separatorMd),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoOptionTile extends StatelessWidget {
  const _PhotoOptionTile({
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
        width: double.infinity,
        padding: kSpaceDeviceMd,
        decoration: BoxDecoration(
          color: colors.nightInput,
          borderRadius: kBorderRadiusAllMedium,
          border: Border.all(color: colors.nightBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.16),
              ),
              child: Icon(
                icon,
                color: colors.primaryLight,
              ),
            ),
            const Gap(separatorMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.typography.bodyMedium?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Gap(separatorXSm),
                  Text(
                    subtitle,
                    style: context.typography.bodySmall?.copyWith(
                      color: colors.slate,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.loading,
    this.outlined = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final button = ElevatedButton.icon(
      onPressed: loading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        side: outlined
            ? BorderSide(color: colors.white.withValues(alpha: 0.7))
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadiusAllLarge,
        ),
      ),
      icon: loading
          ? SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: outlined ? colors.white : colors.nightDeep,
        ),
      )
          : Icon(
        icon,
        color: outlined ? colors.white : colors.nightDeep,
      ),
      label: Text(
        label,
        style: context.typography.labelLarge?.copyWith(
          color: outlined ? colors.white : colors.nightDeep,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: outlined
          ? button
          : DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.gradientPrimary,
          borderRadius: kBorderRadiusAllLarge,
        ),
        child: button,
      ),
    );
  }
}