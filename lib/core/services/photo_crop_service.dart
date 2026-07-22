import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';

import '../helpers/app_colors.dart';

final photoCropServiceProvider = Provider<PhotoCropService>((ref) {
  return PhotoCropService(ImageCropper());
});

/// Permite al usuario recortar la foto (encuadrar solo su cuerpo, sin
/// objetos ni personas de fondo) antes de usarla en el probador virtual.
/// Sin relación de aspecto forzada, para no cortar el cuerpo completo.
class PhotoCropService {
  PhotoCropService(this._cropper);

  final ImageCropper _cropper;

  /// Devuelve la ruta de la imagen recortada, o `null` si el usuario
  /// cancela el recorte (en ese caso no debe continuarse el flujo).
  Future<String?> crop(String sourcePath, {required AppColors colors}) async {
    final cropped = await _cropper.cropImage(
      sourcePath: sourcePath,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Ajustar foto',
          toolbarColor: colors.nightDeep,
          toolbarWidgetColor: colors.white,
          activeControlsWidgetColor: colors.primary,
          backgroundColor: colors.nightDeep,
          statusBarLight: false,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Ajustar foto',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      ],
    );
    return cropped?.path;
  }
}
