import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';
import '../../../../../modules/common/widget/notifications/app_notification.dart';
import 'login_footer.dart';
import 'login_form.dart';
import 'login_header.dart';
import 'login_social_section.dart';

/// Cuerpo del login: tarjeta de marca (oscura) que agrupa encabezado,
/// formulario y proveedores externos, con el pie de "Crear cuenta" debajo.
class LoginBody extends StatelessWidget {
  const LoginBody({super.key});

  void _comingSoon(BuildContext context) =>
      AppNotification.info(context, 'Función disponible próximamente');

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Marca + bienvenida: van ENCIMA del card, sobre el fondo.
        const LoginHeader(),
        const Gap(separatorXLg),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: separatorLg,
            vertical: separatorXLg,
          ),
          decoration: BoxDecoration(
            color: colors.nightCard.withValues(alpha: 0.6),
            borderRadius: kBorderRadiusAllXXLarge,
            border: Border.all(
              color: colors.nightBorder.withValues(alpha: 0.6),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.scrim.withValues(alpha: 0.35),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const LoginForm(),
              const Gap(separatorLg),
              LoginSocialSection(
                onGoogle: () => _comingSoon(context),
                onApple: () => _comingSoon(context),
              ),
            ],
          ),
        ),
        const Gap(separatorLg),
        LoginFooter(onCreateAccount: () => _comingSoon(context)),
      ],
    );
  }
}
