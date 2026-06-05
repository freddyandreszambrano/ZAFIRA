import 'core/flavors/flavors_config.dart';
import 'main/common_main.dart';

/// Entry point por defecto. Usá `flutter run` directo y arranca en DEV.
///
/// Para forzar prod, correr explícitamente:
/// ```
/// flutter run -t lib/main/main_prod.dart
/// ```
void main() async {
  Flavor.setEnvironment(Environment.dev);
  await commonMain();
}
