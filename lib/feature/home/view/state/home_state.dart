import '../../../../core/enum/response_status.dart';
import '../../../../core/models/product_model.dart';

class HomeState {
  const HomeState({
    required this.status,
    required this.recentProducts,
    required this.featuredProducts,
    this.errorMessage,
  });

  factory HomeState.initial() => const HomeState(
    status: ResponseStatus.initial,
    recentProducts: [],
    featuredProducts: [],
  );

  final ResponseStatus status;
  final List<ProductModel> recentProducts;
  final List<ProductModel> featuredProducts;
  final String? errorMessage;

  HomeState copyWith({
    ResponseStatus? status,
    List<ProductModel>? recentProducts,
    List<ProductModel>? featuredProducts,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) => HomeState(
    status: status ?? this.status,
    recentProducts: recentProducts ?? this.recentProducts,
    featuredProducts: featuredProducts ?? this.featuredProducts,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
  );
}
