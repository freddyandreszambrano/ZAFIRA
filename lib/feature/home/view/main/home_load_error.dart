import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class HomeLoadError extends StatelessWidget {
  const HomeLoadError({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: kSpaceDeviceMd,
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, color: colors.warning, size: 36),
            const Gap(separatorSm),
            Text(
              message ?? 'No se pudieron cargar las prendas.',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slateSoft,
              ),
            ),
            const Gap(separatorSm),
            TextButton(onPressed: onRetry, child: const Text('Reintentar')),
          ],
        ),
      ),
    );
  }
}
