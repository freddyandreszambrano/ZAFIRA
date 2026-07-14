import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/context_helper.dart';

/// Imagen de red con caché en disco: la primera visita descarga, las
/// siguientes cargan al instante. Clave para que el catálogo y favoritos
/// se sientan rápidos (las tiendas sirven imágenes pesadas).
class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    required this.url,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
    this.fallbackIcon = Icons.checkroom_rounded,
    this.fallbackIconSize = 54,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final IconData fallbackIcon;
  final double fallbackIconSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 150),
      placeholder: (context, url) => Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: colors.primaryLight,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          fallbackIcon,
          color: colors.primaryLight,
          size: fallbackIconSize,
        ),
      ),
    );
  }
}
