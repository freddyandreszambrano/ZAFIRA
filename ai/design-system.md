# ZAFIRA — Design System (Mobile / Flutter)

Guía de diseño para la app **mobile** de ZAFIRA (Flutter, Android + iOS). Adaptada del Figma.

> **Fuente de verdad en código:** `lib/core/helpers/app_colors.dart` (colores, gradientes, sombras) y `lib/core/helpers/app_typography.dart` (tipografía). En UI **nunca** se usan valores hex literales: siempre los accesores `context.appColors.*` y `context.typography.*`. Ver reglas duras en [`rules/widget-design.md`](rules/widget-design.md).
>
> Los hex de esta guía son referencia para diseño/QA; si difieren del código, **gana el código**.

---

## 1. Identidad visual — Color

### Marca

| Token (Figma)   | `context.appColors.*` | Hex       | Uso |
|-----------------|-----------------------|-----------|-----|
| Cyber-Magenta   | `primary`             | `#FF3BBE` | Acción principal, CTAs, highlights, foco |
| Electric-Violet | `secondary`           | `#8E54FF` | Acción secundaria, acentos, estados activos |
| Obsidian        | `obsidian`            | `#090101` | Texto enfático, fondos oscuros, AppBar dark |
| Slate           | `slate`               | `#94A3BB` | Texto secundario, bordes, deshabilitados |

### Escalas

| Familia   | `context.appColors.*` | Hex       | Uso típico mobile |
|-----------|-----------------------|-----------|-------------------|
| Primary   | `primaryDark`         | `#C42A92` | Pressed / hover del primario |
|           | `primaryMid`          | `#FFB6E2` | Bordes y fondos suaves de marca |
|           | `primarySoft`         | `#FFE5F6` | Chips, badges, fondos de sección |
| Secondary | `secondaryDark`       | `#6B3ECB` | Pressed del secundario |
|           | `secondaryMid`        | `#C2A8FF` | Acentos suaves |
|           | `secondarySoft`       | `#EFE7FF` | Fondos de sección violeta |
| Slate     | `slateDeep`           | `#475569` | Texto de cuerpo secundario (`bodyMuted`) |
|           | `slateSoft`           | `#E2E8F0` | Divisores, outlines, skeletons |
| Obsidian  | `obsidianSoft`        | `#1F1F23` | Superficies oscuras elevadas |

### Superficies

| Token | `context.appColors.*` | Hex | Uso |
|---|---|---|---|
| Surface | `surface` | `#FFFFFF` | Fondo de Scaffold / cards |
| Surface low | `surfaceContainerLow` | `#F8FAFC` | Fondo de sección, inputs |
| Outline | `outline` | `#94A3BB` | Borde por defecto |

### Estados (semánticos)

| Estado | `context.appColors.*` | Hex | Container |
|---|---|---|---|
| Éxito | `success` | `#22C55E` | `successContainer` `#DCFCE7` |
| Error | `error` | `#EF4444` | `errorContainer` `#FEE2E2` |
| Aviso | `warning` | `#F59E0B` | `warningContainer` `#FEF3C7` |
| Info | `info` | `#0EA5E9` | `infoContainer` `#E0F2FE` |

> Para texto/icono sobre un container usar el par `on*Container` (ej. `onSuccessContainer`).

### Gradientes y sombras (solo en marca)

| Token | Accesor | Definición |
|---|---|---|
| Gradiente primario | `gradientPrimary` | Magenta → Violet, 135° (topLeft→bottomRight) |
| Gradiente oscuro | `gradientDark` | Obsidian → Obsidian-soft |
| Gradiente suave | `gradientSoft` | Primary-soft → Secondary-soft |
| Sombra marca | `shadowZafira` | Halo magenta sutil (`#FF3BBE` @ 35%) |
| Sombra marca lg | `shadowZafiraLg` | Halo magenta amplio |
| Sombra violeta | `shadowZafiraViolet` | Halo violeta |

