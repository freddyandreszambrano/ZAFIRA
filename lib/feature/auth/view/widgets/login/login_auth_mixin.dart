import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enum/response_status.dart';
import '../../../../../modules/common/request/permission_handler.dart';
import '../../../../home/view/main/home_screen.dart';
import '../../controller/auth_controller.dart';
import '../../state/auth_state.dart';

mixin LoginAuthMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  bool _requesting = false;

  void initAuthServices() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(authControllerProvider.notifier).bootstrap(isWeb: kIsWeb);
    });
  }

  void authListener() {
    ref.listen<AuthState>(authControllerProvider, (previous, next) async {
      if (next.status == ResponseStatus.success && next.isTokenExist == true) {
        if (kIsWeb) {
          if (mounted) context.go(HomeScreen.routeName);
          return;
        }

        if (_requesting) return;
        _requesting = true;

        try {
          await requestMultiplePermission(context);

          // TODO: descomentar cuando se quieran solicitar los permisos uno por uno
          // if (!mounted) return;
          // final hasCameraPermission = await requestPermissionCamera(context);
          // if (!mounted) return;
          // final hasLocationPermission =
          //     hasCameraPermission && await requestPermissionLocation(context);
          // if (!mounted) return;
          // final hasNotificationPermission = hasLocationPermission &&
          //     await requestPermissionNotification(context);
          // if (!mounted) return;
          // if (hasNotificationPermission) {
          //   context.go(HomeScreen.routeName);
          // }

          if (mounted) context.go(HomeScreen.routeName);
        } finally {
          _requesting = false;
        }
      } else if ([
            ResponseStatus.error,
            ResponseStatus.success,
          ].contains(next.status) &&
          next.isTokenExist == false) {
      }
    });
  }
}
