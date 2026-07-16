import 'package:flutter/material.dart';

import '../../../../core/helpers/context_helper.dart';

/// Avatar redondo que muestra la CARA de una foto de cuerpo completo.
///
/// La foto del probador es de pie (cabeza arriba); al alinear la imagen hacia
/// la parte superior, el círculo enseña el rostro en vez del torso, como una
/// foto de perfil normal — sin que el usuario recorte ni posicione nada.
class FaceAvatar extends StatelessWidget {
  const FaceAvatar({
    required this.imageUrl,
    required this.radius,
    this.fallback,
    super.key,
  });

  final String imageUrl;
  final double radius;
  final Widget? fallback;

  // Hacia arriba: centra el encuadre en la cara (no en el torso)
  static const _faceAlignment = Alignment(0, -0.7);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: colors.primary.withValues(alpha: 0.25),
        child: fallback,
      );
    }

    return ClipOval(
      child: SizedBox(
        width: radius * 2,
        height: radius * 2,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          alignment: _faceAlignment,
          errorBuilder: (_, _, _) => CircleAvatar(
            radius: radius,
            backgroundColor: colors.primary.withValues(alpha: 0.25),
            child: fallback,
          ),
        ),
      ),
    );
  }
}
