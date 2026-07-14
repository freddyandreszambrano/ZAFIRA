import '../../../../core/enum/response_status.dart';
import '../../../../core/models/product_model.dart';

class CatalogState {
  CatalogState({
    required this.status,
    required this.products,
    this.hasMore = false,
    this.loadingMore = false,
    this.errorMessage,
  });

  factory CatalogState.initial() => CatalogState(
    status: ResponseStatus.initial,
    products: const [],
    errorMessage: null,
  );

  final ResponseStatus status;
  final List<ProductModel> products;

  /// Paginación: quedan más prendas por cargar en la categoría actual.
  final bool hasMore;
  final bool loadingMore;
  final String? errorMessage;

  CatalogState copyWith({
    ResponseStatus? status,
    List<ProductModel>? products,
    bool? hasMore,
    bool? loadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => CatalogState(
    status: status ?? this.status,
    products: products ?? this.products,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}
