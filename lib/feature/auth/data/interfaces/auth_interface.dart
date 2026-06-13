import '../../domain/auth_token_model.dart';

abstract class IAuth {
  Future<AuthTokenModel> getToken(String username, String password);

  Future<void> saveToken(String token);

  Future<bool> checkToken();

  Future<void> removeToken();

  void showServerUrl();
}
