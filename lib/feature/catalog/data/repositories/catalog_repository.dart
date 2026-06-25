import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/product_model.dart';
import '../interfaces/catalog_interface.dart';
import '../services/catalog_service.dart';

final catalogRepositoryProvider = Provider<ICatalog>((ref) {
  final remoteDataSource = ref.watch(catalogServiceProvider);
  return CatalogRepository(remoteDataSource: remoteDataSource);
});

class CatalogRepository implements ICatalog {
  CatalogRepository({required this.remoteDataSource});

  final CatalogService remoteDataSource;

  @override
  Future<List<ProductModel>> getProducts({
    required String gender,
    required String category,
  }) async =>
      await remoteDataSource.getProducts(gender: gender, category: category);

  @override
  Future<ProductModel> getProductById(int id) async =>
      await remoteDataSource.getProductById(id);
}
