import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

enum AppNotificationType { info, success, warning, error }

class AppNotification {
  const AppNotification._();

  static void show(
    BuildContext context, {
    required String message,
    AppNotificationType type = AppNotificationType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppNotificationToast(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (entry.mounted) entry.remove();
        },
      ),
    );
    overlay.insert(entry);
  }

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: AppNotificationType.info);

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: AppNotificationType.success);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: AppNotificationType.warning);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: AppNotificationType.error);
}

class _AppNotificationStyle {
  const _AppNotificationStyle({
    required this.accent,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  /// Color fuerte del estado (chip del ícono, borde y sombra).
  final Color accent;

  /// Fondo container suave de la tarjeta.
  final Color background;

  /// Texto y acciones sobre el container (`on*Container`).
  final Color foreground;

  final IconData icon;
}

_AppNotificationStyle _styleFor(BuildContext context, AppNotificationType type) {
  final colors = context.appColors;
  switch (type) {
    case AppNotificationType.success:
      return _AppNotificationStyle(
        accent: colors.success,
        background: colors.successContainer,
        foreground: colors.onSuccessContainer,
        icon: Icons.check_circle_rounded,
      );
    case AppNotificationType.warning:
      return _AppNotificationStyle(
        accent: colors.warning,
        background: colors.warningContainer,
        foreground: colors.onWarningContainer,
        icon: Icons.warning_amber_rounded,
      );
    case AppNotificationType.error:
      return _AppNotificationStyle(
        accent: colors.error,
        background: colors.errorContainer,
        foreground: colors.onErrorContainer,
        icon: Icons.error_rounded,
      );
    case AppNotificationType.info:
      return _AppNotificationStyle(
        accent: colors.info,
        background: colors.infoContainer,
        foreground: colors.onInfoContainer,
        icon: Icons.info_rounded,
      );
  }
}

class _AppNotificationToast extends StatefulWidget {
  const _AppNotificationToast({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final AppNotificationType type;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_AppNotificationToast> createState() => _AppNotificationToastState();
}

class _AppNotificationToastState extends State<_AppNotificationToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_closing) return;
    _closing = true;
    _timer?.cancel();
    if (mounted) {
      await _controller.reverse();
    }
    widget.onDismiss();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(context, widget.type);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: tabletSize),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                separatorMd,
                separatorLg,
                separatorMd,
                0,
              ),
              child: SlideTransition(
                position: _slide,
                child: FadeTransition(
                  opacity: _fade,
                  child: Material(
                    color: Colors.transparent,
                    child: _AppNotificationCard(
                      message: widget.message,
                      style: style,
                      onClose: _dismiss,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppNotificationCard extends StatelessWidget {
  const _AppNotificationCard({
    required this.message,
    required this.style,
    required this.onClose,
  });

  final String message;
  final _AppNotificationStyle style;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kSpaceDeviceHVSpecial,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: kBorderRadiusAllMedium,
        border: Border.all(
          color: style.accent.withValues(alpha: kNotificationBorderAlpha),
        ),
        boxShadow: [
          BoxShadow(
            color: style.accent.withValues(alpha: kNotificationShadowAlpha),
            blurRadius: kNotificationShadowBlur,
            spreadRadius: kNotificationShadowSpread,
            offset: kNotificationShadowOffset,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: kSpaceDeviceXSm,
            decoration: BoxDecoration(
              color: style.accent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              style.icon,
              color: context.appColors.white,
              size: kNotificationIconSize,
            ),
          ),
          const Gap(separatorSm),
          Flexible(
            child: Text(
              message,
              style: context.typography.bodyMedium?.copyWith(
                color: style.foreground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(separatorSm),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.close_rounded,
              color: style.foreground.withValues(alpha: kNotificationCloseAlpha),
              size: kNotificationIconSize,
            ),
          ),
        ],
      ),
    );
  }
}
