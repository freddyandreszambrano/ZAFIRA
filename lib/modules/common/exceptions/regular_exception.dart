import '../../../core/utils/logger.dart';
import 'server_exception.dart';

class RegularException implements Exception {
  factory RegularException.fromError(
    dynamic error,
    String methodName,
    runtimeType,
  ) {
    if (error is RegularException || error is ServerException) {
      return error;
    }

    ErrorLogger(runtimeType).regular(error, methodName);

    final message = error is ExceptionWithResponse
        ? error.response?.data
        : error.toString();

    return RegularException(
      message: message,
    );
  }

  RegularException({
    this.statusCode = -1,
    this.message = '',
  });

  final int statusCode;
  final dynamic message;

  @override
  String toString() => 'RegularException(MESSAGE:$message)';
}

class ExceptionWithResponse {
  dynamic response;
}
