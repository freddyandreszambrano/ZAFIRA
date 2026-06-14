import 'package:flutter/material.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

/// CTA primario de marca: gradiente magenta → violeta + sombra ZAFIRA.
///
/// Patrón del DESIGN_SYSTEM (§4). Maneja el estado de carga con un spinner
/// inline y deshabilita el tap mientras carga.
class AuthGradientButton extends StatelessWidget {
  const AuthGradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Opacity(
      opacity: isLoading ? 0.7 : 1,
      child: Container(
        decoration: BoxDecoration(
          gradient: colors.gradientPrimary,
          borderRadius: kBorderRadiusAllMedium,
          boxShadow: colors.shadowZafira,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: kBorderRadiusAllMedium,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: separatorMd),
              child: Center(
                child: isLoading
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(colors.white),
                        ),
                      )
                    : Text(
                        label,
                        style: context.typography.labelLarge?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
