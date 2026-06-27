import 'package:flutter/material.dart';

/// Paleta de colores de ZAFIRA.
///
/// Fuente de verdad: `ZAFIRA-CORE/docs/DESIGN_SYSTEM.md`.
/// Mantener sincronizado con la configuración Tailwind en `templates/base.html`
/// del proyecto Django.

// ── ZAFIRA brand tokens (espejo del DESIGN_SYSTEM.md) ──────────────────
const Color _zafiraPrimary = Color(0xFFFF3BBE); // Cyber-Magenta
const Color _zafiraPrimarySoft = Color(0xFFFFE5F6);
const Color _zafiraPrimaryMid = Color(0xFFFFB6E2);
const Color _zafiraPrimaryDark = Color(0xFFC42A92); // derivado para hover/dark

const Color _zafiraSecondary = Color(0xFF8E54FF); // Electric-Violet
const Color _zafiraSecondarySoft = Color(0xFFEFE7FF);
const Color _zafiraSecondaryMid = Color(0xFFC2A8FF);
const Color _zafiraSecondaryDark = Color(0xFF6B3ECB); // derivado

const Color _zafiraObsidian = Color(0xFF090101);
const Color _zafiraObsidianSoft = Color(0xFF1F1F23);

const Color _zafiraSlate = Color(0xFF94A3BB);
const Color _zafiraSlateSoft = Color(0xFFE2E8F0);
const Color _zafiraSlateDeep = Color(0xFF475569);

// ── Night / Auth (login con fondo azul + glow central) ─────────────────
const Color _nightDeep = Color(
  0xFF060912,
); // azul casi negro (bordes, arriba/abajo)
const Color _nightMid = Color(0xFF223A6E); // azul más claro (glow central)
const Color _nightCard = Color(0xFF131D33); // superficie del card
const Color _nightInput = Color(0xFF273450); // relleno de inputs (gris azulado)
const Color _nightBorder = Color(0xFF3C4A63); // bordes gris azulado

// ── Material Design 3 — derivados de los tokens ZAFIRA ─────────────────
const Color _primary = _zafiraPrimary;
const Color _primaryDark = _zafiraPrimaryDark;
const Color _primaryLight = _zafiraPrimaryMid;
const Color _onPrimary = Colors.white;
const Color _primaryContainer = _zafiraPrimarySoft;
const Color _onPrimaryContainer = Color(0xFF5C0044);

const Color _secondary = _zafiraSecondary;
const Color _secondaryDark = _zafiraSecondaryDark;
const Color _onSecondary = Colors.white;
const Color _secondaryContainer = _zafiraSecondarySoft;
const Color _onSecondaryContainer = Color(0xFF2F1090);

const Color _tertiary = _zafiraSecondaryDark;
const Color _onTertiary = Colors.white;
const Color _tertiaryContainer = _zafiraSecondarySoft;
const Color _onTertiaryContainer = Color(0xFF2F1090);
const Color _accent = _zafiraSecondary;

// ── Estados (success / warning / error / info) ─────────────────────────
const Color _warning = Color(0xFFF59E0B);
const Color _warningColor = Color(0xFFD97706);
const Color _onWarning = Color(0xFF422006);
const Color _warningContainer = Color(0xFFFEF3C7);
const Color _onWarningContainer = Color(0xFF78350F);

const Color _error = Color(0xFFEF4444);
const Color _errorColor = Color(0xFFDC2626);
const Color _onError = Colors.white;
const Color _errorContainer = Color(0xFFFEE2E2);
const Color _onErrorContainer = Color(0xFF7F1D1D);

const Color _success = Color(0xFF22C55E);
const Color _successColor = Color(0xFF16A34A);
const Color _onSuccess = Colors.white;
const Color _successContainer = Color(0xFFDCFCE7);
const Color _onSuccessContainer = Color(0xFF14532D);

const Color _info = Color(0xFF0EA5E9);
const Color _infoColor = Color(0xFF0284C7);
const Color _onInfo = Colors.white;
const Color _infoContainer = Color(0xFFE0F2FE);
const Color _onInfoContainer = Color(0xFF0C4A6E);

// ── Surface / Outline ──────────────────────────────────────────────────
const Color _surface = Colors.white;
const Color _surfaceEXCL = _zafiraObsidian;
const Color _surfaceContainerLowest = Color(0xFFFBFBFB);
const Color _surfaceContainerLow = Color(0xFFF8FAFC);
const Color _surfaceContainer = _zafiraSlateSoft;
const Color _onSurface = _zafiraObsidian;
const Color _onSurfaceVariant = _zafiraSlateDeep;
const Color _inverseSurface = _zafiraObsidian;
const Color _onInverseSurface = Color(0xFFF5F5F5);

const Color _outline = _zafiraSlate;
const Color _outlineNeutral = _zafiraSlateSoft;
const Color _outlineVariant = _zafiraSlateSoft;

// ── Misc ───────────────────────────────────────────────────────────────
const Color _auxiliaryPrimary = _zafiraPrimaryMid;
const Color _scrim = Colors.black;
const Color _shadow = Colors.black;

