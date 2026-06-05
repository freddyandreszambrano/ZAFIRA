import '../core/flavors/flavors_config.dart';
import 'common_main.dart';

void main() async {
  Flavor.setEnvironment(Environment.dev);
  await commonMain();
}
