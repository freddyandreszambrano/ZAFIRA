import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/register_request.dart';
import '../interfaces/register_interface.dart';
import '../services/register_service.dart';

final registerRepositoryProvider = Provider<IRegister>((ref) {
  return RegisterRepository(ref.watch(registerServiceProvider));
});

class RegisterRepository implements IRegister {
  RegisterRepository(this._remoteDataSource);

  final RegisterService _remoteDataSource;

  @override
  Future<void> createUser(RegisterRequest request) =>
      _remoteDataSource.createUser(request);
}
