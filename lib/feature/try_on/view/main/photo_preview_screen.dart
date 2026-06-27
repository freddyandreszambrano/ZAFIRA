import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';

class PhotoPreviewScreen extends StatelessWidget {
  const PhotoPreviewScreen({required this.imagePath, super.key});

  static const routeName = '/photo-preview';

  final String imagePath;

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
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Zafira',
                        textAlign: TextAlign.center,
                        style: context.typography.titleLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(Icons.notifications_none_rounded, color: colors.white),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: kSpaceDeviceHLg,
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: kSpaceDeviceSm,
                          decoration: BoxDecoration(
                            borderRadius: kBorderRadiusAllXLarge,
                            border: Border.all(
                              color: colors.primary.withValues(
                                alpha: kOpacityBorder,
                              ),
                              width: kBorderWidthLg,
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
                      Row(
                        children: const [
                          _ActionButton(icon: Icons.open_with, label: 'Mover'),
                          _ActionButton(
                            icon: Icons.zoom_out_map,
                            label: 'Escalar',
                          ),
                          _ActionButton(
                            icon: Icons.rotate_right,
                            label: 'Rotar',
                          ),
                          _ActionButton(
                            icon: Icons.auto_awesome,
                            label: 'IA Fit',
                          ),
                        ],
                      ),
                      const Gap(separatorMd),
                      SizedBox(
                        width: double.infinity,
                        height: kButtonHeight,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: colors.gradientPrimary,
                            borderRadius: kBorderRadiusAllLarge,
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => AppNotification.info(
                              context,
                              'Generación de outfit disponible próximamente',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: kBorderRadiusAllLarge,
                              ),
                            ),
                            icon: Icon(
                              Icons.auto_fix_high,
                              color: colors.white,
                            ),
                            label: Text(
                              'Generar outfit',
                              style: context.typography.labelLarge?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w700,
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: colors.white, size: kIconMd),
          const Gap(separatorXSm),
          Text(
            label,
            style: context.typography.labelSmall?.copyWith(color: colors.slate),
          ),
        ],
      ),
    );
  }
}
