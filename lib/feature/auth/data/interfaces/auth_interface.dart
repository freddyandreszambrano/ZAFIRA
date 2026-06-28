import '../../domain/auth_token_model.dart';

abstract class IAuth {
  Future<AuthTokenModel> getToken(String username, String password);

  Future<AuthTokenModel> getCurrentUser();

  Future<AuthTokenModel> updateProfile(Map<String, dynamic> data);

  Future<AuthTokenModel> updateAvatar(String filePath);

  Future<AuthTokenModel> deleteAvatar();

  Future<AuthTokenModel> updateTryOnPhoto(String filePath);

  Future<AuthTokenModel> deleteTryOnPhoto();

  Future<void> saveToken(String token);

  Future<bool> checkToken();

  Future<void> removeToken();

  void showServerUrl();
}
