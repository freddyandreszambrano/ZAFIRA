import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../catalog/domain/product_model.dart';
import '../interfaces/favorite_interface.dart';
import '../services/favorite_service.dart';

final favoriteRepositoryProvider = Provider<IFavorite>((ref) {
  final remoteDataSource = ref.watch(favoriteServiceProvider);
  return FavoriteRepository(remoteDataSource: remoteDataSource);
});

class FavoriteRepository implements IFavorite {
  FavoriteRepository({required this.remoteDataSource});

  final FavoriteService remoteDataSource;

  @override
  Future<List<ProductModel>> getFavorites() async =>
      await remoteDataSource.getFavorites();

  @override
  Future<bool> addFavorite(int productId) async =>
      await remoteDataSource.addFavorite(productId);

  @override
  Future<bool> removeFavorite(int productId) async =>
      await remoteDataSource.removeFavorite(productId);
}
