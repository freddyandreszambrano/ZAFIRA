import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/context_helper.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.stepCount,
    required this.currentIndex,
    required this.onBack,
    required this.child,
    required this.footer,
    super.key,
  });

  final int stepCount;
  final int currentIndex;
  final VoidCallback? onBack;
  final Widget child;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Padding(
            padding: kSpaceDeviceHLg,
            child: Column(
              children: [
                const Gap(separatorMd),
                Row(
                  children: [
                    _BackButton(onBack: onBack),
                    const Gap(separatorSm),
                    Expanded(
                      child: _OnboardingProgress(
                        stepCount: stepCount,
                        currentIndex: currentIndex,
                      ),
                    ),
                    const SizedBox(width: kIconButtonSize),
                  ],
                ),
                const Gap(separatorXLg),
                Expanded(child: child),
                const Gap(separatorLg),
                footer,
                const Gap(separatorLg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    if (onBack == null) return const SizedBox(width: kIconButtonSize);

    return IconButton(
      onPressed: onBack,
      icon: Icon(Icons.arrow_back_rounded, color: context.appColors.white),
    );
  }
}

class _OnboardingProgress extends StatelessWidget {
  const _OnboardingProgress({required this.stepCount, required this.currentIndex});

  final int stepCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stepCount, (index) {
        final active = index <= currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: active ? 28 : 12,
          decoration: BoxDecoration(
            gradient: active ? colors.gradientPrimary : null,
            color: active ? null : colors.nightBorder,
            borderRadius: BorderRadius.circular(kRadiusXSm),
          ),
        );
      }),
    );
  }
}
