import '../../domain/register_request.dart';

abstract class IRegister {
  Future<void> createUser(RegisterRequest request);

  Future<Map<String, dynamic>> validateField({
    required String field,
    required String value,
  });
}