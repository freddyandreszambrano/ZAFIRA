// Smoke test del root widget.
// `flutter test` corre todos los archivos `test/**_test.dart`.

import 'package:flutter_test/flutter_test.dart';
import 'package:zafira/core/flavors/flavors_config.dart';
import 'package:zafira/main/common_main.dart';

void main() {
  testWidgets('ZafiraApp arranca y muestra el logo gradient', (tester) async {
    Flavor.setEnvironment(Environment.dev);

    await tester.pumpWidget(const ZafiraApp());

    expect(find.text('ZAFIRA'), findsOneWidget);
    expect(find.textContaining('Flavor:'), findsOneWidget);
  });
}
