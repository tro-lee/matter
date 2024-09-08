import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/datebase/matter_builder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Database? _instance;

  /// 测试阶段，先销毁再创建，方便开发
  static Future<Database> get instance async {
    _instance ??= await openDatabase(
      join(await getDatabasesPath(), "buhuiwangshi.db"),
      version: 2,
      onCreate: (db, version) {
        db.execute(MatterTable.createTableSql());
        db.execute(MatterBuilderTable.createTableSql());
      },
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('DROP TABLE IF EXISTS matter');
        db.execute('DROP TABLE IF EXISTS matter_builder');
        db.execute(MatterTable.createTableSql());
        db.execute(MatterBuilderTable.createTableSql());
      },
    );
    return _instance!;
  }

  /// 关闭数据库连接
  static Future<void> close() async {
    if (_instance != null) {
      await _instance!.close();
      _instance = null;
    }
  }
}
