import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/helpers/context_helper.dart';

/// Bloqueo cuando la prenda elegida no coincide con el género de la foto del
/// usuario (ej. prenda de mujer con foto de hombre): informa y no permite
/// continuar — el probador solo acepta prendas del género del usuario.
class GenderMismatchDialog extends StatelessWidget {
  const GenderMismatchDialog({
    required this.garmentLabel,
    required this.photoLabel,
    super.key,
  });

  final String garmentLabel;
  final String photoLabel;

  static Future<void> show(
    BuildContext context, {
    required String garmentGender,
    required String photoGender,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => GenderMismatchDialog(
        garmentLabel: garmentGender == 'woman' ? 'mujer' : 'hombre',
        photoLabel: photoGender == 'woman' ? 'mujer' : 'hombre',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Dialog(
      backgroundColor: colors.nightCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checkroom_rounded,
                size: 36,
                color: colors.primary,
              ),
            ),
            const Gap(16),
            Text(
              'Esta prenda no coincide con tu foto',
              textAlign: TextAlign.center,
              style: context.typography.titleMedium?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(10),
            Text(
              'Estás eligiendo una prenda de $garmentLabel y tu foto es de '
              '$photoLabel. El resultado del probador puede no verse natural.',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.slate,
                height: 1.5,
              ),
            ),
            const Gap(20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Elegir otra prenda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
