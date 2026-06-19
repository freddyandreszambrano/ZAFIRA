import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    if (_loading) return;

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

      context.push(PhotoPreviewScreen.routeName, extra: image.path);
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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Upload Photo',
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
                  'Your Digital Avatar',
                  textAlign: TextAlign.center,
                  style: context.typography.headlineSmall?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(separatorXSm),

                Text(
                  'Upload a full-body photo to create your precise digital double for virtual try-on.',
                  textAlign: TextAlign.center,
                  style: context.typography.bodySmall?.copyWith(
                    color: colors.slate,
                  ),
                ),
                const Gap(separatorLg),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colors.nightCard.withValues(alpha: 0.65),
                      borderRadius: kBorderRadiusAllXLarge,
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.45),
                        width: 1.4,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_rounded,
                          color: colors.primaryLight,
                          size: 56,
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
                          style: context.typography.bodySmall?.copyWith(
                            color: colors.slate,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(separatorLg),

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
                const Gap(separatorMd),
              ],
            ),
          ),
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