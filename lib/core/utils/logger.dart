import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(), // Use the PrettyPrinter to format and print log
);

/// * [message] is the error message
/// * [functionName] is the function name of the error origin
/// * [fileName] is the file name of the error origin
void errorLogger({
  required String? message,
  required String functionName,
  required String fileName,
}) {
  // TODO: implement sentry
  if (kDebugMode) {
    _logger.e(
      'ERROR: $message in the function $functionName on file $fileName',
    );
  }
}

// ---------------------- new impl

final _loggerNew = Logger(printer: SimpleLogPrinter(), level: Level.debug);

void errorLoggerNew({
  required Type className,
  required String methodName,
  required String message,
}) {
  _loggerNew.e("$className -> $methodName: $message");
}

class SimpleLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    var color = PrettyPrinter.defaultLevelColors[event.level]!;
    var emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    var message = event.message;

    return [color("─" * 40), color("$emoji $message")];
  }
}

class DebugLogger {
  DebugLogger(this.className);
  final Type className;

  void init() {
    _loggerNew.d("$className => init");
  }

  void regular(String message, [String? methodName]) {
    var finalMessage = "$className => $message";
    if (methodName != null) {
      finalMessage = "$finalMessage in $methodName method";
    }

    _loggerNew.d(finalMessage);
  }

  void methodInit(String method) {
    _loggerNew.d("$className => init $method method");
  }

  void request(String methodName, [Object? payload]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => request in method $methodName";
    if (payload != null) {
      message = "$message with payload: \n ${encoder.convert(payload)}";
    }

    _loggerNew.d(message);
  }

  void response(String methodName, [Object? data]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => response in method $methodName";
    if (data != null) {
      message = "$message with data: \n ${encoder.convert(data)}";
    }

    _loggerNew.d(message);
  }

  void toLocalStorage(String methodName, [Object? data]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => updated local storage in method $methodName";
    if (data != null) {
      message = "$message with data: \n ${encoder.convert(data)}";
    }

    _loggerNew.d(message);
  }

  void fromLocalStorage(String methodName, [Object? data]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => read from local storage in method $methodName";
    if (data != null) {
      message = "$message with data: \n ${encoder.convert(data)}";
    }

    _loggerNew.d(message);
  }

  void toSQLite(String methodName, [Object? data]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => to SQLite in method $methodName";
    if (data != null) {
      message = "$message with data: \n ${encoder.convert(data)}";
    }

    _loggerNew.d(message);
  }

  void fromSQLite(String methodName, [Object? data]) {
    var encoder = const JsonEncoder.withIndent("     ");

    var message = "$className => from SQLite in method $methodName";
    if (data != null) {
      message = "$message with data: \n ${encoder.convert(data)}";
    }

    _loggerNew.d(message);
  }
}

class InformationLogger {
  InformationLogger(this.className);
  final Type className;

  void regular(String message) {
    _loggerNew.i("$className => $message");
  }

  void success() {
    _loggerNew.i("$className => Success");
  }
}

class ErrorLogger {
  ErrorLogger(this.className);
  final Type className;

  void regular(dynamic message, [String? methodName]) {
    var finalMessage = "$className => $message";
    if (methodName != null) {
      finalMessage = "$finalMessage in $methodName method";
    }
    _loggerNew.e(finalMessage);
  }

  void dio(DioException error, [String? methodName]) {
    var encoder = const JsonEncoder.withIndent("     ");
    var finalMessage =
        "$className => ${error.message} ${encoder.convert(error.response?.data ?? '')}";
    if (methodName != null) {
      finalMessage = "$finalMessage in $methodName method";
    }
    _loggerNew.e(finalMessage);
  }

  void dioWithStackTrace(DioException error, [String? methodName]) {
    var finalMessage = "$className => $error";
    if (methodName != null) {
      finalMessage = "$finalMessage in $methodName method";
    }
    _loggerNew.e(finalMessage);
  }
}
