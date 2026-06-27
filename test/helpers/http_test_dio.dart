import 'package:dio/dio.dart';

/// Crea un [Dio] que resuelve cada request en el isolate de test, sin tocar red.
///
/// Uso típico:
/// ```dart
/// final dio = stubDio((options) => Response(
///   requestOptions: options,
///   statusCode: 200,
///   data: {'token': 'abc'},
/// ));
/// final service = AuthService(dio);
/// ```
///
/// Espejo de `hey-support/test/helpers/http_test_dio.dart`.
Dio stubDio(Response<dynamic> Function(RequestOptions options) resolve) {
  final dio = Dio(
    BaseOptions(baseUrl: 'https://unit.test/', validateStatus: (_) => true),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        handler.resolve(resolve(options));
      },
    ),
  );
  return dio;
}

/// Atajo: stub Dio que SIEMPRE responde con [data] y [statusCode].
Dio stubDioOk(dynamic data, {int statusCode = 200}) {
  return stubDio(
    (options) =>
        Response(requestOptions: options, statusCode: statusCode, data: data),
  );
}

/// Atajo: stub Dio que SIEMPRE tira [DioException].
Dio stubDioError({
  int statusCode = 500,
  String path = '/test',
  DioExceptionType type = DioExceptionType.badResponse,
}) {
  return stubDio((options) {
    final req = RequestOptions(path: path);
    throw DioException(
      requestOptions: req,
      response: Response(
        requestOptions: req,
        statusCode: statusCode,
        data: 'stubbed error',
      ),
      type: type,
    );
  });
}
