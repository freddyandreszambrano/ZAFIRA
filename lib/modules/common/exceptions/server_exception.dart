import 'package:dio/dio.dart';

import '../../../core/utils/logger.dart';

class ServerException implements Exception {
  factory ServerException.fromError(
    DioException error,
    String methodName,
    runtimeType,
  ) {
    ErrorLogger(runtimeType).dio(error, methodName);
    return ServerException(
      statusCode: error.response?.statusCode ?? -1,
      message: error.response?.data,
    );
  }

  /// Creates a [ServerException] with the specified [where] the exception
  /// was thrown. Also [statusCode] error and optional
  /// [message], place to send response from server.
  ServerException({required this.statusCode, this.message = ''});

  final int statusCode;
  final dynamic message;

  /// ** Add reasons to avoid tracking in crashlytics
  static const reasonsNotTracked = [];

  @override
  toString() {
    final reason =
        'ServerException('
        'STATUSCODE:$statusCode, '
        'MESSAGE:$message)';
    return reason;
  }
}
