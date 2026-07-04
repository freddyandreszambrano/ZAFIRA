import '../../../../core/enum/response_status.dart';
import '../../domain/recommend_model.dart';

class RecommendState {
  RecommendState({required this.status, this.result, this.errorMessage});

  factory RecommendState.initial() =>
      RecommendState(status: ResponseStatus.initial);

  final ResponseStatus status;
  final RecommendResponseModel? result;
  final String? errorMessage;

  RecommendState copyWith({
    ResponseStatus? status,
    RecommendResponseModel? result,
    String? errorMessage,
    bool clearError = false,
  }) => RecommendState(
    status: status ?? this.status,
    result: result ?? this.result,
    errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
  );
}
