import 'package:flutter/material.dart';

import '../../../../../core/helpers/context_helper.dart';

class ObscureToggleButton extends StatelessWidget {
  const ObscureToggleButton({
    required this.obscured,
    required this.onPressed,
    super.key,
  });

  final bool obscured;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: context.appColors.slate,
        size: 20,
      ),
    );
  }
}
