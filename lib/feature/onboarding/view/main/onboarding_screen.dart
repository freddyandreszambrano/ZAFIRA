import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../modules/common/widget/buttons/app_gradient_button.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../auth/domain/user_model.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../../../home/view/main/home_screen.dart';
import '../../domain/onboarding_step.dart';
import '../controller/onboarding_controller.dart';
import '../state/onboarding_state.dart';
import '../widgets/gender_step.dart';
import '../widgets/onboarding_scaffold.dart';
import '../widgets/size_step.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  static bool isRequired(UserModel? user) =>
      user != null && !user.onboarding.completed;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  late final List<OnboardingStep> _steps;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    final onboarding = user?.onboarding;

    _steps = (onboarding?.forceShow ?? false)
        ? OnboardingStep.values.toList()
        : OnboardingStep.fromFields(onboarding?.pendingSteps ?? const []);

    WidgetsBinding.instance.addPostFrameCallback((_) => _prefill(user));
  }

  void _prefill(UserModel? user) {
    if (user == null) return;

    final controller = ref.read(onboardingControllerProvider.notifier);
    const genders = {'femenino', 'masculino', 'otro'};

    if (genders.contains(user.gender)) {
      controller.setAnswer(OnboardingStep.gender.field, user.gender);
    }
    if (user.preferredSize.isNotEmpty) {
      controller.setAnswer(OnboardingStep.size.field, user.preferredSize);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _animateTo(int index) {
    ref.read(onboardingControllerProvider.notifier).goTo(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void _onBack() {
    final index = ref.read(onboardingControllerProvider).pageIndex;
    if (index > 0) _animateTo(index - 1);
  }

  Future<void> _onContinue() async {
    final index = ref.read(onboardingControllerProvider).pageIndex;

    if (index < _steps.length - 1) {
      _animateTo(index + 1);
      return;
    }

    await ref.read(onboardingControllerProvider.notifier).submit();
    if (!mounted) return;

    final submittedState = ref.read(onboardingControllerProvider);
    if (submittedState.status == ResponseStatus.success) {
      context.go(HomeScreen.routeName);
    } else {
      AppNotification.error(
        context,
        submittedState.errorMessage ?? 'No se pudo guardar tu información.',
      );
    }
  }

  bool _canContinue(OnboardingState state) {
    final step = _steps[state.pageIndex];
    switch (step) {
      case OnboardingStep.gender:
        return (state.answers[step.field] ?? '').isNotEmpty;
      case OnboardingStep.size:
        return state.answers.containsKey(step.field);
    }
  }

  Widget _buildStep(OnboardingStep step, OnboardingState state) {
    final controller = ref.read(onboardingControllerProvider.notifier);
    switch (step) {
      case OnboardingStep.gender:
        return GenderStep(
          value: state.answers[step.field] ?? '',
          onChanged: (value) => controller.setAnswer(step.field, value),
        );
      case OnboardingStep.size:
        return SizeStep(
          value: state.answers[step.field] ?? '',
          answered: state.answers.containsKey(step.field),
          onChanged: (value) => controller.setAnswer(step.field, value),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final isLast = state.pageIndex == _steps.length - 1;
    final isLoading = state.status == ResponseStatus.loading;
    final canContinue = _canContinue(state);

    return OnboardingScaffold(
      stepCount: _steps.length,
      currentIndex: state.pageIndex,
      onBack: state.pageIndex == 0 ? null : _onBack,
      footer: AppGradientButton(
        label: isLast ? 'Finalizar' : 'Continuar',
        isLoading: isLoading,
        enabled: canContinue && !isLoading,
        onPressed: canContinue ? _onContinue : () {},
      ),
      child: PageView.builder(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _steps.length,
        itemBuilder: (context, index) => _buildStep(_steps[index], state),
      ),
    );
  }
}
