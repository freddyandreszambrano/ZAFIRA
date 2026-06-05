import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../core/flavors/flavors_config.dart';
import '../core/helpers/app_colors.dart';
import '../core/helpers/context_helper.dart';

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

  runApp(const ZafiraApp());
}

class ZafiraApp extends StatelessWidget {
  const ZafiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zafira${Flavor.env?.suffix ?? ''}',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const AppColorScheme(),
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: (context, child) {
        if (!Flavor.isProd && !kReleaseMode) {
          return Banner(
            location: BannerLocation.topEnd,
            message: Flavor.env?.value ?? 'DEV',
            color: context.appColors.primary,
            child: child ?? const SizedBox.shrink(),
          );
        }
        return child ?? const SizedBox.shrink();
      },
      home: const _FlavorHomeScreen(),
    );
  }
}

class _FlavorHomeScreen extends StatelessWidget {
  const _FlavorHomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                gradient: context.appColors.gradientPrimary,
                borderRadius: BorderRadius.circular(20),
                boxShadow: context.appColors.shadowZafira,
              ),
              child: const Text(
                'ZAFIRA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Flavor: ${Flavor.envValue ?? "(sin set)"}',
              style: context.typography.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'API: ${Flavor.server ?? "(sin configurar)"}',
              style: context.typography.bodyMuted,
            ),
            const SizedBox(height: 8),
            Text(
              'v${Flavor.projectVersionValue}',
              style: context.typography.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
