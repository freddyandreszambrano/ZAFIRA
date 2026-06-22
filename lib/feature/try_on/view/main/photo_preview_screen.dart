import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({
    required this.imagePath,
    super.key,
  });

  static const routeName = '/photo-preview';
  static const _photoKey = 'try_on_user_photo_path';

  final String imagePath;

  Future<void> _savePhoto(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_photoKey, imagePath);

    if (!context.mounted) return;

    AppNotification.success(
      context,
      'Foto guardada correctamente',
    );

    context.pop(true);
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
          child: Column(
            children: [
              Padding(
                padding: kSpaceDeviceHMd,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(false),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Vista previa',
                        textAlign: TextAlign.center,
                        style: context.typography.titleLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: kSpaceDeviceHLg,
                  child: Column(
                    children: [
                      Text(
                        'Tu foto está lista',
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
                          padding: kSpaceDeviceSm,
                          decoration: BoxDecoration(
                            borderRadius: kBorderRadiusAllXLarge,
                            border: Border.all(
                              color: colors.primary.withValues(alpha: 0.45),
                              width: 1.5,
                            ),
                            boxShadow: colors.shadowZafira,
                            color: colors.nightCard,
                          ),
                          child: ClipRRect(
                            borderRadius: kBorderRadiusAllLarge,
                            child: Image.file(
                              File(imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                            Icon(
                              Icons.tips_and_updates_outlined,
                              color: colors.primaryLight,
                              size: 22,
                            ),
                            const Gap(separatorMd),
                            Expanded(
                              child: Text(
                                'Para mejores resultados, usa una foto de cuerpo completo con buena iluminación.',
                                style: context.typography.bodySmall?.copyWith(
                                  color: colors.slateSoft,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(separatorMd),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: colors.gradientPrimary,
                            borderRadius: kBorderRadiusAllLarge,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _savePhoto(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: kBorderRadiusAllLarge,
                              ),
                            ),
                            icon: Icon(
                              Icons.save_alt_rounded,
                              color: colors.white,
                            ),
                            label: Text(
                              'Guardar foto',
                              style: context.typography.labelLarge?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w800,
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
            ],
          ),
        ),
      ),
    );
  }
}