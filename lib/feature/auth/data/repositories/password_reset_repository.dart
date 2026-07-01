import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/password_reset_confirm.dart';
import '../interfaces/password_reset_interface.dart';
import '../services/password_reset_service.dart';

final passwordResetRepositoryProvider = Provider<IPasswordReset>((ref) {
  return PasswordResetRepository(ref.watch(passwordResetServiceProvider));
});

class PasswordResetRepository implements IPasswordReset {
  PasswordResetRepository(this._remoteDataSource);

  final PasswordResetService _remoteDataSource;

  @override
  Future<void> requestCode(String email) =>
      _remoteDataSource.requestCode(email);

  @override
  Future<void> confirmReset(PasswordResetConfirm data) =>
      _remoteDataSource.confirmReset(data);
}
