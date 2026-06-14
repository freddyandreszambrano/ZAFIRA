import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../core/enum/connection_status.dart';
import '../../../../core/flavors/flavors_config.dart';
import '../../../../core/utils/logger.dart';
import '../../application/save_connection_usecase.dart';
import '../../data/repository/connection_network_repository.dart';
import '../states/network_state.dart';

final connectionControllerProvider =
    StateNotifierProvider.autoDispose<ConnectionController, NetworkState>(
  (ref) {
    final connectionRepository = ref.watch(connectionNetworkRepositoryProvider);
    return ConnectionController(SaveConnectionUseCase(connectionRepository));
  },
);

class ConnectionController extends StateNotifier<NetworkState> {
  ConnectionController(
    this._saveConnectionUseCase, {
    InternetConnection? internetConnection,
  })  : _injectedInternetConnection = internetConnection,
        super(NetworkState.initial()) {
    _init();
  }

  final SaveConnectionUseCase _saveConnectionUseCase;
  final InternetConnection? _injectedInternetConnection;

  late final StreamSubscription<List<ConnectivityResult>> _connectivitySub;
  late final StreamSubscription<InternetStatus> _serverSub;
  late final InternetConnection _serverChecker;

  void _init() {
    _serverChecker = _injectedInternetConnection ?? _createServerChecker();
    _connectivitySub =
        Connectivity().onConnectivityChanged.listen(_checkConnectivity);
    _serverSub =
        _serverChecker.onStatusChange.listen(_checkConnectivityToServer);
    checkConnection();
  }

  @override
  void dispose() {
    _connectivitySub.cancel();
    _serverSub.cancel();
    super.dispose();
  }

  Future<void> checkConnection() async {
    state = state.copyWith(
      result: [ConnectivityResult.none],
      lastState: ConnectionStatus.disconnected,
      newState: ConnectionStatus.disconnected,
      message: 'Esperando...',
    );
    Connectivity().checkConnectivity().then(_checkConnectivity);
  }

  Future<void> _checkConnectivity(List<ConnectivityResult> result) async {
    try {
      ConnectionStatus newState;
      String message;
      if (result.contains(ConnectivityResult.mobile)) {
        newState = ConnectionStatus.connected;
        message = 'Conectado a red móvil';
      } else if (result.contains(ConnectivityResult.wifi)) {
        newState = ConnectionStatus.connected;
        message = 'Conectado a red wifi';
      } else {
        newState = ConnectionStatus.disconnected;
        message = 'Sin conexión a internet';
      }

      if (newState == ConnectionStatus.connected) {
        final reachesServer = await _serverChecker.hasInternetAccess;
        if (!reachesServer) {
          newState = ConnectionStatus.disconnected;
          message = 'Modo offline';
        }
      }

      if (newState != state.lastState || result != state.result) {
        await _saveConnectionUseCase(newState == ConnectionStatus.connected);
        state = state.copyWith(
          result: result,
          newState: newState,
          lastState: newState,
          message: message,
        );
      }
    } catch (err) {
      ErrorLogger(runtimeType).regular(err);
    }
  }

  Future<void> _checkConnectivityToServer(InternetStatus status) async {
    final result = await Connectivity().checkConnectivity();
    if (status == InternetStatus.connected &&
        state.newState == ConnectionStatus.disconnected) {
      await _checkConnectivity(result);
    } else if (status == InternetStatus.disconnected &&
        state.newState == ConnectionStatus.connected) {
      await _checkConnectivity(result);
    }
  }

  // Verifica alcance al backend (no solo "hay internet") haciendo ping a Flavor.server.
  InternetConnection _createServerChecker() {
    return InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(uri: Uri.parse(Flavor.server ?? '')),
      ],
      useDefaultOptions: false,
    );
  }
}
