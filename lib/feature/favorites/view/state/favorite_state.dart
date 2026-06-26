import '../../../../core/enum/response_status.dart';
import '../../../catalog/domain/product_model.dart';

class FavoriteState {
  FavoriteState({
    required this.status,
    required this.products,
    required this.favoriteIds,
    this.errorMessage,
  });

  factory FavoriteState.initial() => FavoriteState(
        status: ResponseStatus.initial,
        products: const [],
        favoriteIds: const {},
        errorMessage: null,
      );

  final ResponseStatus status;
  final List<ProductModel> products;
  final Set<int> favoriteIds;
  final String? errorMessage;

  FavoriteState copyWith({
    ResponseStatus? status,
    List<ProductModel>? products,
    Set<int>? favoriteIds,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) =>
      FavoriteState(
        status: status ?? this.status,
        products: products ?? this.products,
        favoriteIds: favoriteIds ?? this.favoriteIds,
        errorMessage:
            clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      );
}
