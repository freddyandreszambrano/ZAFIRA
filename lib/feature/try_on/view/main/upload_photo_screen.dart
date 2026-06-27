import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../data/services/image_picker_service.dart';
import 'photo_preview_screen.dart';

class UploadPhotoScreen extends ConsumerStatefulWidget {
  const UploadPhotoScreen({super.key});

  static const routeName = '/upload-photo';

  @override
  ConsumerState<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends ConsumerState<UploadPhotoScreen> {
  bool _loading = false;

  Future<void> _pickImage(PhotoSource source) async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final path = await ref.read(imagePickerServiceProvider).pick(source);

      if (!mounted) return;

      if (path == null) {
        AppNotification.info(context, 'No seleccionaste ninguna foto');
        return;
      }

      context.push(PhotoPreviewScreen.routeName, extra: path);
    } catch (_) {
      if (!mounted) return;

      AppNotification.error(
        context,
        source == PhotoSource.camera
            ? 'No se pudo abrir la cámara'
            : 'No se pudo abrir la galería',
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
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
          child: Padding(
            padding: kSpaceDeviceHLg,
            child: Column(
              children: [
                const _UploadHeader(),
                const Gap(separatorLg),
                Text(
                  'Tu avatar digital',
                  textAlign: TextAlign.center,
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(separatorXSm),
                Text(
                  'Sube una foto de cuerpo completo para crear tu doble digital y probar prendas.',
                  textAlign: TextAlign.center,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorLg),
                const Expanded(child: _AvatarPlaceholder()),
                const Gap(separatorLg),
                _UploadButton(
                  label: 'Tomar foto',
                  icon: Icons.photo_camera_outlined,
                  outlined: true,
                  loading: _loading,
                  onTap: () => _pickImage(PhotoSource.camera),
                ),
                const Gap(separatorSm),
                _UploadButton(
                  label: 'Subir desde galería',
                  icon: Icons.image_outlined,
                  loading: _loading,
                  onTap: () => _pickImage(PhotoSource.gallery),
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

class _UploadHeader extends StatelessWidget {
  const _UploadHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: colors.white),
        ),
        Expanded(
          child: Text(
            'Subir foto',
            textAlign: TextAlign.center,
            style: context.typography.titleMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: kIconButtonSize),
      ],
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.nightCard.withValues(alpha: kOpacityCard),
        borderRadius: kBorderRadiusAllXLarge,
        border: Border.all(
          color: colors.primary.withValues(alpha: kOpacityBorder),
          width: kBorderWidthMd,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_rounded,
            color: colors.primaryLight,
            size: kIconXl,
          ),
          const Gap(separatorMd),
          Text(
            'Selecciona tu foto',
            style: context.typography.labelLarge?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(separatorXSm),
          Text(
            'Usa buena iluminación y fondo limpio',
            style: context.typography.bodySmall?.copyWith(color: colors.slate),
          ),
        ],
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
            ? BorderSide(color: colors.white.withValues(alpha: kOpacityStrong))
            : null,
        shape: const RoundedRectangleBorder(
          borderRadius: kBorderRadiusAllLarge,
        ),
      ),
      icon: loading
          ? SizedBox(
              width: kLoaderSize,
              height: kLoaderSize,
              child: CircularProgressIndicator(
                strokeWidth: kLoaderStroke,
                color: outlined ? colors.white : colors.nightDeep,
              ),
            )
          : Icon(icon, color: outlined ? colors.white : colors.nightDeep),
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
      height: kButtonHeight,
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
