import 'package:flutter/material.dart';

import '../../../../../core/constants/app_numbers.dart';
import '../../../../../core/helpers/context_helper.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: kSpaceDeviceLg,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: tabletSize),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
