import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../catalog/domain/product_model.dart';
import '../../application/favorite_usecase.dart';
import '../../data/repositories/favorite_repository.dart';
import '../state/favorite_state.dart';

final favoriteControllerProvider =
    StateNotifierProvider<FavoriteController, FavoriteState>((ref) {
      final favoriteRepository = ref.watch(favoriteRepositoryProvider);

      return FavoriteController(FavoriteUseCase(favoriteRepository));
    });

class FavoriteController extends StateNotifier<FavoriteState> {
  FavoriteController(this._favoriteUseCase) : super(FavoriteState.initial());

  final FavoriteUseCase _favoriteUseCase;

  bool isFavorite(int productId) => state.favoriteIds.contains(productId);

  void syncFromProducts(List<ProductModel> products) {
    final updatedIds = Set<int>.from(state.favoriteIds);
    for (final product in products) {
      if (product.isFavorite) {
        updatedIds.add(product.id);
      }
    }
    if (updatedIds.length != state.favoriteIds.length) {
      state = state.copyWith(favoriteIds: updatedIds);
    }
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(
      status: ResponseStatus.loading,
      clearErrorMessage: true,
    );

    final response = await _favoriteUseCase.getFavorites();

    response.fold(
      (err) {
        state = state.copyWith(
          status: ResponseStatus.error,
          errorMessage: 'No se pudieron cargar tus favoritos.',
        );
      },
      (products) {
        state = state.copyWith(
          status: ResponseStatus.success,
          products: products,
          favoriteIds: products.map((product) => product.id).toSet(),
        );
      },
    );
  }

  Future<bool> toggleFavorite(ProductModel product) async {
    final wasFavorite = state.favoriteIds.contains(product.id);

    final updatedIds = Set<int>.from(state.favoriteIds);
    final updatedProducts = List<ProductModel>.from(state.products);

    if (wasFavorite) {
      updatedIds.remove(product.id);
      updatedProducts.removeWhere((item) => item.id == product.id);
    } else {
      updatedIds.add(product.id);
      updatedProducts.insert(0, product.copyWith(isFavorite: true));
    }

    state = state.copyWith(favoriteIds: updatedIds, products: updatedProducts);

    final response = wasFavorite
        ? await _favoriteUseCase.removeFavorite(product.id)
        : await _favoriteUseCase.addFavorite(product.id);

    return response.fold((err) {
      final revertedIds = Set<int>.from(state.favoriteIds);
      final revertedProducts = List<ProductModel>.from(state.products);

      if (wasFavorite) {
        revertedIds.add(product.id);
        revertedProducts.insert(0, product.copyWith(isFavorite: true));
      } else {
        revertedIds.remove(product.id);
        revertedProducts.removeWhere((item) => item.id == product.id);
      }

      state = state.copyWith(
        favoriteIds: revertedIds,
        products: revertedProducts,
      );
      return false;
    }, (_) => true);
  }
}
