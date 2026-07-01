import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/http/dio_http_client.dart';
import '../../domain/auth_token_model.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final remoteDataSource = ref.watch(dioHttpClientProvider);
  return AuthService(remoteDataSource: remoteDataSource);
});

class AuthService {
  AuthService({required this.remoteDataSource});

  final DioHttpClient remoteDataSource;

  Future<AuthTokenModel> getToken(String username, String password) async {
    const url = "/api/v1/auth/token/";
    final body = {"username": username, "password": password};
    DebugLogger(runtimeType).request(url, body);
    final response = await remoteDataSource().post(url, data: body);
    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);
    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> getCurrentUser() async {
    const url = "/api/v1/auth/profile/me/";

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().get(url);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> updateProfile(Map<String, dynamic> data) async {
    const url = "/api/v1/auth/profile/update/";

    DebugLogger(runtimeType).request(url, data);

    final response = await remoteDataSource().patch(url, data: data);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> updateAvatar(String filePath) async {
    const url = "/api/v1/auth/profile/avatar/";

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });

    DebugLogger(runtimeType).request(url, {'image': filePath});

    final response = await remoteDataSource().patch(url, data: formData);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> deleteAvatar() async {
    const url = "/api/v1/auth/profile/avatar/";

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().delete(url);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> updateTryOnPhoto(String filePath) async {
    const url = "/api/v1/auth/profile/try-on-photo/";

    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });

    DebugLogger(runtimeType).request(url, {'image': filePath});

    final response = await remoteDataSource().patch(url, data: formData);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  Future<AuthTokenModel> deleteTryOnPhoto() async {
    const url = "/api/v1/auth/profile/try-on-photo/";

    DebugLogger(runtimeType).request(url);

    final response = await remoteDataSource().delete(url);

    DebugLogger(
      runtimeType,
    ).response(url, [response.statusCode, response.data]);

    return AuthTokenModel.fromJson(response.data);
  }

  void showServerUrl() {
    InformationLogger(
      runtimeType,
    ).regular("server_url: ${remoteDataSource().options.baseUrl}");
  }
}
