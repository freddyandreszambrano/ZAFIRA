import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/user_model.dart';
import '../controller/auth_controller.dart';

/// Estado de sesión que puede consumir una feature sin conocer el controlador
/// de autenticación ni invocar acciones sobre él.
final currentSessionUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authControllerProvider.select((state) => state.user));
});
