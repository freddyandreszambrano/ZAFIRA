abstract class DaoSQL {
  Future<List<dynamic>> select(
    String table, {
    dynamic data = "",
    String where = "id = ?",
  });

  Future<void> remove(
    String table,
    dynamic data, {
    String where = "id = ?",
  });

  Future<void> update(
    dynamic dataToUpdate,
    String table,
    dynamic data, {
    String where = "id = ?",
  });

  Future<void> insert(dynamic data, String table);
}

abstract class ManagerSQL {
  Future<void> insert(List<dynamic> data, String table);

  Future<void> truncate(String table);

  Future<void> remove(
    String table,
    dynamic data, {
    String where = "id = ?",
  });

  Future<List<dynamic>> select(
    String table, {
    dynamic data = "",
    String where = "id = ?",
  });
}
