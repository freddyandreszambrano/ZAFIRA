import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/sql/helper/sql_helper.dart';
import '../../../../core/utils/logger.dart';
import '../../../../modules/common/drivers/storage/local_storage.dart';
import '../../../../modules/common/drivers/storage/local_storage_impl.dart';
import '../../domain/auth_token_model.dart';
import '../interfaces/auth_interface.dart';
import '../services/auth_service.dart';

final authRepositoryProvider = Provider<IAuth>((ref) {
  final remoteDataSource = ref.watch(authServiceProvider);
  final localDataSource = ref.watch(secureLocalDataSourceProvider);
  final sqlHelper = ref.watch(sqlHelperProvider);
  return AuthRepository(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
    sqlHelper: sqlHelper,
  );
});

class AuthRepository implements IAuth {
  AuthRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.sqlHelper,
  });

  final AuthService remoteDataSource;
  final LocalStorage localDataSource;
  final SQLHelper sqlHelper;

  @override
  Future<bool> checkToken() async {
    DebugLogger(runtimeType).methodInit("checkToken");
    final hasToken = await localDataSource.containsItem(AppStrings.keyTokenJwt);
    final isAuth = hasToken;
    if (isAuth) {
      await sqlHelper.initDB();
    }
    DebugLogger(runtimeType).regular("isAuth: $isAuth", "checkToken");
    return isAuth;
  }

  @override
  Future<AuthTokenModel> getToken(String username, String password) async =>
      await remoteDataSource.getToken(username, password);

  @override
  Future<AuthTokenModel> updateProfile(Map<String, dynamic> data) async =>
      await remoteDataSource.updateProfile(data);

  @override
  Future<void> saveToken(String token) async {
    DebugLogger(runtimeType).methodInit("saveToken");
    await sqlHelper.initDB();
    return await localDataSource.setItem(
      AppStrings.keyTokenJwt,
      'Token $token',
    );
  }

  @override
  Future<void> removeToken() async {
    DebugLogger(runtimeType).methodInit("removeToken");
    await sqlHelper.deleteDB();
    await localDataSource.removeItem(AppStrings.keyTokenJwt);
  }

  @override
  void showServerUrl() => remoteDataSource.showServerUrl();
}
