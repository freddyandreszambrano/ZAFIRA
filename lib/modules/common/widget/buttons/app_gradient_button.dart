import 'package:flutter/material.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Opacity(
      opacity: !enabled ? 0.45 : (isLoading ? 0.7 : 1),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colors.white,
                          ),
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
