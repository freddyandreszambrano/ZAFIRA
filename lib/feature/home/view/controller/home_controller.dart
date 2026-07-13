import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../application/home_usecase.dart';
import '../state/home_state.dart';

final homeControllerProvider =
    StateNotifierProvider.autoDispose<HomeController, HomeState>((ref) {
      final useCase = ref.watch(homeUseCaseProvider);
      return HomeController(useCase);
    });

class HomeController extends StateNotifier<HomeState> {
  HomeController(this._homeUseCase) : super(HomeState.initial());

  final HomeUseCase _homeUseCase;

  Future<void> loadDashboardProducts() async {
    state = state.copyWith(
      status: ResponseStatus.loading,
      clearErrorMessage: true,
    );

    final response = await _homeUseCase.getDashboardProducts();

    response.fold(
      (_) => state = state.copyWith(
        status: ResponseStatus.error,
        errorMessage: 'No se pudieron cargar las prendas destacadas.',
      ),
      (dashboard) {
        state = state.copyWith(
          status: ResponseStatus.success,
          recentProducts: dashboard.recentProducts,
          featuredProducts: dashboard.featuredProducts,
        );
      },
    );
  }
}
