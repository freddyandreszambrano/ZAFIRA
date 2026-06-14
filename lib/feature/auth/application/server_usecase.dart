import '../data/interfaces/auth_interface.dart';

class ServerUseCase {
  ServerUseCase(this.interface);

  final IAuth interface;

  void call() => interface.showServerUrl();
}
