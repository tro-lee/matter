import 'package:flutter/material.dart';

/// 用于添加页的模板 和 类型选择
class MatterType {
  final IconData iconData;
  final String name;

  /// 默认主题色
  final int color;
  final int fontColor;

  const MatterType({
    required this.iconData,
    required this.name,
    required this.color,
    required this.fontColor,
  });
}

class MatterTypes {
  static const MatterType food = MatterType(
    iconData: Icons.fastfood,
    name: "吃饭",
    color: 0xffF5E0D6,
    fontColor: 0x8A000000, // Colors.black54.value
  );

  static const MatterType study = MatterType(
    iconData: Icons.menu_book,
    name: "学习",
    color: 0xffD1DCD7,
    fontColor: 0x8A000000,
  );

  static const MatterType work = MatterType(
    iconData: Icons.work,
    name: "工作",
    color: 0xffD1D9E5,
    fontColor: 0x8A000000,
  );

  static const MatterType sleep = MatterType(
    iconData: Icons.bed,
    name: "睡觉",
    color: 0xffE8DBE2,
    fontColor: 0x8A000000,
  );

  static const MatterType sport = MatterType(
    iconData: Icons.sports_handball,
    name: "运动",
    color: 0xffF2C5C8,
    fontColor: 0x8A000000,
  );

  static const MatterType entertainment = MatterType(
    iconData: Icons.videogame_asset,
    name: "娱乐",
    color: 0xffF7D9EF,
    fontColor: 0x8A000000,
  );

  static const MatterType newBuild = MatterType(
    iconData: Icons.edit,
    name: "新建",
    color: 0xFFd6e3ff,
    fontColor: 0x8A000000,
  );

  static const MatterType other = MatterType(
    iconData: Icons.category,
    name: "其他",
    color: 0xFFd6e3ff,
    fontColor: 0x8A000000,
  );

  static const List<MatterType> items = [
    food,
    study,
    work,
    sleep,
    sport,
    entertainment,
  ];
}