Regla: gradientes y `shadowZafira*` **solo** en el CTA principal o superficies destacadas (un por pantalla). No degradar toda la UI.

---

## 2. Tipografía

- **Familia base:** Montserrat (vía `google_fonts`, configurada en `app_theme.dart`).
- **Acceso:** siempre `context.typography.*` — nunca `TextStyle(...)` literal.
- **Idioma:** todo el copy visible en **español**, en oración (`Correo electrónico`, no `Email` ni `CORREO`).
- Los tamaños escalan automáticamente en tablet vía `appDimensions.isTablet(context)`.

| Estilo `context.typography.*` | Tamaño mobile | Peso | Uso |
|---|---|---|---|
| `displayLarge` | 34 | w600 | Splash / títulos hero |
| `displayMedium` | 27 | w600 | Encabezado de pantalla grande |
| `displaySmall` | 22 | w600 | Encabezado de sección |
| `headlineMedium` | 16 | w500 | Título de card / AppBar |
| `titleMedium` | 16 | w400 | Título de fila / ítem |
| `bodyLarge` | 16 | w400 | Cuerpo principal |
| `bodyMedium` | 13 | w400 | Cuerpo por defecto |
| `bodySmall` | 9 | w400 | Notas, captions |
| `labelLarge` | 18 | w500 | Texto de botón |
| `labelMedium` | 14 | w500 | Labels de formulario |

**Estilos de marca** (derivados):

| Token | Uso |
|---|---|
| `bodyMuted` | Texto secundario en `slateDeep` |
| `bodyStrong` | Texto enfático en `obsidian`, w600 |
| `labelUppercase` | Badges / secciones en mayúsculas, `slate`, `letterSpacing: 1` |

---

## 3. Spacing y layout

