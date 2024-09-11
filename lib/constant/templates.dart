import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/utils/time.dart';

/// 定义模板项的数据结构
class TemplateItem {
  /// 事项类型
  final MatterType type;

  /// 事项时间
  final DateTime time;

  /// 事项名称
  final String name;

  /// 构造函数
  /// @param type 事项类型
  /// @param time 事项时间
  /// @param name 事项名称
  TemplateItem(this.type, this.time, this.name);
}

/// 获取预定义的模板列表
/// @return 返回 TemplateItem 对象的列表
List<TemplateItem> getTemplates() {
  return [
    TemplateItem(MatterType.food, getTime(8, 0), "吃早饭"),
    TemplateItem(MatterType.study, getTime(9, 0), "学习"),
    TemplateItem(MatterType.work, getTime(10, 0), "写代码"),
    TemplateItem(MatterType.food, getTime(12, 0), "吃午餐"),
    TemplateItem(MatterType.sleep, getTime(13, 0), "睡午觉"),
    TemplateItem(MatterType.work, getTime(14, 0), "开周会"),
    TemplateItem(MatterType.sport, getTime(16, 0), "运动"),
    TemplateItem(MatterType.food, getTime(18, 0), "吃晚餐"),
    TemplateItem(MatterType.entertainment, getTime(20, 0), "打游戏"),
    TemplateItem(MatterType.sleep, getTime(21, 0), "睡觉"),
  ];
}
