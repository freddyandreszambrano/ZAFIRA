import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'local_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions();

IOSOptions _getIOSOptions() => const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    );

final secureLocalDataSourceProvider = Provider<LocalStorage>(
  (ref) => LocalStorageImpl(
    FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIOSOptions(),
    ),
  ),
);

class LocalStorageImpl implements LocalStorage {
  LocalStorageImpl(this.secureStorage);

  final FlutterSecureStorage secureStorage;

  @override
  Future<void> setItem(String key, String value) async {
    await secureStorage.write(key: key, value: value);
  }

  @override
  Future<void> removeItem(String key) async {
    await secureStorage.delete(key: key);
  }

  @override
  Future<String?> getItem(String key) async {
    try {
      return await secureStorage.read(key: key);
    } on PlatformException catch (e) {
      if (e.message?.contains('BAD_DECRYPT') ?? false) {
        await secureStorage.delete(key: key);
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> removeAll() async {
    await secureStorage.deleteAll();
  }

  @override
  Future<bool> containsItem(String key) async {
    return secureStorage.containsKey(key: key);
  }
}
