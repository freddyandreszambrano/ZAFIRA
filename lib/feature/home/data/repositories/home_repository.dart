import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/product_model.dart';
import '../interfaces/home_interface.dart';
import '../services/home_service.dart';

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  final service = ref.watch(homeServiceProvider);
  return HomeRepository(service: service);
});

class HomeRepository implements IHomeRepository {
  HomeRepository({required this.service});

  final HomeService service;

  @override
  Future<List<ProductModel>> getDashboardProducts() =>
      service.getDashboardProducts();
}
