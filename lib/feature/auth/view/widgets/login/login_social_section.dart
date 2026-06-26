import 'package:flutter/material.dart';

/// Sección social deshabilitada temporalmente.
/// Se mantiene el widget para evitar errores en LoginScreen.
class LoginSocialSection extends StatelessWidget {
  const LoginSocialSection({
    required this.onGoogle,
    required this.onApple,
    super.key,
  });

  final VoidCallback onGoogle;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}