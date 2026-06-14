import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

/// Sección de proveedores externos: separador "O continuar con" + botones.
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _OrDivider(),
        const Gap(separatorLg),
        _SocialButton(
          icon: const _GoogleLogo(),
          label: 'Continuar con Google',
          onTap: onGoogle,
        ),
        const Gap(separatorMd),
        _SocialButton(
          icon: Icon(Icons.apple, color: context.appColors.white, size: 22),
          label: 'Continuar con Apple',
          onTap: onApple,
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final lineColor = colors.nightBorder.withValues(alpha: 0.6);

    return Row(
      children: [
        Expanded(child: Divider(color: lineColor, thickness: 1)),
        Padding(
          padding: kSpaceDeviceHMd,
          child: Text(
            'O continuar con',
            style: context.typography.bodyMedium?.copyWith(color: colors.slate),
          ),
        ),
        Expanded(child: Divider(color: lineColor, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.nightInput.withValues(alpha: 0.45),
      borderRadius: kBorderRadiusAllMedium,
      child: InkWell(
        onTap: onTap,
        borderRadius: kBorderRadiusAllMedium,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: separatorMd),
          decoration: BoxDecoration(
            borderRadius: kBorderRadiusAllMedium,
            border: Border.all(color: colors.nightBorder.withValues(alpha: 0.6)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 22, height: 22, child: Center(child: icon)),
              const Gap(separatorSm),
              Text(
                label,
                style: context.typography.bodyLarge?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Logo oficial de Google (asset de marca embebido como SVG).
///
/// Excepción justificada a la regla "cero hex": son los colores de marca de un
/// tercero, no tokens del design system de ZAFIRA.
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(_googleSvg, width: 20, height: 20);
  }
}

const String _googleSvg = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 48 48">
<path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"/>
<path fill="#FF3D00" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"/>
<path fill="#4CAF50" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"/>
<path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.862,21.35,43.611,20.083z"/>
</svg>
''';
