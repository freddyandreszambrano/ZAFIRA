import '../../../../core/enum/response_status.dart';
import '../../../catalog/domain/product_model.dart';
import '../../domain/favorite_outfit_model.dart';

class FavoriteState {
  FavoriteState({
    required this.status,
    required this.products,
    required this.favoriteIds,
    required this.outfits,
    this.errorMessage,
  });

  factory FavoriteState.initial() => FavoriteState(
    status: ResponseStatus.initial,
    products: const [],
    favoriteIds: const {},
    outfits: const [],
    errorMessage: null,
  );

  final ResponseStatus status;
  final List<ProductModel> products;
  final Set<int> favoriteIds;
  final List<FavoriteOutfitModel> outfits;
  final String? errorMessage;

  FavoriteState copyWith({
    ResponseStatus? status,
    List<ProductModel>? products,
    Set<int>? favoriteIds,
    List<FavoriteOutfitModel>? outfits,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => FavoriteState(
    status: status ?? this.status,
    products: products ?? this.products,
    favoriteIds: favoriteIds ?? this.favoriteIds,
    outfits: outfits ?? this.outfits,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}
