import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product_model.dart';
import '../../domain/favorite_outfit_model.dart';
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

  @override
  Future<List<FavoriteOutfitModel>> getFavoriteOutfits() async =>
      await remoteDataSource.getFavoriteOutfits();

  @override
  Future<bool> saveFavoriteOutfit({
    required int topId,
    required int bottomId,
    required String resultImageUrl,
  }) async => await remoteDataSource.saveFavoriteOutfit(
    topId: topId,
    bottomId: bottomId,
    resultImageUrl: resultImageUrl,
  );

  @override
  Future<bool> removeFavoriteOutfit(int outfitId) async =>
      await remoteDataSource.removeFavoriteOutfit(outfitId);
}
