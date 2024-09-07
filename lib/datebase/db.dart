import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _instance;

  static Future<Database> get instance async {
    _instance ??= await openDatabase(
      join(await getDatabasesPath(), "buhuiwangshi.db"),
      version: 1,
      onCreate: (db, version) => {db.execute(MatterTable.createTableSql())},
    );
    return _instance!;
  }
}
