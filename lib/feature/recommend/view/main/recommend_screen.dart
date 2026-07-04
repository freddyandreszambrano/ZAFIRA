import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/enum/response_status.dart';
import '../../../../core/helpers/context_helper.dart';
import '../../../auth/view/controller/auth_controller.dart';
import '../../../catalog/domain/product_model.dart';
import '../../../catalog/view/main/product_detail_screen.dart';
import '../../../recommend/domain/recommend_model.dart';
import '../controller/recommend_controller.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe la ocasión para el outfit')),
      );
      return;
    }
    FocusScope.of(context).unfocus();
    ref.read(recommendControllerProvider.notifier).getRecommendation(
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
      _showNoPhotoDialog();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Función de prueba virtual próximamente'),
        backgroundColor: context.appColors.primary,
      ),
    );
  }

  void _showNoPhotoDialog() {
    final colors = context.appColors;
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: colors.nightCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person_search_rounded, size: 36, color: colors.primary),
              ),
              const Gap(16),
              Text(
                'Foto de perfil requerida',
                style: TextStyle(color: colors.white, fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Gap(10),
              Text(
                'Para probarte el outfit necesitamos tu foto de cuerpo completo. '
                'Ve a tu perfil y toma una foto para activar esta función.',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.slate, fontSize: 13, height: 1.5),
              ),
              const Gap(20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Entendido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          style: TextStyle(color: colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          _SearchPanel(
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
            child: _ResultPanel(
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

// ── Search Panel ─────────────────────────────────────────────────────────────

class _SearchPanel extends StatelessWidget {
  const _SearchPanel({
    required this.controller,
    required this.selectedStore,
    required this.selectedGender,
    required this.onStoreChanged,
    required this.onGenderChanged,
    required this.onRecommend,
    required this.isLoading,
    this.isFavoritesMode = false,
  });

  final TextEditingController controller;
  final String selectedStore;
  final String selectedGender;
  final ValueChanged<String?> onStoreChanged;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onRecommend;
  final bool isLoading;
  final bool isFavoritesMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.nightCard,
        border: Border(bottom: BorderSide(color: colors.nightBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gender toggle (no aplica en modo favoritos: las prendas ya están elegidas)
          if (!isFavoritesMode) ...[
            Row(
              children: [
                _GenderChip(
                  label: 'Hombre',
                  icon: Icons.male_rounded,
                  selected: selectedGender == 'hombre',
                  onTap: () => onGenderChanged('hombre'),
                ),
                const Gap(10),
                _GenderChip(
                  label: 'Mujer',
                  icon: Icons.female_rounded,
                  selected: selectedGender == 'mujer',
                  onTap: () => onGenderChanged('mujer'),
                ),
              ],
            ),
            const Gap(12),
          ],
          Text(
            '¿Para qué ocasión buscas outfit?',
            style: TextStyle(color: colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Gap(8),
          TextField(
            controller: controller,
            style: TextStyle(color: colors.white),
            decoration: InputDecoration(
              hintText: 'Ej: fiesta, boda, cita romántica...',
              hintStyle: TextStyle(color: colors.slate),
              filled: true,
              fillColor: colors.nightInput,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.nightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.nightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colors.primary, width: 1.5),
              ),
              prefixIcon: Icon(Icons.auto_awesome_rounded, color: colors.primary),
              isDense: true,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onRecommend(),
          ),
          if (!isFavoritesMode) ...[
          const Gap(10),
          Row(
            children: [
              Text('Tienda:', style: TextStyle(color: colors.slate, fontSize: 13)),
              const Gap(8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedStore,
                  dropdownColor: colors.nightCard,
                  style: TextStyle(color: colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: colors.nightInput,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.nightBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.nightBorder),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todas las tiendas')),
                    DropdownMenuItem(value: 'modarm', child: Text('Modarm')),
                    DropdownMenuItem(value: 'etafashion', child: Text('Etafashion')),
                  ],
                  onChanged: onStoreChanged,
                ),
              ),
            ],
          ),
          ],
          const Gap(12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onRecommend,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.auto_awesome_rounded, size: 20),
              label: Text(isLoading ? 'Generando outfits...' : 'Recomendar outfits'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.nightInput,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? colors.primary : colors.nightBorder,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: selected ? colors.white : colors.slate),
            const Gap(6),
            Text(
              label,
              style: TextStyle(
                color: selected ? colors.white : colors.slate,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Result Panel ─────────────────────────────────────────────────────────────

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.state,
    required this.onRefresh,
    required this.onTryOn,
  });

  final dynamic state;
  final VoidCallback onRefresh;
  final VoidCallback onTryOn;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (state.status == ResponseStatus.initial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.checkroom_rounded, size: 72, color: colors.slate.withValues(alpha: 0.35)),
            const Gap(16),
            Text(
              'Escribe una ocasión y te\nrecomendamos hasta 3 outfits',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.slate, fontSize: 15),
            ),
          ],
        ),
      );
    }

    if (state.status == ResponseStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colors.primary),
            const Gap(16),
            Text('IA generando outfits...', style: TextStyle(color: colors.slate, fontSize: 14)),
          ],
        ),
      );
    }

    if (state.status == ResponseStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: colors.error),
              const Gap(12),
              Text(
                state.errorMessage ?? 'Error al obtener recomendación',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.slate),
              ),
              const Gap(20),
              OutlinedButton.icon(
                onPressed: onRefresh,
                icon: Icon(Icons.refresh_rounded, color: colors.primary),
                label: Text('Intentar de nuevo', style: TextStyle(color: colors.primary)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final result = state.result as RecommendResponseModel?;
    if (result == null || result.outfits.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            itemCount: result.outfits.length,
            separatorBuilder: (_, _) => const Gap(12),
            itemBuilder: (context, index) => _OutfitCard(
              outfit: result.outfits[index],
              number: index + 1,
              occasion: result.occasion,
              onTryOn: onTryOn,
            ),
          ),
        ),
        // Bottom actions — solo "3 nuevos"
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
          decoration: BoxDecoration(
            color: colors.nightCard,
            border: Border(top: BorderSide(color: colors.nightBorder)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRefresh,
              icon: Icon(Icons.shuffle_rounded, size: 18, color: colors.primary),
              label: Text('Generar 3 nuevos outfits', style: TextStyle(color: colors.primary, fontSize: 13)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Outfit Card ───────────────────────────────────────────────────────────────

class _OutfitCard extends StatelessWidget {
  const _OutfitCard({
    required this.outfit,
    required this.number,
    required this.occasion,
    required this.onTryOn,
  });

  final OutfitModel outfit;
  final int number;
  final String occasion;
  final VoidCallback onTryOn;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.nightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.nightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: colors.nightBorder)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: colors.primary),
                const Gap(6),
                Text(
                  'Outfit $number',
                  style: TextStyle(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 0.8,
                  ),
                ),
                const Spacer(),
                Text(
                  '\$${outfit.totalPrice.toStringAsFixed(2)} total',
                  style: TextStyle(
                    color: colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Images row
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: outfit.isComplete
                // Vestido / enterizo: una sola prenda centrada
                ? Center(
                    child: SizedBox(
                      width: 200,
                      child: _PieceColumn(
                        label: 'VESTIDO',
                        product: outfit.top,
                      ),
                    ),
                  )
                // Combinación normal: torso + piernas lado a lado
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _PieceColumn(
                          label: 'TORSO',
                          product: outfit.top,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: _PieceColumn(
                          label: 'PIERNAS',
                          product: outfit.bottom!,
                        ),
                      ),
                    ],
                  ),
          ),
          // Botón probar outfit
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onTryOn,
                icon: const Icon(Icons.person_pin_rounded, size: 16),
                label: const Text(
                  'Probar este outfit',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E54FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PieceColumn extends StatelessWidget {
  const _PieceColumn({required this.label, required this.product});

  final String label;
  final ProductModel product;

  Color _storeColor() {
    switch (product.store.toLowerCase()) {
      case 'etafashion':
        return const Color(0xFF8E54FF);
      case 'modarm':
        return const Color(0xFF00BFA5);
      default:
        return Colors.grey;
    }
  }

  String get _storeName {
    switch (product.store.toLowerCase()) {
      case 'etafashion':
        return 'Etafashion';
      case 'modarm':
        return 'Modarm';
      default:
        return product.store;
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: TextStyle(
            color: colors.slate,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        const Gap(6),
        // Image — toca para ver el detalle de la prenda
        GestureDetector(
          onTap: () =>
              context.push(ProductDetailScreen.routeName, extra: product),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _ProductImage(urls: product.imageUrls),
          ),
        ),
        const Gap(6),
        // Store badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _storeColor().withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            _storeName,
            style: TextStyle(color: _storeColor(), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ),
        const Gap(4),
        // Name — toca para ver el detalle de la prenda
        GestureDetector(
          onTap: () =>
              context.push(ProductDetailScreen.routeName, extra: product),
          child: Text(
            product.name,
            style: TextStyle(color: colors.white, fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Gap(3),
        // Price
        Text(
          '\$${product.price.toStringAsFixed(2)}',
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const Gap(6),
        // Buy button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _openUrl(product.url),
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.primaryLight,
              side: BorderSide(color: colors.primary.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Comprar', style: TextStyle(fontSize: 11)),
          ),
        ),
      ],
    );
  }

}

/// Imagen de producto con fallback: si una URL falla, intenta la siguiente.
class _ProductImage extends StatefulWidget {
  const _ProductImage({required this.urls});

  final List<String> urls;

  @override
  State<_ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<_ProductImage> {
  int _urlIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (widget.urls.isEmpty || _urlIndex >= widget.urls.length) {
      return _placeholder(colors);
    }

    return Image.network(
      widget.urls[_urlIndex],
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      headers: const {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/120 Safari/537.36',
      },
      errorBuilder: (_, _, _) {
        // Intentar la siguiente URL en el próximo frame
        if (_urlIndex < widget.urls.length - 1) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _urlIndex++);
          });
        }
        return _placeholder(colors);
      },
    );
  }

  Widget _placeholder(dynamic colors) => Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: colors.nightInput,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(Icons.checkroom_rounded, color: colors.slate),
      );
}
