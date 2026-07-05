import '../../domain/try_on_job_model.dart';

enum TryOnStatus { initial, creating, generating, success, failure }

class TryOnState {
  TryOnState({required this.status, this.job, this.errorMessage});

  factory TryOnState.initial() => TryOnState(status: TryOnStatus.initial);

  final TryOnStatus status;
  final TryOnJobModel? job;
  final String? errorMessage;

  TryOnState copyWith({
    TryOnStatus? status,
    TryOnJobModel? job,
    String? errorMessage,
  }) => TryOnState(
    status: status ?? this.status,
    job: job ?? this.job,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
