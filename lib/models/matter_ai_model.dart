import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/models/matter_builder_model.dart';
import 'package:buhuiwangshi/utils/uuid.dart';
import 'package:flutter/material.dart';

/// 日程 AI 模型
class MatterAiModel {
  String name;
  String type;
  String time;
  String remark;
  bool isWeeklyRepeat;
  String weeklyRepeatDays;
  bool isDailyClusterRepeat;

  MatterAiModel({
    required this.name,
    required this.type,
    required this.time,
    required this.remark,
    required this.isWeeklyRepeat,
    required this.weeklyRepeatDays,
    required this.isDailyClusterRepeat,
  });

  factory MatterAiModel.fromJson(Map<String, dynamic> json) {
    return MatterAiModel(
      name: json['name'],
      type: json['type'],
      time: json['time'],
      remark: json['remark'],
      isWeeklyRepeat: json['isWeeklyRepeat'] == 1,
      weeklyRepeatDays: json['weeklyRepeatDays'],
      isDailyClusterRepeat: json['isDailyClusterRepeat'] == 1,
    );
  }

  // 转换为 MatterBuilderModel
  MatterBuilderModel toMatterBuilderModel() {
    var targetType = MatterTypes.items
        .firstWhere((e) => e.name == type, orElse: () => MatterTypes.other);

    var iconData = targetType.iconData;
    var color = targetType.color;
    var fontColor = targetType.fontColor;

    return MatterBuilderModel(
      name: name,
      type: targetType,
      time: DateTime.parse(time),
      remark: remark,
      typeIcon: iconData,
      id: genUuid(),
      color: color,
      fontColor: fontColor,
      levelIcon: Icons.notifications_none,
      level: 'low',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isWeeklyRepeat: isWeeklyRepeat,
      weeklyRepeatDays: weeklyRepeatDays
          .split(',')
          .where((e) => e.isNotEmpty)
          .map((e) => int.parse(e))
          .toList(),
      isDailyClusterRepeat: isDailyClusterRepeat,
    );
  }
}
