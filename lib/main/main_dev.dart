import '../core/flavors/flavors_config.dart';
import 'common_main.dart';

/// Entry point del flavor DEV.
///
/// Correr con:
/// ```
/// flutter run -t lib/main/main_dev.dart
/// ```
void main() async {
  Flavor.setEnvironment(Environment.dev);
  await commonMain();
}
