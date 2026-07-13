import 'package:flutter_test/flutter_test.dart';

import 'package:zafira/feature/onboarding/application/onboarding_usecase.dart';
import 'package:zafira/feature/onboarding/data/interfaces/onboarding_interface.dart';

class _FakeOnboardingRepository implements IOnboardingRepository {
  _FakeOnboardingRepository({this.exception});

  final Exception? exception;
  Map<String, String>? submittedAnswers;

  @override
  Future<void> submit(Map<String, String> answers) async {
    if (exception != null) throw exception!;
    submittedAnswers = answers;
  }
}

void main() {
  test('propaga un envío de onboarding exitoso', () async {
    final repository = _FakeOnboardingRepository();
    final useCase = OnboardingUseCase(repository);
    const answers = {'gender': 'femenino', 'preferred_size': 'M'};

    final result = await useCase.submit(answers);

    expect(result.isRight, isTrue);
    expect(repository.submittedAnswers, answers);
  });

  test('convierte una excepción del repositorio en Left', () async {
    final useCase = OnboardingUseCase(
      _FakeOnboardingRepository(exception: Exception('down')),
    );

    final result = await useCase.submit(const {'gender': 'femenino'});

    expect(result.isLeft, isTrue);
  });
}
