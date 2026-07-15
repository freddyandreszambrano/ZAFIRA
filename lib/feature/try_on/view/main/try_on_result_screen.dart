import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_numbers.dart';
import '../../../../core/helpers/app_colors.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../../modules/common/widget/notifications/app_notification.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../../../catalog/data/repositories/catalog_repository.dart';
import '../../../../core/models/product_model.dart';
import '../../../catalog/view/main/catalog_garments_screen.dart';
import '../../../favorites/view/controller/favorite_controller.dart';
import '../../../home/view/main/home_screen.dart';
import '../../domain/try_on_args.dart';
import '../controller/try_on_controller.dart';
import '../state/try_on_state.dart';

class TryOnResultScreen extends ConsumerStatefulWidget {
  const TryOnResultScreen({
    super.key,
    required this.productIds,
    this.sourceProduct,
    this.outfitArgs,
  });

  static const routeName = '/try-on/result';

  /// 1 producto = prenda individual · 2 productos = outfit (torso + piernas)
  final List<int> productIds;

  /// Producto probado cuando la prueba viene del detalle (1 prenda);
  /// habilita "Complementa tu outfit".
  final ProductModel? sourceProduct;

  /// Outfit combinado editable (viene de "complementa/combinar"); habilita
  /// "Combinar otra prenda" para cambiar el torso o la pierna del look.
  final TryOnOutfitArgs? outfitArgs;

  @override
  ConsumerState<TryOnResultScreen> createState() => _TryOnResultScreenState();
}

class _TryOnResultScreenState extends ConsumerState<TryOnResultScreen> {
  // El corazón del header guarda el outfit UNA vez por imagen generada
  bool _outfitSaved = false;

  // Prendas del resultado (nombre + precio) para la ficha de compra. Se
  // cargan en paralelo con la generación, así no añaden espera percibida.
  List<ProductModel> _garments = [];

