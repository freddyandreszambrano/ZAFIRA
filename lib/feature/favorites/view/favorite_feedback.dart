import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../modules/common/widget/notifications/app_notification.dart';
import '../../catalog/domain/product_model.dart';
import 'controller/favorite_controller.dart';

Future<void> toggleFavoriteWithFeedback(
  BuildContext context,
  WidgetRef ref,
  ProductModel product,
) async {
  final wasFavorite = ref
      .read(favoriteControllerProvider)
      .favoriteIds
      .contains(product.id);

  final success =
      await ref.read(favoriteControllerProvider.notifier).toggleFavorite(product);

  if (!success || !context.mounted) return;

  AppNotification.success(
    context,
    wasFavorite ? 'Se quitó de tus favoritos.' : 'Se añadió a tus favoritos.',
  );
}
