import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class AppDarkScaffold extends StatelessWidget {
  const AppDarkScaffold({
    required this.child,
    this.bottomNavigationBar,
    this.extendBody = false,
    this.centerContent = false,
    super.key,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final bool extendBody;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final content = centerContent
        ? Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.responsive<double>(
                  compact: double.infinity,
                  medium: 720,
                  expanded: 960,
                  large: 1080,
                ),
              ),
              child: child,
            ),
          )
        : child;

    return Scaffold(
      extendBody: extendBody,
      backgroundColor: colors.nightDeep,
      bottomNavigationBar: bottomNavigationBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(child: content),
      ),
    );
  }
}

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    this.subtitle,
    this.centerTitle = false,
    this.showBack = false,
    this.trailing,
    this.onBack,
    super.key,
  });

  final String title;
  final String? subtitle;
  final bool centerTitle;
  final bool showBack;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (showBack)
              _HeaderIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack ?? () => context.pop(),
              ),
            if (showBack) const Gap(separatorSm),
            Expanded(
              child: Text(
                title,
                textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.headlineMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (trailing != null) ...[
              const Gap(separatorSm),
              trailing!,
            ] else if (showBack && centerTitle)
              const SizedBox(width: kIconButtonSize),
          ],
        ),
        if (subtitle != null) ...[
          const Gap(separatorXSm),
          Text(
            subtitle!,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: context.typography.bodyMedium?.copyWith(
              color: colors.slate,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}

class AppBrandHeader extends StatelessWidget {
  const AppBrandHeader({
    this.onMenu,
    this.onNotifications,
    this.trailing,
    super.key,
  });

  final VoidCallback? onMenu;
  final VoidCallback? onNotifications;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // Los iconos solo aparecen si tienen acción real: sin menú ni
    // notificaciones implementados, la marca va sola y centrada
    return Row(
      children: [
        if (onMenu != null)
          _HeaderIconButton(icon: Icons.menu_rounded, onTap: onMenu),
        const Spacer(),
        Text(
          'Zafira',
          style: context.typography.titleLarge?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          trailing!
        else if (onNotifications != null)
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotifications,
          ),
      ],
    );
  }
}

class AppGlassCard extends StatelessWidget {
  const AppGlassCard({
    required this.child,
    this.padding,
    this.highlighted = false,
    this.borderColor,
    this.onTap,
    this.minHeight,
    super.key,
  });

  final Widget child;
  final EdgeInsets? padding;
  final bool highlighted;
  final Color? borderColor;
  final VoidCallback? onTap;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final radius = kBorderRadiusAllLarge;

    final card = Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      padding: padding ?? context.cardPadding,
      decoration: BoxDecoration(
        color: colors.nightCard.withValues(alpha: kOpacityCardStrong),
        borderRadius: radius,
        border: Border.all(
          color:
              borderColor ??
              (highlighted
                  ? colors.primaryLight.withValues(alpha: kOpacityBorder)
                  : colors.nightBorder.withValues(alpha: kOpacityStrong)),
          width: highlighted ? kBorderWidthMd : kBorderWidthThin,
        ),
        boxShadow: highlighted ? colors.shadowZafira : null,
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(onTap: onTap, borderRadius: radius, child: card),
    );
  }
}

class AppStateView extends StatelessWidget {
  const AppStateView({
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.loading = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: context.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (loading)
              CircularProgressIndicator(color: colors.primaryLight)
            else
              Icon(
                icon,
                color: colors.primaryLight.withValues(alpha: 0.85),
                size: context.responsive<double>(
                  compact: 52,
                  medium: 64,
                  expanded: 72,
                ),
              ),
            const Gap(separatorMd),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typography.titleMedium?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (message != null) ...[
              const Gap(separatorXSm),
              Text(
                message!,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bodyMedium?.copyWith(
                  color: colors.slate,
                  height: 1.35,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const Gap(separatorLg),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: Icon(Icons.refresh_rounded, color: colors.primaryLight),
                label: Text(actionLabel!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primaryLight,
                  side: BorderSide(
                    color: colors.primaryLight.withValues(alpha: kOpacityHalf),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: kBorderRadiusAllMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppGradientAction extends StatelessWidget {
  const AppGradientAction({
    required this.label,
    required this.onTap,
    this.icon,
    this.loading = false,
    this.outlined = false,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final bool loading;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (loading)
          SizedBox(
            width: kLoaderSize,
            height: kLoaderSize,
            child: CircularProgressIndicator(
              strokeWidth: kLoaderStroke,
              color: colors.white,
            ),
          )
        else if (icon != null)
          Icon(icon, color: colors.white, size: kIconSm),
        if (loading || icon != null) const Gap(separatorSm),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.labelMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );

    return Opacity(
      opacity: loading ? 0.7 : 1,
      child: Material(
        color: Colors.transparent,
        borderRadius: kBorderRadiusAllLarge,
        child: InkWell(
          onTap: loading ? null : onTap,
          borderRadius: kBorderRadiusAllLarge,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: kButtonHeight),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              gradient: outlined ? null : colors.gradientPrimary,
              color: outlined ? colors.nightCard.withValues(alpha: 0.55) : null,
              borderRadius: kBorderRadiusAllLarge,
              border: outlined
                  ? Border.all(
                      color: colors.white.withValues(alpha: kOpacityStrong),
                    )
                  : null,
              boxShadow: outlined ? null : colors.shadowZafira,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox.square(
      dimension: kIconButtonSize,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: colors.white, size: kIconMd),
        style: IconButton.styleFrom(
          backgroundColor: colors.nightCard.withValues(alpha: 0.5),
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllMedium,
          ),
        ),
      ),
    );
  }
}
