import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/logger.dart';
import '../../../common/drivers/storage/local_storage.dart';
import '../../../common/drivers/storage/local_storage_impl.dart';
import '../../../common/exceptions/regular_exception.dart';
import '../interfaces/connection_interface.dart';

final connectionNetworkRepositoryProvider = Provider<IConnection>((ref) {
  return ConnectionNetworkRepository(
    localDataSource: ref.watch(secureLocalDataSourceProvider),
  );
});

class ConnectionNetworkRepository implements IConnection {
  ConnectionNetworkRepository({required this.localDataSource});

  final LocalStorage localDataSource;

  @override
  Future<void> saveConnectionStatusData(bool status) async {
    try {
      DebugLogger(runtimeType).methodInit('saveConnectionStatusData');
      await localDataSource.setItem(
        AppStrings.keyServerConnection,
        status.toString(),
      );
      DebugLogger(runtimeType)
          .toLocalStorage('saveConnectionStatusData', 'Connection: $status');
    } catch (err) {
      ErrorLogger(runtimeType).regular(err, 'saveConnectionStatusData');
      throw RegularException(message: err);
    }
  }
}
