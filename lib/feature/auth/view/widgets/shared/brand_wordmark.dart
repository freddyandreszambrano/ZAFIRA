import 'package:flutter/material.dart';

import '../../../../../core/helpers/context_helper.dart';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({this.style, super.key});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ShaderMask(
      shaderCallback: (bounds) => colors.gradientPrimary.createShader(bounds),
      child: Text(
        'Zafira',
        style: (style ?? context.typography.displayLarge)?.copyWith(
          color: colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
