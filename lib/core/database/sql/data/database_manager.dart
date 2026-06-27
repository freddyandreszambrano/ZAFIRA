import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataBaseManagerProvider = Provider<DatabaseManager>(
  (ref) => DatabaseManager(),
);

class DatabaseManager {
  //Globals

  final String id = 'id';
  final String json = 'json';
  final String status = 'status';

  // * [tableManagement] is the name of the table
  final String tableTicketManagement = 'ticket_management';
  final String managementType = 'management_type';
  final String homeState = 'home_state';
  final String orderState = 'order_state';

  String get createTableManagement =>
      """
    CREATE TABLE IF NOT EXISTS $tableTicketManagement(
      $id INTEGER,
      $status INTEGER,
      $managementType TEXT,
      $homeState TEXT,
      $orderState TEXT
    )
  """;
}
