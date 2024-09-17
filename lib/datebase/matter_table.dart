import 'package:buhuiwangshi/datebase/db.dart';
import 'package:buhuiwangshi/models/matter_model.dart';

class MatterTable {
  static String createTableSql() {
    return '''
      CREATE TABLE matter (
        id TEXT PRIMARY KEY,
        name TEXT,
        type TEXT,
        typeIcon INTEGER,
        time TEXT,
        color INTEGER,
        fontColor INTEGER,
        levelIcon INTEGER,
        level TEXT,
        createdAt TEXT,
        updatedAt TEXT,
        remark TEXT,
        isWeeklyRepeat INTEGER,
        weeklyRepeatDays TEXT,
        isDailyClusterRepeat INTEGER,
        builderId INTEGER,
        isDone INTEGER,
        doneAt TEXT,
        isDelayed INTEGER,
        delayedAt TEXT,
        isDeleted INTEGER,
        deletedAt TEXT
      )
    ''';
  }

  // 插入一条 Matter 记录
  static Future<void> insert(MatterModel matter) async {
    final db = await DB.instance;
    await db.insert('matter', matter.toMap());
  }

  // 批量插入 Matter 记录
  static Future<void> batchInsert(List<MatterModel> matters) async {
    final db = await DB.instance;
    await db.transaction((txn) async {
      for (var matter in matters) {
        await txn.insert('matter', matter.toMap());
      }
    });
  }

  // 根据 ID 查询一条 Matter 记录
  static Future<MatterModel?> getById(String id) async {
    final db = await DB.instance;
    final List<Map<String, dynamic>> maps = await db.query(
      'matter',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return MatterModel.fromMap(maps.first);
    }
    return null;
  }

  // 根据日期查询 Matter 记录
  static Future<List<MatterModel>> getByDay(DateTime date) async {
    final db = await DB.instance;
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final List<Map<String, dynamic>> maps = await db
        .query('matter', where: 'time LIKE ?', whereArgs: ['%$formattedDate%']);
    return List.generate(maps.length, (i) {
      return MatterModel.fromMap(maps[i]);
    });
  }

  // 查询所有 Matter 记录
  static Future<List<MatterModel>> queryAll() async {
    final db = await DB.instance;
    final List<Map<String, dynamic>> maps = await db.query('matter');
    return List.generate(maps.length, (i) => MatterModel.fromMap(maps[i]));
  }

  // 更新一条 Matter 记录
  static Future<void> update(MatterModel matter) async {
    final db = await DB.instance;
    await db.update(
      'matter',
      matter.toMap(),
      where: 'id = ?',
      whereArgs: [matter.id],
    );
  }

  // 删除一条 Matter 记录
  static Future<void> delete(String id) async {
    final db = await DB.instance;
    await db.delete(
      'matter',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 批量删除 Matter 记录
  static Future<void> batchDelete(List<String> ids) async {
    final db = await DB.instance;
    await db.transaction((txn) async {
      for (String id in ids) {
        await txn.delete(
          'matter',
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    });
  }

  /// 获取指定日期范围内的所有事项统计
  static Future<List<Map<String, dynamic>>> getDailyStats(
      DateTime startDate, DateTime endDate) async {
    final db = await DB.instance;
    final startDateStr =
        DateTime(startDate.year, startDate.month, startDate.day)
            .toIso8601String();
    final endDateStr =
        DateTime(endDate.year, endDate.month, endDate.day).toIso8601String();

    final result = await db.rawQuery('''
      SELECT 
        DATE(time, 'start of day') as date,
        SUM(CASE WHEN isDone = 1 THEN 1 ELSE 0 END) as completedCount,
        SUM(CASE WHEN isDone = 0 THEN 1 ELSE 0 END) as incompleteCount
      FROM matter
      WHERE DATE(time, 'start of day') BETWEEN ? AND ?
      GROUP BY DATE(time, 'start of day')
      ORDER BY DATE(time, 'start of day')
    ''', [startDateStr, endDateStr]);

    return result;
  }
}
