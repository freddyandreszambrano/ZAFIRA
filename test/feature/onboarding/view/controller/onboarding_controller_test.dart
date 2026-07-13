import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/core/enum/response_status.dart';
import 'package:zafira/feature/onboarding/application/onboarding_usecase.dart';
import 'package:zafira/feature/onboarding/data/interfaces/onboarding_interface.dart';
import 'package:zafira/feature/onboarding/view/controller/onboarding_controller.dart';

class _FakeOnboardingRepository implements IOnboardingRepository {
  _FakeOnboardingRepository({this.completer, this.exception});

  final Completer<void>? completer;
  final Exception? exception;

  @override
  Future<void> submit(Map<String, String> answers) async {
    if (exception != null) throw exception!;
    await completer?.future;
  }
}

void main() {
  test('pasa de loading a success cuando el envío termina', () async {
    final completer = Completer<void>();
    final controller = OnboardingController(
      OnboardingUseCase(_FakeOnboardingRepository(completer: completer)),
    );
    controller.setAnswer('gender', 'femenino');

    final future = controller.submit();

    expect(controller.state.status, ResponseStatus.loading);

    completer.complete();
    await future;

    expect(controller.state.status, ResponseStatus.success);
    expect(controller.state.errorMessage, isNull);
  });

  test('pasa a error cuando el caso de uso falla', () async {
    final controller = OnboardingController(
      OnboardingUseCase(
        _FakeOnboardingRepository(exception: Exception('down')),
      ),
    );

    await controller.submit();

    expect(controller.state.status, ResponseStatus.error);
    expect(controller.state.errorMessage, isNotEmpty);
  });
}
