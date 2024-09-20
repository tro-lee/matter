import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/models/matter_builder_model.dart';
import 'package:buhuiwangshi/utils/uuid.dart';
import 'package:flutter/material.dart';

/// MatterModel 类表示一个事项示例的模型
///
/// 生命周期是 首页被MatterBuilder构建 -> 被完成/被删除/被延期-> 被完成/被延期
class MatterModel extends MatterBuilderModel {
  final String builderId; // 所用构建器id

  bool isDone; // 是否完成
  DateTime? doneAt; // 完成时间
  bool isDelayed; // 是否延期
  DateTime? delayedAt; // 延期时间
  bool isDeleted; // 是否取消，历史原因，就先用deleted代替
  DateTime? deletedAt; // 取消时间

  MatterModel({
    required super.typeIcon,
    required super.id,
    required super.name,
    required super.type,
    required super.time,
    required super.color,
    required super.fontColor,
    required super.levelIcon,
    required super.level,
    required super.createdAt,
    required super.updatedAt,
    required super.remark,
    required super.isWeeklyRepeat,
    required super.weeklyRepeatDays,
    required super.isDailyClusterRepeat,
    required this.builderId,
    required this.isDone,
    required this.doneAt,
    required this.isDelayed,
    required this.delayedAt,
    required this.isDeleted,
    required this.deletedAt,
  });

  // 从 MatterBuilderModel 创建 MatterModel 的工厂方法
  factory MatterModel.fromBuilder(MatterBuilderModel builder) {
    return MatterModel(
      typeIcon: builder.typeIcon,
      id: builder.id,
      name: builder.name,
      type: builder.type,
      time: builder.time,
      color: builder.color,
      fontColor: builder.fontColor,
      levelIcon: builder.levelIcon,
      level: builder.level,
      createdAt: builder.createdAt,
      updatedAt: builder.updatedAt,
      remark: builder.remark,
      isWeeklyRepeat: builder.isWeeklyRepeat,
      weeklyRepeatDays: builder.weeklyRepeatDays,
      isDailyClusterRepeat: builder.isDailyClusterRepeat,
      builderId: builder.id,
      isDone: false,
      doneAt: null,
      isDelayed: false,
      delayedAt: null,
      isDeleted: false,
      deletedAt: null,
    );
  }

  // 将 MatterModel 转换为 Map
  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map.addAll({
      'builderId': builderId,
      'isDone': isDone ? 1 : 0,
      'doneAt': doneAt?.toIso8601String(),
      'isDelayed': isDelayed ? 1 : 0,
      'delayedAt': delayedAt?.toIso8601String(),
      'isDeleted': isDeleted ? 1 : 0,
      'deletedAt': deletedAt?.toIso8601String(),
    });
    return map;
  }

  // 从 Map 创建 MatterModel
  factory MatterModel.fromMap(Map<String, dynamic> map) {
    return MatterModel(
      id: map['id'],
      name: map['name'],
      type: MatterType(
          iconData: IconData(map['typeIcon'], fontFamily: 'MaterialIcons'),
          name: map['type'],
          color: map['color'],
          fontColor: map['fontColor']),
      typeIcon: IconData(map['typeIcon'], fontFamily: 'MaterialIcons'),
      time: DateTime.parse(map['time']),
      color: map['color'],
      fontColor: map['fontColor'],
      levelIcon: IconData(map['levelIcon'], fontFamily: 'MaterialIcons'),
      level: map['level'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      remark: map['remark'] ?? '',
      isWeeklyRepeat: map['isWeeklyRepeat'] == 1,
      weeklyRepeatDays: map['weeklyRepeatDays'] != null
          ? (map['weeklyRepeatDays'] as String)
              .split(',')
              .where((e) => e.isNotEmpty)
              .map((e) => int.parse(e))
              .toList()
          : [],
      isDailyClusterRepeat: map['isDailyClusterRepeat'] == 1,
      builderId: map['builderId'],
      isDone: map['isDone'] == 1,
      doneAt: map['doneAt'] != null ? DateTime.parse(map['doneAt']) : null,
      isDelayed: map['isDelayed'] == 1,
      delayedAt:
          map['delayedAt'] != null ? DateTime.parse(map['delayedAt']) : null,
      isDeleted: map['isDeleted'] == 1,
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
    );
  }

  // 从 MatterBuilderModel 创建 MatterModel
  factory MatterModel.fromMatterBuilder(MatterBuilderModel builder,
      {DateTime? targetDate}) {
    DateTime time = builder.time;
    if (targetDate != null &&
        (builder.isWeeklyRepeat || builder.isDailyClusterRepeat)) {
      time = DateTime(
        targetDate.year,
        targetDate.month,
        targetDate.day,
        builder.time.hour,
        builder.time.minute,
        builder.time.second,
      );
    }

    return MatterModel(
      id: genUuid(),
      name: builder.name,
      type: builder.type,
      typeIcon: builder.typeIcon,
      time: time,
      color: builder.color,
      fontColor: builder.fontColor,
      levelIcon: builder.levelIcon,
      level: builder.level,
      createdAt: builder.createdAt,
      updatedAt: builder.updatedAt,
      remark: builder.remark,
      isWeeklyRepeat: builder.isWeeklyRepeat,
      weeklyRepeatDays: builder.weeklyRepeatDays,
      isDailyClusterRepeat: builder.isDailyClusterRepeat,
      builderId: builder.id,
      isDone: false,
      doneAt: null,
      isDelayed: false,
      delayedAt: null,
      isDeleted: false,
      deletedAt: null,
    );
  }
}
