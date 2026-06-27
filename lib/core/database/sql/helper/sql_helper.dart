import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../modules/common/drivers/storage/local_storage.dart';
import '../../../../modules/common/drivers/storage/local_storage_impl.dart';
import '../../../../modules/common/exceptions/regular_exception.dart';
import '../../../constants/app_strings.dart';
import '../data/database_manager.dart';

final sqlHelperProvider = Provider<SQLHelper>((ref) {
  final databaseManager = ref.watch(dataBaseManagerProvider);
  final localDataSource = ref.watch(secureLocalDataSourceProvider);
  return SQLHelper(databaseManager, localDataSource);
});

class SQLHelper {
  SQLHelper(this._databaseManager, this.localDataSource);

  static const int _databaseVersion = 1;
  static const String _databaseName = 'data.db';
  static final logger = Logger();
  static late Database? _db;
  final DatabaseManager _databaseManager;
  final LocalStorage localDataSource;

  Future<void> initDB() async {
    if (await checkPlatformIsWeb()) return;
    logger.i("INIT_DATABASE");
    _db = null;
    try {
      _db = await _openDB();
    } catch (err) {
      logger.e("INIT_DB $err");
    }
  }

  Future<void> createTables(Database database) async {
    await database.execute(_databaseManager.createTableManagement);
  }

  Future<Database> checkDBReference() async {
    return _db ??= await openDatabase(_databaseName, version: _databaseVersion);
  }

  Future<Database> _openDB() async {
    return openDatabase(
      _databaseName,
      version: _databaseVersion,
      onOpen: (Database database) async {
        logger.i("DB_OPENED...");
        await createTables(database);
      },
      onCreate: (Database database, int version) async {
        logger.i("DB_CREATING.....");
        await createTables(database);
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        logger.i("DB_UPDATING.....");
        logger.i("OLD_VERSION: $oldVersion");
        logger.i("NEW_VERSION: $newVersion");
      },
    );
  }

  Future<void> deleteDB() async {
    if (await checkPlatformIsWeb()) return;
    logger.i("DELETE_DB");
    final dbReference = await openDatabase(
      _databaseName,
      version: _databaseVersion,
    );
    _db = null;
    await dbReference.close();
    await deleteDatabase(_databaseName);
    logger.i("DB_DELETED");
  }

  Future<bool> checkPlatformIsWeb() async {
    try {
      final result = await localDataSource.getItem(AppStrings.keyIsWeb);
      return result == "true";
    } catch (err) {
      throw RegularException.fromError(err, "checkPlatformIsWeb", runtimeType);
    }
  }
}
