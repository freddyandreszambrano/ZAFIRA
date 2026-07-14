import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../application/catalog_usecase.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../../../core/models/product_model.dart';
import '../state/catalog_state.dart';

final catalogControllerProvider =
    StateNotifierProvider.autoDispose<CatalogController, CatalogState>((ref) {
      final catalogRepository = ref.watch(catalogRepositoryProvider);

      return CatalogController(CatalogUseCase(catalogRepository));
    });

class CatalogController extends StateNotifier<CatalogState> {
  CatalogController(this._catalogUseCase) : super(CatalogState.initial());

  final CatalogUseCase _catalogUseCase;

  /// Tamaño de página: la primera respuesta llega liviana y al instante;
  /// el resto se trae con scroll infinito (loadMoreProducts).
  static const pageSize = 24;

  // Filtros de la categoría en pantalla (los usa loadMoreProducts)
  String? _gender;
  String? _category;

  Future<void> getProducts({String? gender, String? category}) async {
    _gender = gender;
    _category = category;
    state = state.copyWith(
      status: ResponseStatus.loading,
      clearErrorMessage: true,
    );

    final response = await _catalogUseCase.getProducts(
      gender: gender,
      category: category,
      limit: pageSize,
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
          hasMore: products.length == pageSize,
          loadingMore: false,
        );
      },
    );
  }

  /// Página siguiente de la categoría actual (scroll infinito).
  Future<void> loadMoreProducts() async {
    if (!state.hasMore || state.loadingMore) return;
    state = state.copyWith(loadingMore: true);

    final response = await _catalogUseCase.getProducts(
      gender: _gender,
      category: _category,
      limit: pageSize,
      offset: state.products.length,
    );

    response.fold(
      (err) {
        // Falló la página extra: no romper lo ya mostrado, permitir reintento
        state = state.copyWith(loadingMore: false);
      },
      (products) {
        state = state.copyWith(
          products: [...state.products, ...products],
          hasMore: products.length == pageSize,
          loadingMore: false,
        );
      },
    );
  }

  Future<String?> getCategoryThumbnail({
    required String gender,
    required String category,
  }) async {
    // Solo se necesita la primera imagen: pedir 1 producto, no toda la lista
    final response = await _catalogUseCase.getProducts(
      gender: gender,
      category: category,
      limit: 1,
    );

    return response.fold(
      (err) => null,
      (products) => products.isNotEmpty ? products.first.firstImageUrl : null,
    );
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    // El home muestra unos pocos destacados: no descargar el catálogo entero
    final response = await _catalogUseCase.getProducts(limit: 12);

    return response.fold((err) => [], (products) => products);
  }

  Future<ProductModel?> getProductById(int id) async {
    final response = await _catalogUseCase.getProductById(id);

    return response.fold((err) => null, (product) => product);
  }

  Future<ProductModel?> getLiveProduct(int id) async {
    final response = await _catalogUseCase.getLiveProduct(id);

    return response.fold((err) => null, (product) => product);
  }
}
