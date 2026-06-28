import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../application/catalog_usecase.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../domain/product_model.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    StateNotifierProvider<CatalogController, CatalogState>((ref) {
      final catalogRepository = ref.watch(catalogRepositoryProvider);

      return CatalogController(CatalogUseCase(catalogRepository));
    });

class CatalogController extends StateNotifier<CatalogState> {
  CatalogController(this._catalogUseCase) : super(CatalogState.initial());

  final CatalogUseCase _catalogUseCase;

  Future<void> getProducts({String? gender, String? category}) async {
    state = state.copyWith(
      status: ResponseStatus.loading,
      clearErrorMessage: true,
    );

    final response = await _catalogUseCase.getProducts(
      gender: gender,
      category: category,
    );

    response.fold(
      (err) {
        state = state.copyWith(
          status: ResponseStatus.error,
          errorMessage: 'No se pudieron cargar las prendas.',
        );
      },
      (products) {
        state = state.copyWith(
          status: ResponseStatus.success,
          products: products,
        );
      },
    );
  }

  Future<String?> getCategoryThumbnail({
    required String gender,
    required String category,
  }) async {
    final response = await _catalogUseCase.getProducts(
      gender: gender,
      category: category,
    );

    return response.fold(
      (err) => null,
      (products) => products.isNotEmpty ? products.first.firstImageUrl : null,
    );
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    final response = await _catalogUseCase.getProducts();

    return response.fold((err) => [], (products) => products);
  }

  Future<ProductModel?> getProductById(int id) async {
    final response = await _catalogUseCase.getProductById(id);

    return response.fold((err) => null, (product) => product);
  }
}
