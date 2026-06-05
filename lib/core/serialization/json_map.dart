// Normaliza mapas JSON de Dio / jsonDecode (`Map<dynamic, dynamic>`).

/// Convierte un valor de API/JSON a [Map<String, dynamic>] de forma segura.
Map<String, dynamic> asJsonMap(Object? value) {
  if (value == null) return {};
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map(
      (key, v) => MapEntry(key.toString(), v),
    );
  }
  return {};
}

/// Lista de objetos JSON como mapas tipados.
List<Map<String, dynamic>> asJsonMapList(Object? value) {
  if (value is! List) return [];
  return value.map((e) => asJsonMap(e)).toList();
}
