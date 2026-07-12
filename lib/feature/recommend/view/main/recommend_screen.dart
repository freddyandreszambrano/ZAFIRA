import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../../../catalog/domain/product_model.dart';
import '../../../try_on/domain/try_on_args.dart';
import '../../../try_on/view/main/try_on_result_screen.dart';
import '../../domain/recommend_model.dart';
import '../controller/recommend_controller.dart';
import '../widgets/no_photo_dialog.dart';
import '../widgets/occasion_filters.dart';
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
  // Filtros de ocasión: los chips escriben la frase en _occasionController,
  // así el resto del flujo (validación + request) no cambia.
  OccasionGroup? _selectedOccasionGroup;
  OccasionOption? _selectedOccasionSub;
  bool _showFreeText = false;
  // Mix & match: el usuario arma su propia combinación eligiendo un torso
  // y una pierna de CUALQUIERA de los 3 outfits recomendados
  ProductModel? _mixTop;
  ProductModel? _mixBottom;

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
      AppNotification.warning(context, 'Elige una ocasión o escríbela');
      return;
    }
    FocusScope.of(context).unfocus();
    // Outfits nuevos = selección vieja sin sentido: limpiarla
    setState(() {
      _mixTop = null;
      _mixBottom = null;
    });
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

  void _selectOccasionGroup(OccasionGroup group) {
    setState(() {
      if (_selectedOccasionGroup == group) {
        // Segundo tap sobre el mismo chip: deseleccionar
        _selectedOccasionGroup = null;
        _selectedOccasionSub = null;
        _occasionController.clear();
      } else {
        _selectedOccasionGroup = group;
        _selectedOccasionSub = null;
        _occasionController.text = group.phrase;
        _showFreeText = false;
      }
    });
  }

  void _selectOccasionSub(OccasionOption sub) {
    setState(() {
      if (_selectedOccasionSub == sub) {
        // Deseleccionar el sub-filtro vuelve a la ocasión general
        _selectedOccasionSub = null;
        _occasionController.text = _selectedOccasionGroup?.phrase ?? '';
      } else {
        _selectedOccasionSub = sub;
        _occasionController.text = sub.phrase;
      }
    });
  }

  void _toggleFreeText() {
    setState(() {
      _showFreeText = !_showFreeText;
      if (_showFreeText) {
        // Texto libre parte limpio, sin arrastrar la frase de los chips
        _selectedOccasionGroup = null;
        _selectedOccasionSub = null;
        _occasionController.clear();
      }
    });
  }

  void _selectMixPiece(ProductModel product, bool isTop) {
    setState(() {
      if (isTop) {
        // Tocar la prenda ya elegida la quita; otra distinta la reemplaza
        _mixTop = _mixTop?.id == product.id ? null : product;
      } else {
        _mixBottom = _mixBottom?.id == product.id ? null : product;
      }
    });
  }

  void _tryOnMix() {
    final user = ref.read(authControllerProvider).user;
    if (user == null || user.tryOnPhoto.isEmpty) {
      NoPhotoDialog.show(context);
      return;
    }
    final top = _mixTop;
    final bottom = _mixBottom;
    if (top != null && bottom != null) {
      // Par completo: outfit editable (se puede guardar y cambiar prendas)
      context.push(
        TryOnResultScreen.routeName,
        extra: TryOnOutfitArgs(
          upperId: top.id,
          lowerId: bottom.id,
          catalogGender: _selectedGender == 'mujer' ? 'woman' : 'man',
        ),
      );
      return;
    }
    final single = top ?? bottom;
    if (single != null) {
      context.push(TryOnResultScreen.routeName, extra: [single.id]);
    }
  }

  void _tryOnOutfit(OutfitModel outfit) {
    final user = ref.read(authControllerProvider).user;
    if (user == null || user.tryOnPhoto.isEmpty) {
      NoPhotoDialog.show(context);
      return;
    }
    // Outfit de 2 prendas: modo editable (se puede guardar en favoritos y
    // cambiar torso/pierna). Vestido solo: prueba simple de 1 prenda.
    if (outfit.bottom != null) {
      context.push(
        TryOnResultScreen.routeName,
        extra: TryOnOutfitArgs(
          upperId: outfit.top.id,
          lowerId: outfit.bottom!.id,
          catalogGender: _selectedGender == 'mujer' ? 'woman' : 'man',
        ),
      );
      return;
    }
    context.push(TryOnResultScreen.routeName, extra: outfit.productIds);
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
            selectedOccasionGroup: _selectedOccasionGroup,
            selectedOccasionSub: _selectedOccasionSub,
            showFreeText: _showFreeText,
            onStoreChanged: (v) => setState(() => _selectedStore = v!),
            onGenderChanged: (v) => setState(() => _selectedGender = v),
            onOccasionGroupTap: _selectOccasionGroup,
            onOccasionSubTap: _selectOccasionSub,
            onToggleFreeText: _toggleFreeText,
            onRecommend: () => _recommend(),
            isLoading: state.status == ResponseStatus.loading,
            isFavoritesMode: widget.favoriteIds != null,
          ),
          Expanded(
            child: ResultPanel(
              state: state,
              onRefresh: () => _recommend(refresh: true),
              onTryOn: _tryOnOutfit,
              mixTop: _mixTop,
              mixBottom: _mixBottom,
              onSelectPiece: _selectMixPiece,
              onTryOnMix: _tryOnMix,
              onClearMix: () => setState(() {
                _mixTop = null;
                _mixBottom = null;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