// ── Neutrals / Grayscale (mapeados a la escala slate de ZAFIRA) ────────
const Color _white = Colors.white;
const Color _whiteTransparent = Color(0x80FFFFFF);
const Color _grayTransparent = Color(0x40CBD5E1);
const Color _gray = _zafiraSlate;
const Color _grayDark = _zafiraSlateDeep;
const Color _grayWhite = _zafiraSlateSoft;
const Color _grayWhite2 = Color(0xFFF8FAFC);
const Color _grayContainer = Color(0xFFF1F5F9);
const Color _grayContainer2 = Color(0xFFF8FAFC);
const Color _grayContainer3 = Color(0xFFFBFBFB);
const Color _black = _zafiraObsidian;

const Color _grayMainLight = _zafiraSlateSoft;
const Color _grayMainLight2 = Color(0xFFCBD5E1);
const Color _grayMainDark1 = Color(0xFFB1B0B0);
const Color _grayMainDark2 = Color(0xFFA8A8A8);
const Color _grayMainDark3 = Color(0xFF999797);
const Color _grayMainDark4 = Color(0xFF8B8B8B);

/// Extensión sobre [ColorScheme] para tokens fuera del estándar Material 3.
extension ColorSchemeX on ColorScheme {
  Color get warning => _warning;
  Color get onWarning => _onWarning;
  Color get warningContainer => _warningContainer;
  Color get onWarningContainer => _onWarningContainer;

  Color get success => _success;
  Color get onSuccess => _onSuccess;
  Color get successContainer => _successContainer;
  Color get onSuccessContainer => _onSuccessContainer;

  Color get info => _info;
  Color get onInfo => _onInfo;
  Color get infoContainer => _infoContainer;
  Color get onInfoContainer => _onInfoContainer;

  Color get outlineNeutral => _outlineNeutral;
  Color get surfaceEXCL => _surfaceEXCL;
  Color get auxiliaryPrimary => _auxiliaryPrimary;
}

/// ColorScheme aplicado en `ThemeData` (ver `app_theme.dart`).
class AppColorScheme extends ColorScheme {
  const AppColorScheme()
    : super(
        primary: _primary,
        onPrimary: _onPrimary,
        primaryContainer: _primaryContainer,
        onPrimaryContainer: _onPrimaryContainer,
        secondary: _secondary,
        onSecondary: _onSecondary,
        secondaryContainer: _secondaryContainer,
        onSecondaryContainer: _onSecondaryContainer,
        tertiary: _tertiary,
        onTertiary: _onTertiary,
        tertiaryContainer: _tertiaryContainer,
        onTertiaryContainer: _onTertiaryContainer,
        error: _error,
        onError: _onError,
        errorContainer: _errorContainer,
        onErrorContainer: _onErrorContainer,
        surface: _surface,
        onSurface: _onSurface,
        surfaceContainer: _surfaceContainer,
        onSurfaceVariant: _onSurfaceVariant,
        surfaceContainerLow: _surfaceContainerLow,
        surfaceContainerLowest: _surfaceContainerLowest,
        inverseSurface: _inverseSurface,
        onInverseSurface: _onInverseSurface,
        outline: _outline,
        outlineVariant: _outlineVariant,
        brightness: Brightness.light,
        scrim: _scrim,
        shadow: _shadow,
      );
}

/// Acceso por instancia — `context.appColors.primary`, etc.
class AppColors {
  // ── Primary ─────────────────────────────────────────────────────────
  Color get primary => _primary;
  Color get primaryDark => _primaryDark;
  Color get primaryLight => _primaryLight;
  Color get primarySoft => _zafiraPrimarySoft;
  Color get primaryMid => _zafiraPrimaryMid;
  Color get onPrimary => _onPrimary;
  Color get primaryContainer => _primaryContainer;
  Color get onPrimaryContainer => _onPrimaryContainer;

  // ── Secondary ───────────────────────────────────────────────────────
  Color get secondary => _secondary;
  Color get secondaryDark => _secondaryDark;
  Color get secondarySoft => _zafiraSecondarySoft;
  Color get secondaryMid => _zafiraSecondaryMid;
  Color get onSecondary => _onSecondary;
  Color get secondaryContainer => _secondaryContainer;
  Color get onSecondaryContainer => _onSecondaryContainer;

  // ── Tertiary / Accent ───────────────────────────────────────────────
  Color get tertiary => _tertiary;
  Color get onTertiary => _onTertiary;
  Color get tertiaryContainer => _tertiaryContainer;
  Color get onTertiaryContainer => _onTertiaryContainer;
  Color get accent => _accent;

  // ── ZAFIRA brand tokens ─────────────────────────────────────────────
  Color get obsidian => _zafiraObsidian;
  Color get obsidianSoft => _zafiraObsidianSoft;
  Color get slate => _zafiraSlate;
  Color get slateSoft => _zafiraSlateSoft;
  Color get slateDeep => _zafiraSlateDeep;

