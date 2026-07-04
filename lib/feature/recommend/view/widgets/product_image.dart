import 'package:flutter/material.dart';

import '../../../../core/helpers/app_colors.dart';
import '../../../../core/helpers/context_helper.dart';

/// Imagen de producto con fallback: si una URL falla, intenta la siguiente.
class ProductImage extends StatefulWidget {
  const ProductImage({required this.urls, super.key});

  final List<String> urls;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  int _urlIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.urls.isEmpty || _urlIndex >= widget.urls.length) {
      return _placeholder(colors);
    }

    return Image.network(
      widget.urls[_urlIndex],
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      headers: const {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/120 Safari/537.36',
      },
      errorBuilder: (_, _, _) {
        // Intentar la siguiente URL en el próximo frame
        if (_urlIndex < widget.urls.length - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _urlIndex++);
          });
        }
        return _placeholder(colors);
      },
    );
  }

  Widget _placeholder(AppColors colors) => Container(
    width: double.infinity,
    height: 160,
    decoration: BoxDecoration(
      color: colors.nightInput,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(Icons.checkroom_rounded, color: colors.slate),
  );
}
