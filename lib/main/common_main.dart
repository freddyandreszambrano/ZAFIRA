import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/flavors/flavors_config.dart';
import '../core/helpers/app_colors.dart';
import '../modules/common/routes/app_router.dart';

Future<void> commonMain() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final packageInfo = await PackageInfo.fromPlatform();
  Flavor.projectVersion = packageInfo.version;

  runApp(const ProviderScope(child: ZafiraApp()));
}

class ZafiraApp extends StatelessWidget {
  const ZafiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    const colorScheme = AppColorScheme();

    return MaterialApp.router(
      title: 'Zafira${Flavor.env?.suffix ?? ''}',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
