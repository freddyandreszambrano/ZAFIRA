import '../../../../core/enum/response_status.dart';
import '../../domain/product_model.dart';

class CatalogState {
  CatalogState({
    required this.status,
    required this.products,
    this.errorMessage,
  });

  factory CatalogState.initial() => CatalogState(
    status: ResponseStatus.initial,
    products: const [],
    errorMessage: null,
  );

  final ResponseStatus status;
  final List<ProductModel> products;
  final String? errorMessage;

  CatalogState copyWith({
    ResponseStatus? status,
    List<ProductModel>? products,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) =>
      CatalogState(
        status: status ?? this.status,
        products: products ?? this.products,
        errorMessage:
        clearErrorMessage ? null : errorMessage ?? this.errorMessage,
      );
}