import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/app_colors.dart';
import '../../../../core/helpers/context_helper.dart';
import '../controller/try_on_controller.dart';
import '../state/try_on_state.dart';

class TryOnResultScreen extends ConsumerStatefulWidget {
  const TryOnResultScreen({super.key, required this.productId});

  static const routeName = '/try-on/result';

  final int productId;

  @override
  ConsumerState<TryOnResultScreen> createState() => _TryOnResultScreenState();
}

class _TryOnResultScreenState extends ConsumerState<TryOnResultScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(tryOnControllerProvider.notifier)
          .startTryOn(widget.productId),
    );
  }

  void _retry() {
    ref.read(tryOnControllerProvider.notifier).startTryOn(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = ref.watch(tryOnControllerProvider);

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
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Probador virtual',
                        textAlign: TextAlign.center,
                        style: context.typography.titleMedium?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Gap(separatorLg),
                Expanded(child: _buildBody(state, colors)),
                const Gap(separatorMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TryOnState state, AppColors colors) {
    switch (state.status) {
      case TryOnStatus.initial:
      case TryOnStatus.creating:
      case TryOnStatus.generating:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primaryLight),
            const Gap(separatorLg),
            Text(
              'Probando tu prenda…',
              style: context.typography.titleMedium?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Gap(separatorXSm),
            Text(
              'La IA está generando tu imagen. Esto puede tardar unos segundos.',
              textAlign: TextAlign.center,
              style: context.typography.bodySmall?.copyWith(
                color: colors.slate,
              ),
            ),
          ],
        );
      case TryOnStatus.success:
        return Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: kBorderRadiusAllXLarge,
                child: Image.network(
                  state.job?.resultUrl ?? '',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) => progress == null
                      ? child
                      : Center(
                          child: CircularProgressIndicator(
                            color: colors.primaryLight,
                          ),
                        ),
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: colors.slate,
                      size: 54,
                    ),
                  ),
                ),
              ),
            ),
            const Gap(separatorLg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: colors.white.withValues(alpha: 0.7)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: kBorderRadiusAllLarge,
                  ),
                ),
                icon: Icon(Icons.checkroom_rounded, color: colors.white),
                label: Text(
                  'Probar otra prenda',
                  style: context.typography.labelLarge?.copyWith(
                    color: colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        );
      case TryOnStatus.failure:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: colors.error, size: 54),
            const Gap(separatorMd),
            Text(
              state.errorMessage ?? 'No pudimos generar tu prueba virtual.',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.white,
                height: 1.4,
              ),
            ),
            const Gap(separatorLg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: colors.gradientPrimary,
                  borderRadius: kBorderRadiusAllLarge,
                ),
                child: ElevatedButton.icon(
                  onPressed: _retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kBorderRadiusAllLarge,
                    ),
                  ),
                  icon: Icon(Icons.refresh_rounded, color: colors.nightDeep),
                  label: Text(
                    'Reintentar',
                    style: context.typography.labelLarge?.copyWith(
                      color: colors.nightDeep,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}
