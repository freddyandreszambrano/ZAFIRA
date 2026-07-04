import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../controller/recommend_controller.dart';
import '../widgets/no_photo_dialog.dart';
import '../widgets/result_panel.dart';
import '../widgets/search_panel.dart';

class RecommendScreen extends ConsumerStatefulWidget {
  const RecommendScreen({this.favoriteIds, super.key});

  static const routeName = '/recommend';

  /// Si viene, genera outfits SOLO con estas prendas (modo favoritos).
  final List<int>? favoriteIds;

  @override
  ConsumerState<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends ConsumerState<RecommendScreen> {
  final _occasionController = TextEditingController();
  String _selectedStore = 'all';
  String _selectedGender = 'hombre';

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    if (user != null && user.gender.isNotEmpty) {
      final g = user.gender.toLowerCase();
      if (g.contains('f') || g.contains('mujer') || g == 'female') {
        _selectedGender = 'mujer';
      }
    }
  }

  @override
  void dispose() {
    _occasionController.dispose();
    super.dispose();
  }

  List<int> get _currentBatchIds =>
      ref.read(recommendControllerProvider).result?.allProductIds ?? [];

  void _recommend({bool refresh = false}) {
    // Evitar doble tap mientras carga
    final state = ref.read(recommendControllerProvider);
    if (state.status == ResponseStatus.loading) return;

    final occasion = _occasionController.text.trim();
    if (occasion.isEmpty) {
      AppNotification.warning(context, 'Escribe la ocasión para el outfit');
      return;
    }
    FocusScope.of(context).unfocus();
    ref
        .read(recommendControllerProvider.notifier)
        .getRecommendation(
          occasion: occasion,
          store: _selectedStore,
          gender: _selectedGender,
          // Solo excluimos el batch actual (6 IDs), no acumulamos histórico
          excludeIds: refresh ? _currentBatchIds : [],
          productIds: widget.favoriteIds ?? [],
        );
  }

  void _tryOnOutfit() {
    final user = ref.read(authControllerProvider).user;
    if (user == null || user.tryOnPhoto.isEmpty) {
      NoPhotoDialog.show(context);
      return;
    }
    AppNotification.info(context, 'Función de prueba virtual próximamente');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = ref.watch(recommendControllerProvider);

    return Scaffold(
      backgroundColor: colors.nightDeep,
      appBar: AppBar(
        backgroundColor: colors.nightDeep,
        elevation: 0,
        title: Text(
          widget.favoriteIds != null
              ? 'Outfits con tus favoritos'
              : 'Recomendación de Outfit',
          style: context.typography.titleSmall?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          SearchPanel(
            controller: _occasionController,
            selectedStore: _selectedStore,
            selectedGender: _selectedGender,
            onStoreChanged: (v) => setState(() => _selectedStore = v!),
            onGenderChanged: (v) => setState(() => _selectedGender = v),
            onRecommend: () => _recommend(),
            isLoading: state.status == ResponseStatus.loading,
            isFavoritesMode: widget.favoriteIds != null,
          ),
          Expanded(
            child: ResultPanel(
              state: state,
              onRefresh: () => _recommend(refresh: true),
              onTryOn: _tryOnOutfit,
            ),
          ),
        ],
      ),
    );
  }
}
