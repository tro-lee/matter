import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/datebase/matter_builder.dart';
import 'package:buhuiwangshi/store/add_page_store.dart';
import 'package:buhuiwangshi/store/home_page_store.dart';
import 'package:buhuiwangshi/utils/uuid.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class MatterService {
  /// 更新日程实例时，判断日程建造者在当天是否存在日程实例，若有，则判断两者最近的编辑时间，哪个近就删除哪个。
  ///
  /// 创建日程实例时，应该判断日程建造者 在当天是否存在日程实例，若没有则创建。
  ///
  /// 顺序应该是先更新日程，再创建日程
  ///
  static Future<List<MatterModel>> getMattersByDay(DateTime date) async {
    // 获取当天所有日程建造者
    final matterBuilders = await MatterBuilderTable.getByDay(date);
    // 获取当天所有日程实例
    var matters = await MatterTable.getByDay(date);

    /// 以下是删除部分 ==============================
    ///
    // 创建一个 Map 来存储每个 builderId 对应的 MatterBuilder
    Map<String, MatterBuilderModel> builderMap = {
      for (var builder in matterBuilders) builder.id: builder
    };

    // 遍历所有 Matter，比较编辑时间并删除过期的
    List<String> mattersToDelete = [];
    for (var matter in matters) {
      if (builderMap.containsKey(matter.builderId)) {
        var builder = builderMap[matter.builderId]!;
        if (matter.updatedAt.isBefore(builder.updatedAt)) {
          // 如果 Matter 的更新时间早于 MatterBuilder，标记为删除
          mattersToDelete.add(matter.id);
          // 删除 Matter
          matters.remove(matter);
        }
      }
    }
    // 批量删除
    await MatterTable.batchDelete(mattersToDelete);

    /// 以下是创建部分 ==============================
    ///
    // 获取需要创建实例的日程建造者
    List<MatterBuilderModel> buildersToCreate = matterBuilders.where((builder) {
      // 检查是否已存在对应的 Matter 实例
      return !matters.any((matter) => matter.builderId == builder.id);
    }).toList();

    // 为需要创建的日程建造者创建 Matter 实例
    List<MatterModel> newMatters = buildersToCreate.map((builder) {
      return MatterModel.fromMatterBuilder(builder);
    }).toList();

    // 批量插入新创建的 Matter 实例
    await MatterTable.batchInsert(newMatters);

    // 将新创建的 Matter 实例添加到返回列表中
    matters.addAll(newMatters);

    return matters;
  }

  /// 根据表单数据创建新的 MatterBuilderModel 实例并插入数据库
  static Future<void> insertMatterByForm(AddPageStore formStore) async {
    // 创建新的 MatterBuilderModel 实例
    final matterBuilder = MatterBuilderModel(
      id: genUuid(),
      name: formStore.name!,
      type: formStore.type!,
      typeIcon: formStore.type!.iconData,
      time: formStore.datetime!,
      color: formStore.color,
      fontColor: formStore.fontColor,
      levelIcon: formStore.levelIcon,
      level: formStore.level,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      remark: formStore.remark,
      isWeeklyRepeat: formStore.isRepeatWeek,
      weeklyRepeatDays: formStore.isRepeatDay ? formStore.weeklyRepeatDays : [],
      isDailyClusterRepeat: formStore.isRepeatDay,
    );

    try {
      // 将新创建的 MatterBuilderModel 插入数据库
      await MatterBuilderTable.insert(matterBuilder);
    } catch (e) {
      SmartDialog.showToast("添加失败");
    }

    // 显示添加成功的提示
    SmartDialog.showToast("添加成功");

    // 重置表单状态
    AddPageStore.reset();

    // 刷新主页
    HomePageStore.refresh();
  }
}
