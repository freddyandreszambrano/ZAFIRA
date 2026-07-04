import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_info.freezed.dart';
part 'onboarding_info.g.dart';

@freezed
abstract class OnboardingInfo with _$OnboardingInfo {
  const factory OnboardingInfo({
    @Default(false) bool completed,
    @JsonKey(name: 'force_show') @Default(false) bool forceShow,
    @JsonKey(name: 'pending_steps')
    @Default(<String>[])
    List<String> pendingSteps,
  }) = _OnboardingInfo;

  factory OnboardingInfo.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInfoFromJson(json);
}
