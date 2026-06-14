import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/enum/connection_status.dart';

class NetworkState {
  NetworkState({
    required this.result,
    required this.lastState,
    required this.newState,
    required this.message,
  });

  factory NetworkState.initial() => NetworkState(
        result: const [ConnectivityResult.none],
        lastState: ConnectionStatus.unknown,
        newState: ConnectionStatus.unknown,
        message: '',
      );

  final List<ConnectivityResult>? result;
  final ConnectionStatus? lastState;
  final ConnectionStatus? newState;
  final String? message;

  NetworkState copyWith({
    List<ConnectivityResult>? result,
    ConnectionStatus? lastState,
    ConnectionStatus? newState,
    String? message,
  }) =>
      NetworkState(
        result: result ?? this.result,
        lastState: lastState ?? this.lastState,
        newState: newState ?? this.newState,
        message: message ?? this.message,
      );

  bool get isOnline => newState == ConnectionStatus.connected;
}
