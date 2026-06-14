import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/enum/connection_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../controller/connection_controller.dart';
import '../states/network_state.dart';

class OnlineWidget extends ConsumerStatefulWidget {
  const OnlineWidget({super.key});

  @override
  ConsumerState<OnlineWidget> createState() => _OnlineWidgetState();
}

class _OnlineWidgetState extends ConsumerState<OnlineWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  NetworkState? _offline;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(connectionControllerProvider.notifier).checkConnection();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<NetworkState>(connectionControllerProvider, (last, current) {
      if (!mounted) return;
      if (current.newState == ConnectionStatus.disconnected) {
        setState(() => _offline = current);
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    final offline = _offline;
    if (offline == null) return const SizedBox.shrink();

    final style = _styleFor(context, offline);
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          color: style.background,
          padding: kSpaceDeviceVSm,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                offline.message ?? '',
                style: context.typography.labelMedium?.copyWith(
                  color: style.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Gap(separatorSm),
              Icon(style.icon, color: style.foreground, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  _BannerStyle _styleFor(BuildContext context, NetworkState state) {
    final colors = context.appColors;
    final result = state.result ?? const [];
    final hasInterface = result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);

    if (hasInterface) {
      return _BannerStyle(
        background: colors.warning,
        foreground: colors.onWarning,
        icon: Icons.sync_problem_rounded,
      );
    }
    return _BannerStyle(
      background: colors.error,
      foreground: colors.onError,
      icon: Icons.wifi_off_rounded,
    );
  }
}

class _BannerStyle {
  const _BannerStyle({
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final Color background;
  final Color foreground;
  final IconData icon;
}
