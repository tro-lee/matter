import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:flutter/material.dart';

/// MatterBuilder 类用于构建 Matter 事项
/// 主要解决重复性日程问题
///
/// 它包含了 Matter 的所有属性，但是作为一个中间步骤使用
/// 这样可以在创建 Matter 对象时提供更多的灵活性
///
/// 生命周期是 添加页创建 -> 首页创建Matter
class MatterBuilderModel {
  final String id; // 事项的唯一标识符
  final String name; // 事项的名称
  final MatterType type; // 事项的类型（如工作、学习、娱乐等）
  final IconData typeIcon; // 事项的类型（如工作、学习、娱乐等）
  final DateTime time; // 事项的时间
  final String level; // 事项的重要程度
  final IconData levelIcon; // 事项重要程度的图标
  final int color; // 事项的背景颜色
  final int fontColor; // 事项文字的颜色
  final String remark; // 事项的备注

  final bool isWeeklyRepeat; // 是否周重复
  final List<int> weeklyRepeatDays; // 在哪些天重复（0-6 表示周日到周六）
  final bool isDailyClusterRepeat; // 是否天簇重复

  final DateTime createdAt; // 事项创建时间
  final DateTime updatedAt; // 事项最后编辑时间

  MatterBuilderModel({
    required this.typeIcon,
    required this.id,
    required this.name,
    required this.type,
    required this.time,
    required this.color,
    required this.fontColor,
    required this.levelIcon,
    required this.level,
    required this.createdAt,
    required this.updatedAt,
    required this.remark,
    required this.isWeeklyRepeat,
    required this.weeklyRepeatDays,
    required this.isDailyClusterRepeat,
  });

  // 将 MatterBuilderModel 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'typeIcon': typeIcon.codePoint,
      'time': time.toIso8601String(),
      'color': color,
      'fontColor': fontColor,
      'levelIcon': levelIcon.codePoint,
      'level': level,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'remark': remark,
      'isWeeklyRepeat': isWeeklyRepeat ? 1 : 0,
      'weeklyRepeatDays': weeklyRepeatDays.join(','),
      'isDailyClusterRepeat': isDailyClusterRepeat ? 1 : 0,
    };
  }

  // 从 Map 创建 MatterBuilderModel
  factory MatterBuilderModel.fromMap(Map<String, dynamic> map) {
    return MatterBuilderModel(
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
    );
  }
}
