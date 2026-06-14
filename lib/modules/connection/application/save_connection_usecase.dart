import '../data/interfaces/connection_interface.dart';

class SaveConnectionUseCase {
  SaveConnectionUseCase(this.interface);

  final IConnection interface;

  Future<void> call(bool? status) async =>
      interface.saveConnectionStatusData(status ?? false);
}
