import '../core/flavors/flavors_config.dart';
import 'common_main.dart';

/// Entry point del flavor PROD.
///
/// Correr con:
/// ```
/// flutter run -t lib/main/main_prod.dart
/// flutter build apk -t lib/main/main_prod.dart --release
/// ```
void main() async {
  Flavor.setEnvironment(Environment.prod);
  await commonMain();
}
