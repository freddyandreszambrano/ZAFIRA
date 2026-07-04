import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/modules/common/exceptions/regular_exception.dart';
import 'package:zafira/modules/common/exceptions/server_exception.dart';

void main() {
  group('RegularException.fromError', () {
    test('devuelve la misma instancia si ya es RegularException', () {
      final original = RegularException(message: 'algo');

      final result = RegularException.fromError(original, 'M', String);

      expect(identical(result, original), isTrue);
    });

    test('no lanza y envuelve cuando recibe un ServerException', () {
      final server = ServerException(statusCode: 429, message: 'rate limited');

      // Antes del fix esto lanzaba:
      // type 'ServerException' is not a subtype of type 'RegularException'
      final result = RegularException.fromError(server, 'M', String);

      expect(result, isA<RegularException>());
    });

    test('envuelve un error genérico en RegularException', () {
      final result = RegularException.fromError(
        Exception('boom'),
        'M',
        String,
      );

      expect(result, isA<RegularException>());
      expect(result.message.toString(), contains('boom'));
    });
  });
}
