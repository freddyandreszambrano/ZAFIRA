import '../../modules/common/exceptions/server_exception.dart';

String parseErrorMessage(dynamic err) {
  String message = 'Ocurrió un error, intente nuevamente.';

  if (err is ServerException) {
    final data = err.message;

    if (data is Map) {
      if (data.containsKey('message')) {
        return data['message'].toString();
      }

      if (data.containsKey('non_field_errors')) {
        final errors = data['non_field_errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      for (final value in data.values) {
        if (value is List && value.isNotEmpty) {
          return value.first.toString();
        }
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    if (data is String) {
      return data;
    }

    switch (err.statusCode) {
      case 400:
        return 'Solicitud inválida';
      case 401:
        return 'Credenciales incorrectas';
      case 403:
        return 'No tienes acceso a esta aplicación';
      case 422:
        return 'Datos inválidos';
    }
  }

  return message;
}