- Separaciones con el paquete [`gap`](https://pub.dev/packages/gap): `const Gap(16)` en lugar de `SizedBox`.
- Escala (grid 8-pt): `4, 8, 12, 16, 24, 32, 48`.
- Padding de pantalla estándar: horizontal `16` (mobile) / `24` (tablet).
- Una columna en mobile. Evitar cards dentro de cards.

---

## 4. Componentes (mobile)

### Botón primario — patrón ZAFIRA

CTA de marca: `gradientPrimary` + `shadowZafira` + radio 16.

```dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  decoration: BoxDecoration(
    gradient: context.appColors.gradientPrimary,
    borderRadius: BorderRadius.circular(16),
    boxShadow: context.appColors.shadowZafira,
  ),
  child: Text(
    'Iniciar sesión',
    style: context.typography.labelLarge?.copyWith(color: context.appColors.onPrimary),
  ),
)
```

- **Secundario:** borde/fondo neutro (`slateSoft`) con acento `secondary`.
- **Estados:** normal, pressed (`primaryDark`), disabled (`slate` / opacidad), loading (spinner inline, deshabilita el tap).
- Texto corto, una sola acción. Ancho completo en formularios mobile.

### Inputs

- Decoración global vía `inputDecorationTheme` (`app_theme.dart`), no `InputDecoration` repetido por campo.
- Placeholder y label en español, en oración.
- Foco con acento `primary`; error con `error` + mensaje específico debajo.
- `autovalidateMode: AutovalidateMode.onUserInteraction`.
- Validación con `form_validator`/`formz`, nunca regex inline en el widget.

Ejemplos de copy: `Ingrese su usuario`, `Ingrese su contraseña`, `El correo ya se encuentra registrado`.

### Cards

- Para ítems repetidos o métricas concretas, no como contenedor universal.
- Fondo `surface`, radio moderado (12–16), sombra suave (no `shadowZafira`, reservada a marca).
- Borde opcional `slateSoft`.

### Bottom sheets / modales

- Vía `modal_bottom_sheet`. Altura sugerida `context.heightBottomSheet` (0.85 iOS / 0.95 Android).
- Handle superior, título en `headlineMedium`, acción principal al final, ancho completo.
- Usar bottom sheet en vez de diálogos para acciones con formulario en mobile.

### Listas

- `ListView.separated` con `Gap`/`Divider` (`slateSoft`).
- Ítem táctil mínimo 48dp de alto. Acciones con iconos reconocibles.
- Badges de estado activo/inactivo con `primarySoft` / `slateSoft`.

### Notificaciones (toast)

Feedback efímero (éxito/error/aviso/info) **solo** vía `AppNotification`
(`lib/modules/common/widget/notifications/app_notification.dart`) — nunca `SnackBar`.

```dart
AppNotification.error(context, 'No se pudo completar la acción');
AppNotification.success(context, 'Cuenta creada correctamente');
```

Tarjeta con fondo `*Container`, texto `on*Container` e ícono en chip del color fuerte del estado.
Regla completa en [`rules/widget-design.md`](rules/widget-design.md) §11.

---

## 5. Estados UX (obligatorio)

Toda pantalla/lista/detalle maneja **4 estados** con `switch` exhaustivo sobre `ResponseStatus` (ver `rules/widget-design.md`):

| Estado | Cómo se ve | Widget |
|---|---|---|
| **Loading** | spinner centrado + texto opcional | `CircularProgressIndicator` |
| **Empty** | icono + “Sin resultados” en `slate` | `_EmptyView` |
| **Error** | icono + mensaje + botón Reintentar | `_ErrorView(message, onRetry)` |
| **Success** | el contenido real | widget de data |

Nunca dejar la pantalla en blanco mientras carga. Todo flujo asíncrono tiene carga, éxito y error.

El feedback efímero (resultado de una acción) se muestra con `AppNotification` (ver §4 → Notificaciones).

**Mensajes estándar (español):**

- Login/carga: `Iniciando sesión...`
- Redirección: `Redirigiendo al inicio...`
- Registro exitoso: `Cuenta creada correctamente`
- Error de credenciales: `Usuario o contraseña incorrectos`
- Sin conexión: `Sin conexión a internet`
- Error genérico: `No se pudo completar la acción`

---

## 6. Iconografía

- Iconos simples y consistentes; preferir librería antes que SVG manual (`flutter_svg` solo si el asset viene del diseño).
- Tamaño táctil mínimo 24dp visual / 48dp de área.
- Acciones frecuentes: perfil (persona), módulos (grid/capas), guardar (bookmark), editar (lápiz), eliminar (trash), activo (check).

---

## 7. Pantallas base (mobile)

### Login

- Formulario en una columna, centrado vertical, con la marca presente (logo o wordmark con `gradientPrimary`).
- Fondo `surface` sobrio. CTA primario ancho completo abajo.
- Validación visible, mensajes en español.

### Home / Dashboard

- Accesos a módulos agrupados por tipo, en grid de 2 columnas (mobile).
- Estado vacío cuando el grupo no tenga módulos.
- AppBar con `gradientPrimary` o `surface` según jerarquía.

---

## 8. Responsive

- **Mobile (default):** una sola columna; formularios y acciones a ancho completo; navegación inferior o AppBar simple.
- **Tablet (`isTablet(context)`):** tamaños tipográficos mayores (automático), padding `24`, grids de más columnas; conservar navegación.
- El diseño nunca debe solapar texto, botones o iconos. Probar en pantalla chica (≤ 360dp de ancho).

---

## 9. Reglas de oro

- Cero hex literales y cero `TextStyle(...)` literales: usar `context.appColors.*` / `context.typography.*`.
- ¿Falta un token? Agregarlo **primero** a `app_colors.dart` / `app_typography.dart`, luego usarlo.
- Gradientes y sombras de marca: uno por pantalla, solo en lo destacado.
- Todo el copy en español, en oración.
- Checklist de UI antes de PR: ver [`rules/widget-design.md`](rules/widget-design.md) §10.
