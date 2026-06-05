import 'package:flutter/foundation.dart';

/// Entornos disponibles para builds de la app.
///
/// Cada entry point (`main_dev.dart`, `main_prod.dart`) llama
/// `Flavor.setEnvironment(...)` antes de `runApp`. A partir de ahí, cualquier
/// punto de la app puede leer `Flavor.server`, `Flavor.env`, etc.
enum Environment { dev, prod }

extension EnvironmentX on Environment {
  /// Etiqueta legible (se muestra en banners y debug screens).
  String get value {
    switch (this) {
      case Environment.dev:
        return 'Desarrollo';
      case Environment.prod:
        return 'Producción';
    }
  }

  /// Sufijo para titles, app names, etc.
  String get suffix {
    switch (this) {
      case Environment.dev:
        return ' DEV';
      case Environment.prod:
        return '';
    }
  }
}

/// Configuración del flavor activo.
///
/// Los valores se inicializan en `setEnvironment(...)` al arrancar la app.
/// Las URLs y API keys vienen de variables `--dart-define` cuando se proveen;
/// si no, caen a los defaults declarados aquí.
///
/// Para overridear desde la CLI:
/// ```
/// flutter run -t lib/main/main_dev.dart \
///   --dart-define=API_DEV=https://api-dev.zafira.com \
///   --dart-define=GOOGLE_MAPS_KEY_DEV=AIza...
/// ```
class Flavor {
  Flavor._();

  static String? _baseUrl;
  static Environment? _env;
  static String? projectVersion;
  static String? _googleApiKey;
  static String? _hereMapApiKey;
  static String? _hereAppId;
  static String? _webAppUrl;

  // ── Defaults por entorno (sobre-escribibles vía --dart-define) ────────
  // Ajustá estos valores cuando tengas tus endpoints reales.
  static const _apiDev = String.fromEnvironment(
    'API_DEV',
    defaultValue: 'https://api-dev.zafira.com',
  );
  static const _apiProd = String.fromEnvironment(
    'API_PROD',
    defaultValue: 'https://api.zafira.com',
  );

  static const _webAppDev = String.fromEnvironment(
    'WEB_APP_DEV',
    defaultValue: 'https://app-dev.zafira.com',
  );
  static const _webAppProd = String.fromEnvironment(
    'WEB_APP_PROD',
    defaultValue: 'https://app.zafira.com',
  );

  static const _hereAppIdDev = String.fromEnvironment('HERE_APP_ID_DEV');
  static const _hereAppIdProd = String.fromEnvironment('HERE_APP_ID_PROD');
  static const _hereMapKeyDev = String.fromEnvironment('HERE_MAP_KEY_DEV');
  static const _hereMapKeyProd = String.fromEnvironment('HERE_MAP_KEY_PROD');

  static const _googleAndroidDev =
      String.fromEnvironment('GOOGLE_MAPS_ANDROID_DEV');
  static const _googleAndroidProd =
      String.fromEnvironment('GOOGLE_MAPS_ANDROID_PROD');
  static const _googleIosDev = String.fromEnvironment('GOOGLE_MAPS_IOS_DEV');
  static const _googleIosProd = String.fromEnvironment('GOOGLE_MAPS_IOS_PROD');
  static const _googleWebDev = String.fromEnvironment('GOOGLE_MAPS_WEB_DEV');
  static const _googleWebProd = String.fromEnvironment('GOOGLE_MAPS_WEB_PROD');

  /// Activa un environment. Llamar UNA vez antes de `runApp`.
  static void setEnvironment(Environment env) {
    _env = env;
    switch (env) {
      case Environment.dev:
        _baseUrl = _apiDev;
        _hereAppId = _hereAppIdDev;
        _hereMapApiKey = _hereMapKeyDev;
        _webAppUrl = _webAppDev;
        _googleApiKey = _pickGoogleKey(
          web: _googleWebDev,
          android: _googleAndroidDev,
          ios: _googleIosDev,
        );
        break;
      case Environment.prod:
        _baseUrl = _apiProd;
        _hereAppId = _hereAppIdProd;
        _hereMapApiKey = _hereMapKeyProd;
        _webAppUrl = _webAppProd;
        _googleApiKey = _pickGoogleKey(
          web: _googleWebProd,
          android: _googleAndroidProd,
          ios: _googleIosProd,
        );
        break;
    }
  }

  static String _pickGoogleKey({
    required String web,
    required String android,
    required String ios,
  }) {
    if (kIsWeb) return web;
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    return ios;
  }

  // ── Getters públicos ──────────────────────────────────────────────────
  static String getByImageServer(String name) => '$server$name';

  static String? get server => _baseUrl;

  static Environment? get env => _env;

  static String? get envValue => _env?.value;

  static bool get isDev => _env == Environment.dev;

  static bool get isProd => _env == Environment.prod;

  static String get projectVersionValue => projectVersion ?? '';

  static String get hereAppId => _hereAppId ?? '';

  static String get hereMapApiKey => _hereMapApiKey ?? '';

  static String get googleMapApiKey => _googleApiKey ?? '';

  static String get webAppUrl => _webAppUrl ?? '';

  static String? get ipAddress {
    final url = _baseUrl;
    if (url == null || !url.contains('//')) return null;
    return url.split('//')[1].split(':').first.split('/').first;
  }
}