  // ── Night / Auth (login oscuro azul) ────────────────────────────────
  Color get nightDeep => _nightDeep;
  Color get nightMid => _nightMid;
  Color get nightCard => _nightCard;
  Color get nightInput => _nightInput;
  Color get nightBorder => _nightBorder;

  // ── Status ──────────────────────────────────────────────────────────
  Color get warning => _warning;
  Color get warningColor => _warningColor;
  Color get onWarning => _onWarning;
  Color get warningContainer => _warningContainer;
  Color get onWarningContainer => _onWarningContainer;

  Color get error => _error;
  Color get errorColor => _errorColor;
  Color get onError => _onError;
  Color get errorContainer => _errorContainer;
  Color get onErrorContainer => _onErrorContainer;

  Color get success => _success;
  Color get successColor => _successColor;
  Color get onSuccess => _onSuccess;
  Color get successContainer => _successContainer;
  Color get onSuccessContainer => _onSuccessContainer;

  Color get info => _info;
  Color get infoColor => _infoColor;
  Color get onInfo => _onInfo;
  Color get infoContainer => _infoContainer;
  Color get onInfoContainer => _onInfoContainer;

  // ── Surface ─────────────────────────────────────────────────────────
  Color get surface => _surface;
  Color get surfaceEXCL => _surfaceEXCL;
  Color get surfaceContainerLowest => _surfaceContainerLowest;
  Color get surfaceContainerLow => _surfaceContainerLow;
  Color get surfaceContainer => _surfaceContainer;
  Color get onSurface => _onSurface;
  Color get onSurfaceVariant => _onSurfaceVariant;
  Color get inverseSurface => _inverseSurface;
  Color get onInverseSurface => _onInverseSurface;

  // ── Outline ─────────────────────────────────────────────────────────
  Color get outline => _outline;
  Color get outlineNeutral => _outlineNeutral;
  Color get outlineVariant => _outlineVariant;

  // ── Misc ────────────────────────────────────────────────────────────
  Color get auxiliaryPrimary => _auxiliaryPrimary;
  Color get scrim => _scrim;
  Color get shadow => _shadow;

  // ── Neutrals / Grayscale (alias hacia la escala slate de ZAFIRA) ────
  Color get white => _white;
  Color get whiteTransparent => _whiteTransparent;
  Color get grayTransparent => _grayTransparent;
  Color get gray => _gray;
  Color get grayDark => _grayDark;
  Color get grayWhite => _grayWhite;
  Color get grayWhite2 => _grayWhite2;
  Color get grayContainer => _grayContainer;
  Color get grayContainer2 => _grayContainer2;
  Color get grayContainer3 => _grayContainer3;
  Color get black => _black;
  Color get grayMainLight => _grayMainLight;
  Color get grayMainLight2 => _grayMainLight2;
  Color get grayMainDark1 => _grayMainDark1;
  Color get grayMainDark2 => _grayMainDark2;
  Color get grayMainDark3 => _grayMainDark3;
  Color get grayMainDark4 => _grayMainDark4;

  // ── Gradients ZAFIRA ────────────────────────────────────────────────
  /// `gradient-primary` del DESIGN_SYSTEM (Cyber-Magenta → Electric-Violet, 135°).
  LinearGradient get gradientPrimary => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_zafiraPrimary, _zafiraSecondary],
  );

  /// `gradient-dark` (obsidian → obsidian-soft).
  LinearGradient get gradientDark => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_zafiraObsidian, _zafiraObsidianSoft],
  );

  /// `gradient-soft` (primary-soft → secondary-soft).
  LinearGradient get gradientSoft => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [_zafiraPrimarySoft, _zafiraSecondarySoft],
  );

  /// Fondo del login: glow azul en el centro que se oscurece hacia los
  /// bordes (azul oscuro arriba y abajo, más claro al centro).
  RadialGradient get authBackground => const RadialGradient(
    center: Alignment(0, 0),
    radius: 0.95,
    colors: [_nightMid, _nightDeep],
  );

  // ── Shadows ZAFIRA ──────────────────────────────────────────────────
  /// `shadow-zafira` — halo magenta sutil.
  List<BoxShadow> get shadowZafira => const [
    BoxShadow(
      color: Color(0x59FF3BBE), // rgba(255,59,190,0.35)
      blurRadius: 30,
      spreadRadius: -10,
      offset: Offset(0, 10),
    ),
  ];

  /// `shadow-zafira-lg` — halo magenta más amplio.
  List<BoxShadow> get shadowZafiraLg => const [
    BoxShadow(
      color: Color(0x73FF3BBE), // rgba(255,59,190,0.45)
      blurRadius: 45,
      spreadRadius: -15,
      offset: Offset(0, 20),
    ),
  ];

  /// `shadow-zafira-violet` — halo violeta.
  List<BoxShadow> get shadowZafiraViolet => const [
    BoxShadow(
      color: Color(0x598E54FF), // rgba(142,84,255,0.35)
      blurRadius: 30,
      spreadRadius: -10,
      offset: Offset(0, 10),
    ),
  ];
}
