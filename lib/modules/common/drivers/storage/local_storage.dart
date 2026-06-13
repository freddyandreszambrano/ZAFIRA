abstract class LocalStorage {
  Future<void> setItem(String key, String value);

  Future<String?> getItem(String key);

  Future<void> removeItem(String key);

  Future<void> removeAll();

  Future<bool> containsItem(String key);
}
