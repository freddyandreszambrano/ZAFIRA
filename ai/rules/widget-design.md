# Widget & Screen Design Rules

> Reglas de UI para que cualquier screen o widget nuevo en `zafira` sea consistente con el design system y siga el patrón de hey-support.

---

## 1. Source of truth de colores y tipografía

- **Colores:** SIEMPRE vía `context.appColors.*` (instancia de `AppColors` en `lib/core/helpers/app_colors.dart`). Tokens documentados en `ZAFIRA-CORE/docs/DESIGN_SYSTEM.md`.
  - ❌ `Color(0xFFFF3BBE)`
  - ❌ `Colors.purple`
  - ✅ `context.appColors.primary`
  - ✅ `context.appColors.slate`
  - ✅ `context.appColors.gradientPrimary`
- **Tipografía:** SIEMPRE vía `context.typography.*`.
  - ❌ `TextStyle(fontSize: 14, color: Colors.grey)`
  - ✅ `context.typography.bodyMedium`
  - ✅ `context.typography.bodyMuted` (slate-deep para texto secundario)
  - ✅ `context.typography.labelUppercase` (badges, secciones)
- **Dimensiones:** breakpoints vía `context.appDimensions.isTablet(context)`.

## 2. Estructura de un Screen

```dart
class XxxScreen extends ConsumerWidget {
  const XxxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(xxxControllerProvider);
    final controller = ref.read(xxxControllerProvider.notifier);

    return Scaffold(
      appBar: const _XxxAppBar(),
      body: SafeArea(
        child: switch (state.status) {
          ResponseStatus.loading => const _LoadingView(),
          ResponseStatus.error => _ErrorView(message: state.errorMessage),
          ResponseStatus.success => _ContentView(state: state),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
```

Reglas:
- **`ConsumerWidget`** para screens que leen Riverpod. `ConsumerStatefulWidget` solo si hay `initState` necesario.
- **`ref.watch`** para data que dispara rebuild. **`ref.read`** para llamadas a métodos (`controller.fetch()`).
- **Renderizado por status** con `switch` exhaustivo sobre `ResponseStatus`. No usar `if/else` anidados.
- **Subwidgets privados** (`_LoadingView`, `_ErrorView`, `_ContentView`) en el mismo archivo para escenas chicas. Si crecen, mover a `widgets/`.

## 3. Composición de widgets

- **Un widget = una responsabilidad.** Si un widget hace fetch, render, y maneja navegación → partirlo.
- **`const` siempre que sea posible** — clave para performance del rebuild.
- **`super.key` no usar** (regla del linter: `use_super_parameters: false` y `use_key_in_widget_constructors: false`).
- **Constructor con campos finales primero, luego el `build`** (regla `sort_constructors_first: true`).
- **Trailing commas en todo** (regla `require_trailing_commas: true`) — mejora diffs y formato automático.

## 4. Spacing y layout

