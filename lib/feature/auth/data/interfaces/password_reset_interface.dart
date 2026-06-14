import '../../domain/password_reset_confirm.dart';

abstract class IPasswordReset {
  Future<void> requestCode(String email);

  Future<void> confirmReset(PasswordResetConfirm data);
}
