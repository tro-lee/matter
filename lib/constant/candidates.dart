import 'package:flutter/material.dart';

/// 用于添加页的模板 和 类型选择
class MatterType {
  final IconData iconData;
  final String name;

  /// 默认主题色
  final int color;
  final int fontColor;

  MatterType(
      {required this.iconData,
      required this.name,
      required this.color,
      required this.fontColor});
  static MatterType get food {
    return MatterType(
        iconData: Icons.fastfood,
        name: "吃饭",
        color: 0xffF5E0D6,
        fontColor: Colors.black54.value);
  }

  static MatterType get study {
    return MatterType(
        iconData: Icons.menu_book,
        name: "学习",
        color: 0xffD1DCD7,
        fontColor: Colors.black54.value);
  }

  static MatterType get work {
    return MatterType(
        iconData: Icons.work,
        name: "工作",
        color: 0xffD1D9E5,
        fontColor: Colors.black54.value);
  }

  static MatterType get sleep {
    return MatterType(
        iconData: Icons.bed,
        name: "睡觉",
        color: 0xffE8DBE2,
        fontColor: Colors.black54.value);
  }

  static MatterType get sport {
    return MatterType(
        iconData: Icons.sports_handball,
        name: "运动",
        color: 0xffF2C5C8,
        fontColor: Colors.black54.value);
  }

  static MatterType get entertainment {
    return MatterType(
        iconData: Icons.videogame_asset,
        name: "娱乐",
        color: 0xffF7D9EF,
        fontColor: Colors.black54.value);
  }

  static MatterType get newBuild {
    return MatterType(
        iconData: Icons.edit,
        name: "新建",
        fontColor: Colors.black54.value,
        color: 0xff6B8AB8);
  }
}

final matterTypeItems = <MatterType>[
  MatterType.food,
  MatterType.study,
  MatterType.work,
  MatterType.sleep,
  MatterType.sport,
  MatterType.entertainment,
];