  // Mensajes por etapas mientras genera: una espera con progreso visible se
  // percibe mucho más corta que un texto estático
  static const _loadingStages = [
    'Analizando tu foto…',
    'Extrayendo la prenda…',
    'Vistiendo a tu modelo…',
    'Afinando los detalles…',
  ];
  int _stageIndex = 0;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _startLoadingStages();
    _loadGarments();
    Future.microtask(
      () => ref
          .read(tryOnControllerProvider.notifier)
          .startTryOn(widget.productIds),
    );
  }

  /// Carga las prendas probadas para la ficha de resultado. Usa el producto
  /// de origen si ya lo tenemos; si no, las trae por id (en paralelo).
  Future<void> _loadGarments() async {
    if (widget.sourceProduct != null) {
      setState(() => _garments = [widget.sourceProduct!]);
      return;
    }
    if (widget.productIds.isEmpty) return;
    try {
      final repository = ref.read(catalogRepositoryProvider);
      final loaded = await Future.wait(
        widget.productIds.map(repository.getProductById),
      );
      if (mounted) setState(() => _garments = loaded);
    } catch (_) {
      // Sin datos, la ficha simplemente no aparece; el resultado se ve igual
    }
  }

  double get _totalPrice =>
      _garments.fold(0, (sum, product) => sum + product.price);

  /// Comprar desde la ficha del resultado: outfit → panel con las 2 prendas;
  /// prenda individual → directo a la tienda.
  void _buyFromResult() {
    if (_garments.length >= 2) {
      _showBuySheet(_garments);
    } else if (_garments.isNotEmpty) {
      _openStore(_garments.first.url);
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    super.dispose();
  }

  void _startLoadingStages() {
    _stageTimer?.cancel();
    _stageIndex = 0;
    _stageTimer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (!mounted || _stageIndex >= _loadingStages.length - 1) {
        timer.cancel();
        return;
      }
      setState(() => _stageIndex++);
    });
  }

  void _retry() {
    // Nueva generación = nueva imagen: el outfit se puede volver a guardar
    setState(() => _outfitSaved = false);
    _startLoadingStages();
    ref.read(tryOnControllerProvider.notifier).startTryOn(widget.productIds);
  }

  /// El corazón guarda TODO lo que el usuario probó: una prenda individual va
  /// a favoritos de prendas; un outfit (2 prendas) va a favoritos de outfits
  /// con la imagen ya generada.
  Future<void> _saveResult() async {
    if (_garments.isEmpty) return;

    if (_garments.length >= 2) {
      if (_outfitSaved) return;
      final resultUrl = ref.read(tryOnControllerProvider).job?.resultUrl ?? '';
      final saved = await ref
          .read(favoriteControllerProvider.notifier)
          .saveOutfit(
            topId: _garments[0].id,
            bottomId: _garments[1].id,
            resultImageUrl: resultUrl,
          );
      if (!mounted) return;
      if (saved) {
        setState(() => _outfitSaved = true);
        AppNotification.success(context, 'Outfit guardado en favoritos.');
      } else {
        AppNotification.warning(context, 'No se pudo guardar el outfit.');
      }
      return;
    }

    // Prenda individual: alterna el favorito (igual que el corazón del catálogo)
    final product = _garments.first;
    final wasFavorite = ref
        .read(favoriteControllerProvider)
        .favoriteIds
        .contains(product.id);
    final ok = await ref
        .read(favoriteControllerProvider.notifier)
        .toggleFavorite(product);
    if (!mounted) return;
    if (ok) {
      AppNotification.success(
        context,
        wasFavorite
            ? 'Se quitó de tus favoritos.'
            : 'Prenda guardada en favoritos.',
      );
    } else {
      AppNotification.warning(context, 'No se pudo guardar la prenda.');
    }
  }

  /// Género del catálogo para complementar/combinar: manda el DETECTADO EN
  /// LA FOTO por la IA (photo_gender); luego el perfil; y solo sin datos, el
  /// género de la prenda probada. Así el sistema viste a quien aparece en la
  /// imagen, sin importar lo que diga la cuenta.
  String get _catalogGender {
    final user = ref.read(authControllerProvider).user;
    final userGender = preferredCatalogGender(user?.photoGender, user?.gender);
    if (userGender != null) return userGender;
    final product = widget.sourceProduct;
    if (product != null) return catalogGenderFor(product);
    return widget.outfitArgs?.catalogGender ?? 'man';
  }

  /// Categorías para completar el look (vacío si no aplica: outfit de 2
  /// prendas, vestido, o prueba sin producto de origen).
  List<ComplementCategory> get _complementCategories {
    final product = widget.sourceProduct;
    if (product == null || widget.productIds.length != 1) return const [];
    return complementCategoriesFor(garmentSlotFor(product), _catalogGender);
  }

  Future<void> _openStore(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        AppNotification.info(
          context,
          'No se pudo abrir el enlace de la tienda.',
        );
      }
    }
  }

  void _showBuySheet(List<ProductModel> products) {
    final colors = context.appColors;
    final total = products.fold<double>(0, (sum, p) => sum + p.price);

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.nightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Comprar las prendas',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(12),
              for (final product in products) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.nightInput,
                    borderRadius: kBorderRadiusAllLarge,
                    border: Border.all(color: colors.nightBorder),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.typography.labelMedium?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Gap(2),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: context.typography.labelSmall?.copyWith(
                                color: colors.primaryLight,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(10),
                      OutlinedButton(
                        onPressed: () => _openStore(product.url),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.primaryLight,
                          side: BorderSide(
                            color: colors.primary.withValues(alpha: 0.4),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: kBorderRadiusAllMedium,
                          ),
                        ),
                        child: Text(
                          'Comprar',
                          style: context.typography.labelSmall?.copyWith(
                            color: colors.primaryLight,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
              ],
              if (products.length > 1)
                Row(
                  children: [
                    Text(
                      'Total',
                      style: context.typography.labelMedium?.copyWith(
                        color: colors.slate,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: context.typography.titleSmall?.copyWith(
                        color: colors.primaryLight,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Ficha bajo el resultado: nombre(s) de la prenda + acceso a comprar.
  Widget _resultInfoCard(AppColors colors) {
    final names = _garments.map((product) => product.name).join(' + ');
    final subtitle = _garments.length >= 2
        ? 'Outfit completo · ${_garments.length} prendas'
        : 'Prenda individual';

    return InkWell(
      onTap: _buyFromResult,
      borderRadius: kBorderRadiusAllLarge,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.nightCard,
          borderRadius: kBorderRadiusAllLarge,
          border: Border.all(color: colors.nightBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    names,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.typography.labelMedium?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(2),
                  Text(
                    subtitle,
                    style: context.typography.labelSmall?.copyWith(
                      color: colors.slate,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Text(
              'Comprar',
              style: context.typography.labelMedium?.copyWith(
                color: colors.primaryLight,
                fontWeight: FontWeight.w700,
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.primaryLight,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _primaryAction(
    AppColors colors, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.gradientPrimary,
          borderRadius: kBorderRadiusAllLarge,
        ),
        child: ElevatedButton.icon(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: kBorderRadiusAllLarge,
            ),
          ),
          icon: Icon(icon, color: colors.white),
          label: Text(
            label,
            style: context.typography.labelLarge?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _outlineAction(
    AppColors colors, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          side: BorderSide(color: colors.white.withValues(alpha: 0.7)),
          shape: const RoundedRectangleBorder(
            borderRadius: kBorderRadiusAllLarge,
          ),
        ),
        icon: Icon(icon, color: colors.white),
        label: Text(
          label,
          style: context.typography.labelLarge?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  /// Panel para cambiar UNA prenda del outfit combinado conservando la otra:
  /// reutiliza el flujo de complemento con la prenda que se queda como base.
  void _openSwapSheet() {
    final outfit = widget.outfitArgs!;
    final colors = context.appColors;
    final catalogGender = _catalogGender;
    final upperCategories = complementCategoriesFor(
      GarmentSlot.lower, // se queda la pierna → ofrecer categorías de torso
      catalogGender,
    );
    final lowerCategories = complementCategoriesFor(
      GarmentSlot.upper, // se queda el torso → ofrecer categorías de pierna
      catalogGender,
    );

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.nightCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Deseas combinar otra prenda?',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(6),
              Text(
                'Elige qué parte del outfit quieres cambiar; la otra se queda.',
                style: context.typography.bodySmall?.copyWith(
                  color: colors.slate,
                ),
              ),
              const Gap(16),
              _swapSection(
                sheetContext,
                title: 'Cambiar la parte de arriba',
                categories: upperCategories,
                keepId: outfit.lowerId,
                keepIsUpper: false,
              ),
              const Gap(14),
              _swapSection(
                sheetContext,
                title: 'Cambiar la parte de abajo',
                categories: lowerCategories,
                keepId: outfit.upperId,
                keepIsUpper: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swapSection(
    BuildContext sheetContext, {
    required String title,
    required List<ComplementCategory> categories,
    required int keepId,
    required bool keepIsUpper,
  }) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.typography.labelMedium?.copyWith(
            color: colors.primaryLight,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Gap(8),
        for (final category in categories) ...[
          ListTile(
            onTap: () {
              Navigator.of(sheetContext).pop();
              context.push(
                CatalogGarmentsScreen.routeName,
                extra: {
                  'gender': _catalogGender,
                  'category': category.categoryQuery,
                  'categoryLabel': category.label,
                  'complementProductId': keepId.toString(),
                  'complementIsUpper': keepIsUpper.toString(),
                },
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: kBorderRadiusAllLarge,
              side: BorderSide(color: colors.nightBorder),
            ),
            tileColor: colors.nightInput,
            leading: Icon(category.icon, color: colors.primaryLight),
            title: Text(
              category.label,
              style: context.typography.labelLarge?.copyWith(
                color: colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: Icon(Icons.chevron_right_rounded, color: colors.slate),
          ),
          const Gap(8),
        ],
      ],
    );
  }

  void _openComplementSheet() {
    final product = widget.sourceProduct!;
    final slot = garmentSlotFor(product);
    final colors = context.appColors;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.nightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complementa tu outfit',
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(6),
              Text(
                slot == GarmentSlot.upper
                    ? 'Ya tienes la parte de arriba. Elige con qué completarla:'
                    : 'Ya tienes la parte de abajo. Elige con qué completarla:',
                style: context.typography.bodySmall?.copyWith(
                  color: colors.slate,
                ),
              ),
              const Gap(16),
              for (final category in _complementCategories) ...[
                ListTile(
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    context.push(
                      CatalogGarmentsScreen.routeName,
                      extra: {
                        'gender': _catalogGender,
                        'category': category.categoryQuery,
                        'categoryLabel': category.label,
                        'complementProductId': product.id.toString(),
                        'complementIsUpper': (slot == GarmentSlot.upper)
                            .toString(),
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: kBorderRadiusAllLarge,
                    side: BorderSide(color: colors.nightBorder),
                  ),
                  tileColor: colors.nightInput,
                  leading: Icon(category.icon, color: colors.primaryLight),
                  title: Text(
                    category.label,
                    style: context.typography.labelLarge?.copyWith(
                      color: colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right_rounded,
                    color: colors.slate,
                  ),
                ),
                const Gap(10),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final state = ref.watch(tryOnControllerProvider);

    return Scaffold(
      backgroundColor: colors.nightDeep,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: colors.authBackground),
        child: SafeArea(
          child: Padding(
            padding: kSpaceDeviceHLg,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: Icon(Icons.arrow_back, color: colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Probador virtual',
                        textAlign: TextAlign.center,
                        style: context.typography.titleMedium?.copyWith(
                          color: colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    // Guardar en favoritos TODO lo probado: prenda individual
                    // o outfit completo (con su imagen generada)
                    if (state.status == TryOnStatus.success &&
                        _garments.isNotEmpty)
                      Builder(
                        builder: (_) {
                          final saved = _garments.length >= 2
                              ? _outfitSaved
                              : ref
                                    .watch(favoriteControllerProvider)
                                    .favoriteIds
                                    .contains(_garments.first.id);
                          return IconButton(
                            onPressed: _saveResult,
                            icon: Icon(
                              saved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: saved ? colors.primaryLight : colors.white,
                            ),
                          );
                        },
                      ),
                    // Volver al inicio de un toque (evita retroceder pantalla
                    // por pantalla tras encadenar combinaciones)
                    IconButton(
                      onPressed: () => context.go(HomeScreen.routeName),
                      icon: Icon(Icons.home_rounded, color: colors.white),
                    ),
                  ],
                ),
                const Gap(separatorLg),
                Expanded(child: _buildBody(state, colors)),
                const Gap(separatorMd),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(TryOnState state, AppColors colors) {
    switch (state.status) {
      case TryOnStatus.initial:
      case TryOnStatus.creating:
      case TryOnStatus.generating:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primaryLight),
            const Gap(separatorLg),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: Text(
                _loadingStages[_stageIndex],
                key: ValueKey(_stageIndex),
                style: context.typography.titleMedium?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Gap(separatorXSm),
            Text(
              widget.productIds.length == 2
                  ? 'Estamos combinando las 2 prendas de tu outfit.'
                  : 'La IA está generando tu imagen. Esto puede tardar unos segundos.',
              textAlign: TextAlign.center,
              style: context.typography.bodySmall?.copyWith(
                color: colors.slate,
              ),
            ),
          ],
        );
      case TryOnStatus.success:
        return Column(
          children: [
            // Resultado enmarcado con chip de precio (ficha tipo tienda). El
            // fondo blanco rellena el espacio del recorte (BoxFit.contain), así
            // no quedan bandas oscuras arriba/abajo: se ve una tarjeta limpia.
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.white,
                  borderRadius: kBorderRadiusAllXLarge,
                  border: Border.all(color: colors.nightBorder),
                ),
                child: ClipRRect(
                  borderRadius: kBorderRadiusAllXLarge,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        state.job?.resultUrl ?? '',
                        fit: BoxFit.contain,
                        width: double.infinity,
                        loadingBuilder: (context, child, progress) =>
                            progress == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  color: colors.primaryLight,
                                ),
                              ),
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: colors.slate,
                            size: 54,
                          ),
                        ),
                      ),
                      if (_garments.isNotEmpty)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.nightDeep.withValues(alpha: 0.72),
                              borderRadius: kBorderRadiusAllXLarge,
                            ),
                            child: Text(
                              '\$${_totalPrice.toStringAsFixed(2)}',
                              style: context.typography.labelMedium?.copyWith(
                                color: colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(separatorSm),
            // Ficha de compra: qué prendas llevas + acceso directo a comprar
            if (_garments.isNotEmpty) ...[
              _resultInfoCard(colors),
              const Gap(separatorSm),
            ],
            // Reintentar la MISMA prenda/outfit sin retroceder: si el
            // resultado no convence (p.ej. la prenda no se aplicó bien), un
            // toque la regenera con otra semilla. Red de seguridad visible.
            _primaryAction(
              colors,
              label: 'Volver a generar',
              icon: Icons.refresh_rounded,
              onTap: _retry,
            ),
            const Gap(separatorSm),
            // Acción secundaria según el flujo (Ir al inicio vive en el
            // header; Comprar vive en la ficha de arriba)
            if (widget.outfitArgs != null)
              _outlineAction(
                colors,
                label: 'Combinar otra prenda',
                icon: Icons.swap_horiz_rounded,
                onTap: _openSwapSheet,
              )
            else if (_complementCategories.isNotEmpty)
              _outlineAction(
                colors,
                label: 'Complementa tu outfit',
                icon: Icons.auto_awesome_rounded,
                onTap: _openComplementSheet,
              )
            else
              _outlineAction(
                colors,
                label: 'Probar otra prenda',
                icon: Icons.checkroom_rounded,
                onTap: () => context.pop(),
              ),
          ],
        );
      case TryOnStatus.failure:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: colors.error, size: 54),
            const Gap(separatorMd),
            Text(
              state.errorMessage ?? 'No pudimos generar tu prueba virtual.',
              textAlign: TextAlign.center,
              style: context.typography.bodyMedium?.copyWith(
                color: colors.white,
                height: 1.4,
              ),
            ),
            const Gap(separatorLg),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: colors.gradientPrimary,
                  borderRadius: kBorderRadiusAllLarge,
                ),
                child: ElevatedButton.icon(
                  onPressed: _retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: kBorderRadiusAllLarge,
                    ),
                  ),
                  icon: Icon(Icons.refresh_rounded, color: colors.nightDeep),
                  label: Text(
                    'Reintentar',
                    style: context.typography.labelLarge?.copyWith(
                      color: colors.nightDeep,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}
