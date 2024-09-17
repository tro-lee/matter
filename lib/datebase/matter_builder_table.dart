import 'package:buhuiwangshi/datebase/db.dart';
import 'package:buhuiwangshi/models/matter_builder_model.dart';

/// MatterBuilderTable 类用于处理 matter_builder 表的数据库操作
class MatterBuilderTable {
  /// 创建 matter_builder 表的 SQL 语句
  static String createTableSql() {
    return '''
      CREATE TABLE matter_builder (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        typeIcon INTEGER,
        time TEXT,
        color INTEGER,
        fontColor INTEGER,
        levelIcon INTEGER,
        level INTEGER,
        createdAt TEXT,
        updatedAt TEXT,
        remark TEXT,
        isWeeklyRepeat INTEGER,
        weeklyRepeatDays TEXT,
        isDailyClusterRepeat INTEGER
      )
    ''';
  }

  /// 插入一条 MatterBuilderModel 记录
  ///
  /// [model] 要插入的 MatterBuilderModel 对象
  /// 返回插入的行 ID
  static Future<int> insert(MatterBuilderModel model) async {
    final db = await DB.instance;
    return await db.insert('matter_builder', model.toMap());
  }

  /// 获取指定日期的所有 MatterBuilderModel 记录
  ///
  /// [date] 指定的日期
  /// 返回符合条件的 MatterBuilderModel 列表
  static Future<List<MatterBuilderModel>> getByDay(DateTime date) async {
    final db = await DB.instance;
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final weekday = date.weekday;

    final List<Map<String, dynamic>> maps = await db.query(
      'matter_builder',
      where: '''
        time LIKE ? OR 
        (isWeeklyRepeat = 1 AND weeklyRepeatDays LIKE ?) OR
        isDailyClusterRepeat = 1
      ''',
      whereArgs: ['%$formattedDate%', '%$weekday%'],
    );

    return List.generate(maps.length, (i) {
      return MatterBuilderModel.fromMap(maps[i]);
    });
  }

  /// 获取所有 MatterBuilderModel 记录
  ///
  /// 返回所有 MatterBuilderModel 对象的列表
  static Future<List<MatterBuilderModel>> getAll() async {
    final db = await DB.instance;
    final List<Map<String, dynamic>> maps = await db.query('matter_builder');
    return List.generate(maps.length, (i) {
      return MatterBuilderModel.fromMap(maps[i]);
    });
  }

  /// 根据 ID 获取单个 MatterBuilderModel 记录
  ///
  /// [id] 要查询的记录 ID
  /// 返回对应的 MatterBuilderModel 对象，如果不存在则返回 null
  static Future<MatterBuilderModel?> getById(int id) async {
    final db = await DB.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'matter_builder',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MatterBuilderModel.fromMap(maps.first);
    }
    return null;
  }

  /// 更新一条 MatterBuilderModel 记录
  ///
  /// [model] 要更新的 MatterBuilderModel 对象
  /// 返回更新的行数
  static Future<int> update(MatterBuilderModel model) async {
    final db = await DB.instance;
    return await db.update(
      'matter_builder',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  /// 删除一条 MatterBuilderModel 记录
  ///
  /// [id] 要删除的记录 ID
  /// 返回删除的行数
  static Future<int> delete(int id) async {
    final db = await DB.instance;
    return await db.delete(
      'matter_builder',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
