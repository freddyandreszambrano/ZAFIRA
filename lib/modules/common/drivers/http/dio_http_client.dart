import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/flavors/flavors_config.dart';
import '../storage/local_storage.dart';
import '../storage/local_storage_impl.dart';

final dioHttpClientProvider = Provider<DioHttpClient>(
  (ref) {
    final localDataSource = ref.watch(secureLocalDataSourceProvider);
    return DioHttpClient(localDataSource);
  },
);

class DioHttpClient {
  DioHttpClient(this.localDataSource);

  LocalStorage localDataSource;
  Dio? _dio;

  /// Instancia única de [Dio] por cliente HTTP (interceptors y opciones base una sola vez).
  Dio call() => _dio ??= _createDio();

  Dio _createDio() {
    final dio = Dio()
      ..options.baseUrl = Flavor.server ?? ''
      ..options.receiveDataWhenStatusError = true
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['Authorization'] =
              await localDataSource.getItem(AppStrings.keyTokenJwt);
          options.headers['app-source'] = kIsWeb ? 'zafira-web' : 'zafira-app';
          options.headers['kIsWeb'] = kIsWeb.toString();
          options.headers['content-type'] = 'application/json';
          options.baseUrl = Flavor.server ?? '';
          if (!kIsWeb) {
            if (Flavor.projectVersion != null) {
              options.headers['app-version'] = Flavor.projectVersion;
            }
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  }
}
