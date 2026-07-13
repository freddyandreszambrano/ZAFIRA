import '../../../core/utils/logger.dart';

class RegularException implements Exception {
  factory RegularException.fromError(
    Object error,
    String methodName,
    Type runtimeType,
  ) {
    // Un factory de RegularException solo puede devolver una RegularException;
    // un ServerException no es subtipo y debe preservarlo el caller (ver
    // ErrorExceptionHandler.handlerApiExceptions), no este factory.
    if (error is RegularException) {
      return error;
    }

    ErrorLogger(runtimeType).regular(error, methodName);

    final message = error.toString();

    return RegularException(message: message);
  }

  RegularException({this.statusCode = -1, this.message = ''});

  final int statusCode;
  final Object? message;

  @override
  String toString() => 'RegularException(MESSAGE:$message)';
}
