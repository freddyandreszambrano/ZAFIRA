import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

final imagePickerServiceProvider = Provider<ImagePickerService>((ref) {
  return ImagePickerService(ImagePicker());
});

class ImagePickerService {
  ImagePickerService(this._picker);

  static const _quality = 85;
  static const _maxWidth = 1600.0;

  final ImagePicker _picker;

  Future<String?> pick(PhotoSource source) async {
    final image = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: _quality,
      maxWidth: _maxWidth,
    );
    return image?.path;
  }
}
