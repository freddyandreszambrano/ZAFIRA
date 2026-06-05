import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'DEVELOP_ENV')
  static const String developEnv = _Env.developEnv;

  @EnviedField(varName: 'PRODUCTION_ENV')
  static const String productionEnv = _Env.productionEnv;
}
