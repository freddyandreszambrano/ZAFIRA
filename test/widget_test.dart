// Smoke test del branding/tema.
// `flutter test` corre todos los archivos `test/**_test.dart`.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zafira/feature/auth/view/widgets/shared/brand_wordmark.dart';

void main() {
  testWidgets('BrandWordmark renderiza la marca Zafira', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: BrandWordmark())),
      ),
    );

    expect(find.text('Zafira'), findsOneWidget);
  });
}
