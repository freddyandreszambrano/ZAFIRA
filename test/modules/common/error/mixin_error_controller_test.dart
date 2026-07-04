import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/modules/common/error/mixin_error_controller.dart';
import 'package:zafira/modules/common/exceptions/regular_exception.dart';
import 'package:zafira/modules/common/exceptions/server_exception.dart';

class _Handler with ErrorExceptionHandler {}

void main() {
  group('ErrorExceptionHandler.handlerApiExceptions', () {
    late _Handler handler;

    setUp(() {
      handler = _Handler();
    });

    test('devuelve Right con el valor cuando no hay error', () async {
      final result = await handler.handlerApiExceptions(
        () async => 42,
        'M',
        _Handler,
      );

      expect(result.isRight, isTrue);
      result.fold((_) => fail('No debería fallar'), (r) => expect(r, 42));
    });

    test('propaga el mismo ServerException sin re-envolverlo', () async {
      final server = ServerException(statusCode: 429, message: 'rate limited');

      final result = await handler.handlerApiExceptions<int>(
        () async => throw server,
        'M',
        _Handler,
      );

      expect(result.isLeft, isTrue);
      result.fold((l) {
        expect(identical(l, server), isTrue);
        expect((l as ServerException).statusCode, 429);
      }, (_) => fail('Debería fallar'));
    });

    test('propaga el mismo RegularException sin re-envolverlo', () async {
      final regular = RegularException(message: 'algo');

      final result = await handler.handlerApiExceptions<int>(
        () async => throw regular,
        'M',
        _Handler,
      );

      expect(result.isLeft, isTrue);
      result.fold(
        (l) => expect(identical(l, regular), isTrue),
        (_) => fail('Debería fallar'),
      );
    });
  });
}
