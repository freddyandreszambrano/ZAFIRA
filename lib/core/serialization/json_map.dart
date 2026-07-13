/// Normaliza mapas JSON de Dio / jsonDecode en una frontera tipada.
Map<String, Object?> asJsonMap(Object? value) {
  if (value == null) return const {};
  if (value is Map<String, Object?>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return const {};
}

/// Lista de objetos JSON como mapas tipados.
List<Map<String, Object?>> asJsonMapList(Object? value) {
  if (value is! List) return const [];
  return value.map(asJsonMap).toList();
}
