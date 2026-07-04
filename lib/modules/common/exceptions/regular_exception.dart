import '../../../core/utils/logger.dart';

class RegularException implements Exception {
  factory RegularException.fromError(
    dynamic error,
    String methodName,
    runtimeType,
  ) {
    // Un factory de RegularException solo puede devolver una RegularException;
    // un ServerException no es subtipo y debe preservarlo el caller (ver
    // ErrorExceptionHandler.handlerApiExceptions), no este factory.
    if (error is RegularException) {
      return error;
    }

    ErrorLogger(runtimeType).regular(error, methodName);

    final message = error is ExceptionWithResponse
        ? error.response?.data
        : error.toString();

    return RegularException(message: message);
  }

  RegularException({this.statusCode = -1, this.message = ''});

  final int statusCode;
  final dynamic message;

  @override
  String toString() => 'RegularException(MESSAGE:$message)';
}

class ExceptionWithResponse {
  dynamic response;
}
