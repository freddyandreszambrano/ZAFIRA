import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../exceptions/regular_exception.dart';
import '../exceptions/server_exception.dart';

mixin ErrorExceptionHandler {
  Future<Either<Exception, T>> handlerApiExceptions<T>(
    Future<T> Function() apiCall,
    String methodName,
    Type runtimeType, {
    Function()? onFinally,
  }) async {
    try {
      return Right(await apiCall());
    } on DioException catch (err, stack) {
      final exception = ServerException.fromError(err, methodName, runtimeType);
      if (!kIsWeb && exception.statusCode >= 500) {
        try {
          await FirebaseCrashlytics.instance.recordError(
            exception,
            stack,
            reason: '$runtimeType.$methodName',
            information: ['statusCode: ${exception.statusCode}'],
            fatal: false,
          );
        } catch (_) {}
      }
      return Left(exception);
    } catch (err, stack) {
      if (!kIsWeb && err is! RegularException && err is! ServerException) {
        try {
          await FirebaseCrashlytics.instance.recordError(
            err,
            stack,
            reason: '$runtimeType.$methodName',
            fatal: false,
          );
        } catch (_) {}
      }
      return Left(RegularException.fromError(err, methodName, runtimeType));
    } finally {
      if (onFinally != null) onFinally();
    }
  }
}