Usar el paquete [`gap`](https://pub.dev/packages/gap) para separaciones consistentes en `Column`/`Row`:
```dart
Column(
  children: [
    Text('Título', style: context.typography.headlineMedium),
    const Gap(8),
    Text('Subtítulo', style: context.typography.bodyMuted),
    const Gap(24),
    ElevatedButton(...),
  ],
)
```

❌ `const SizedBox(height: 24)` — funciona pero `Gap(24)` es más expresivo.

Escala recomendada (Material 8-pt grid): `4, 8, 12, 16, 24, 32, 48`.

## 5. Botones primarios — patrón ZAFIRA

Reflejo del DESIGN_SYSTEM §4 (botón primario con `gradient-primary` + `shadow-zafira`):

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  decoration: BoxDecoration(
    gradient: context.appColors.gradientPrimary,
    borderRadius: BorderRadius.circular(16),
    boxShadow: context.appColors.shadowZafira,
  ),
  child: Text(
    'Administrar Usuarios',
    style: context.typography.labelLarge?.copyWith(color: Colors.white),
  ),
)
```

## 6. Estados visuales del usuario

Toda lista o detalle DEBE manejar 4 estados:

| Estado | Cómo se ve | Qué widget usar |
|---|---|---|
| **Loading** | spinner centered con texto opcional | `CircularProgressIndicator` + `Gap` |
| **Empty** | ícono + mensaje "Sin resultados" en `slate` | `_EmptyView` con SVG/icon centrado |
| **Error** | ícono error + mensaje + botón Reintentar | `_ErrorView(message, onRetry)` |
| **Success** | el contenido real | el widget de data |

Nunca dejar pantalla en blanco mientras se carga.

## 7. Formularios

- **`form_validator` o `formz`** para validación — NO regex en el widget.
- Decoración de inputs vía `inputDecorationTheme` global (definido en `app_theme.dart`), NO `InputDecoration` repetido en cada `TextField`.
- Labels en español, en oración: `'Correo electrónico'`, NO `'Email'` ni `'CORREO'`.
- `autovalidateMode: AutovalidateMode.onUserInteraction` para que valide después de la primera interacción del usuario.

## 8. Navegación

- **`go_router` siempre.** Nunca `Navigator.of(context).push(...)` directo.
- Rutas en `lib/core/routes/app_router.dart` con constantes de paths.
- Deep links: respetar el path `/admin/<feature>/...` que espeja al backend Django.

## 9. Lo que NO se hace nunca

- ❌ Lógica de negocio en widgets (mover a Controller o UseCase).
- ❌ `setState` en `ConsumerWidget` (usar Riverpod).
- ❌ Strings hardcoded para UI (extraer a `l10n` o constantes — al menos para el copy permanente).
- ❌ `ScaffoldMessenger.showSnackBar(...)` o `MySnackBar` (eliminado) para feedback — usar `AppNotification` (ver §11).
- ❌ Imports absolutos dentro de `lib/<feature>/` (usar relativos: lint `prefer_relative_imports`).
- ❌ Widgets > 200 LOC — partir en sub-widgets privados.
- ❌ Diseño que rompa con `DESIGN_SYSTEM.md` — si necesitás un nuevo token, agregarlo PRIMERO al sistema, después usarlo.

## 10. Checklist antes de PR-ear un screen

- [ ] Usa `context.appColors.*` y `context.typography.*` (cero hex y cero `TextStyle` literales).
- [ ] Maneja los 4 estados (loading/empty/error/success).
- [ ] Trailing commas y formato (`dart format .`).
- [ ] `flutter analyze` limpio.
- [ ] Tests del controller (no del widget; ver `ai/rules/testing.md`).
- [ ] Strings en español, sin abreviaciones.
- [ ] `const` en todo lo posible.
- [ ] Feedback al usuario vía `AppNotification` (cero `SnackBar` / `MySnackBar`).

## 11. Notificaciones y feedback (toasts)

El **único** mecanismo para mostrar feedback efímero (éxito / error / aviso / info) es
`AppNotification`, en `lib/modules/common/widget/notifications/app_notification.dart`.

- ❌ `ScaffoldMessenger.of(context).showSnackBar(...)`
- ❌ `MySnackBar.show(...)` — **eliminado** del proyecto.
- ✅ `AppNotification.error(context, 'Mensaje en español')`

API:

```dart
AppNotification.success(context, 'Cuenta creada correctamente');
AppNotification.error(context, 'No se pudo completar la acción');
AppNotification.warning(context, 'Revisá los datos ingresados');
AppNotification.info(context, 'Redirigiendo al inicio...');

// Forma completa (duración custom):
AppNotification.show(
  context,
  message: 'Mensaje',
  type: AppNotificationType.error,
  duration: const Duration(seconds: 5),
);
```

Reglas:
- El widget ya usa tokens del design system (`context.appColors.*Container` / `on*Container`,
  constantes `kNotification*` de `app_numbers.dart`). Si lo modificás, **cero valores quemados**.
- El `message` siempre en español, en oración. Usar los mensajes estándar del `design-system.md` §5.
- Se monta sobre el `Overlay` raíz: funciona desde cualquier `BuildContext` bajo `MaterialApp`,
  incluido fuera de un `Scaffold`.

**Migración (referencia):** `MySnackBar.show(context, msg, type: SnackBarType.error)`
→ `AppNotification.error(context, msg)`. El mapeo de tipos es 1:1
(`SnackBarType.{info,success,warning,error}` → `AppNotificationType.{info,success,warning,error}`).
