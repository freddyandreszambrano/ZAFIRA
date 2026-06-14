import '../../domain/register_request.dart';

abstract class IRegister {
  Future<void> createUser(RegisterRequest request);
}
