# Testing Rules

> Patrón canónico de tests para `zafira`, espejo del estilo de `hey-support`.
> Stack: `flutter_test` + `mocktail` (mocks) + `flutter_riverpod` (`ProviderContainer` con overrides).

---

## 1. Estructura de carpetas

Los tests reflejan la estructura de `lib/`:

```
test/
├── core/                                ← tests de servicios globales (crashlytics, push, etc.)
├── feature/<name>/
│   ├── application/<x>_usecase_test.dart       ← UseCase tests
│   ├── data/services/<x>_service_test.dart     ← Service tests (HTTP)
│   ├── domain/model/<x>_model_test.dart        ← Model tests (fromJson, copyWith)
│   └── view/controller/<x>_controller_test.dart  ← Controller tests (state machine)
├── helpers/
│   └── http_test_dio.dart               ← Helper de Dio mockeado (stubDio, stubDioOk, stubDioError)
└── widget_test.dart                     ← Smoke test del root
```

## 2. Setup mínimo de cada test

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zafira/feature/auth/data/interfaces/auth_interface.dart';
import 'package:zafira/feature/auth/view/controller/auth_controller.dart';

class _MockAuth extends Mock implements IAuth {}

void main() {
  group('AuthController', () {
    late _MockAuth auth;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      auth = _MockAuth();
      registerFallbackValue(const UserModel());
    });

    ProviderContainer makeContainer() {
      return ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
        ],
      );
    }

    test('login success transitions to ResponseStatus.success', () async {
      when(() => auth.login('admin', 'pass')).thenAnswer(
        (_) async => const AuthTokenModel(token: 't'),
      );

      final c = makeContainer();
      addTearDown(c.dispose);

      await c.read(authControllerProvider.notifier).login('admin', 'pass');

      final state = c.read(authControllerProvider);
      expect(state.status, ResponseStatus.success);
      verify(() => auth.login('admin', 'pass')).called(1);
    });
  });
}
```

Notar:
- **`_MockAuth` con prefix underscore** — local al archivo, no se exporta.
- **`registerFallbackValue`** para tipos custom usados en `any()` (mocktail lo requiere para tipos no nativos).
- **`makeContainer()`** helper local — crea un `ProviderContainer` por test con overrides necesarios.
- **`addTearDown(c.dispose)`** — limpia el container al final de cada test (NO usar `tearDown` global con `late` containers).
- **`when()` antes**, **`act` después**, **`expect()` y `verify()` al final** — patrón AAA explícito.

## 3. Tests por capa

### 3.1 Service tests (HTTP)

Usar `stubDio()` de `test/helpers/http_test_dio.dart`. Nunca mockear `Dio` a mano.

```dart
import '../../helpers/http_test_dio.dart';

test('login devuelve UserModel cuando el backend responde 200', () async {
  final dio = stubDioOk({'id': 1, 'username': 'admin'});
  final service = AuthService(dio);

  final result = await service.login('admin', 'pass');

  expect(result.isRight(), isTrue);
  result.fold(
    (l) => fail('No debería fallar'),
    (r) => expect(r.username, 'admin'),
  );
});

test('login devuelve Left(DioException) en 401', () async {
  final dio = stubDioError(statusCode: 401);
  final service = AuthService(dio);

  final result = await service.login('admin', 'wrong');

  expect(result.isLeft(), isTrue);
});
```

### 3.2 UseCase tests

Mock la interface del repository. Validá que el UseCase devuelve `Either<Exception, T>`.

```dart
class _MockAuthRepo extends Mock implements IAuth {}

test('LoginUseCase llama al repo y propaga el Right', () async {
  final repo = _MockAuthRepo();
  when(() => repo.login('a', 'b')).thenAnswer(
    (_) async => const AuthTokenModel(token: 't'),
  );

  final useCase = LoginUseCase(repo);
  final result = await useCase('a', 'b');

  expect(result.isRight(), isTrue);
});
```

### 3.3 Controller tests (state machine)

Los tests más densos — validan transiciones de estado:

```dart
test('controller pasa loading → success en login OK', () async {
  // arrange
  when(() => auth.login(any(), any())).thenAnswer(
    (_) async => const AuthTokenModel(token: 't'),
  );
  final c = makeContainer();
  addTearDown(c.dispose);

  // act
  final future = c.read(authControllerProvider.notifier).login('a', 'b');

  // assert intermedio: estado loading
  expect(c.read(authControllerProvider).status, ResponseStatus.loading);

  await future;

  // assert final: estado success
  final state = c.read(authControllerProvider);
  expect(state.status, ResponseStatus.success);
  expect(state.isLoading, isFalse);
});
```

Reglas:
- **Verificar `isLoading: false` en AMBAS ramas** (success y error). Si lanza un error y `isLoading` queda en `true`, el UI se cuelga.
- **No testear el método interno del Controller** — testear el estado resultante.
- **Un `test()` por comportamiento**, no por método.

### 3.4 Widget tests

Solo para widgets puros (presentacionales). NO para screens completas con muchas dependencias — esas se cubren con tests del Controller.

```dart
testWidgets('PrimaryButton dispara onPressed al tap', (tester) async {
  var tapped = false;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: PrimaryButton(
          label: 'Login',
          onPressed: () => tapped = true,
        ),
      ),
    ),
  );

  await tester.tap(find.text('Login'));
  expect(tapped, isTrue);
});
```

## 4. Mocks de canales nativos

Si tu controller toca un `MethodChannel` (sockets, notificaciones nativas, etc.), neutralizalo:

```dart
const _socketChannel = MethodChannel('com.zafira/socket');

setUp(() {
  TestWidgetsFlutterBinding.ensureInitialized()
      .defaultBinaryMessenger
      .setMockMethodCallHandler(_socketChannel, (_) async => null);
});

tearDown(() {
  TestWidgetsFlutterBinding.ensureInitialized()
      .defaultBinaryMessenger
      .setMockMethodCallHandler(_socketChannel, null);
});
```

## 5. Reglas duras

- ❌ Nunca tocar red real. Siempre `stubDio*`.
- ❌ Nunca `print(...)` en tests (lint `avoid_print: warning`).
- ❌ Nunca `Future.delayed` para sincronizar — usar `await` directo o `pumpAndSettle()`.
- ❌ Nunca testear `*.freezed.dart` o `*.g.dart` (auto-generados).
- ✅ Mock con `mocktail`, no `mockito` (mocktail no requiere `@GenerateMocks`).
- ✅ Antes de tests, si tocaste un `@freezed` o `@JsonSerializable`: `make gen` (o `dart run build_runner build --delete-conflicting-outputs`).
- ✅ Coverage mínimo aspiracional: **70% en `application/` y `data/services/`**. UI no se mide.

## 6. Comandos

```bash
make deps                                       # flutter pub get
make gen                                        # build_runner build (Freezed/json/envied)
make test                                       # toda la suite
make test-coverage                              # con lcov

# Tests de una feature específica
flutter test test/feature/auth/

# Un solo archivo
flutter test test/feature/auth/view/controller/auth_controller_test.dart

# Replicar lo que corre el CI localmente
make ci-local
```
