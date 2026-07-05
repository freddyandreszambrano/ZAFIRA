import 'package:flutter_test/flutter_test.dart';
import 'package:zafira/feature/auth/domain/user_model.dart';

void main() {
  group('UserModel', () {
    test('maps try_on_photo from API response', () {
      final user = UserModel.fromJson({
        'image': '',
        'try_on_photo': 'http://localhost/media/try_on/photo.jpg',
      });

      expect(user.tryOnPhoto, 'http://localhost/media/try_on/photo.jpg');
    });

    test('uses tryOnPhoto as display image before legacy image', () {
      final user = UserModel(
        image: 'http://localhost/media/users/avatar.jpg',
        tryOnPhoto: 'http://localhost/media/try_on/photo.jpg',
      );

      expect(user.displayImage, 'http://localhost/media/try_on/photo.jpg');
      expect(user.hasDisplayImage, isTrue);
    });

    test('falls back to legacy image when tryOnPhoto is empty', () {
      final user = UserModel(image: 'http://localhost/media/users/avatar.jpg');

      expect(user.displayImage, 'http://localhost/media/users/avatar.jpg');
      expect(user.hasDisplayImage, isTrue);
    });
  });
}
