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
        color: 0xffEED2C3,
        fontColor: Colors.black54.value);
  }

  static MatterType get study {
    return MatterType(
        iconData: Icons.menu_book,
        name: "学习",
        color: 0xffBECDC7,
        fontColor: Colors.black54.value);
  }

  static MatterType get work {
    return MatterType(
        iconData: Icons.work,
        name: "工作",
        color: 0xffBFCAD9,
        fontColor: Colors.black54.value);
  }

  static MatterType get sleep {
    return MatterType(
        iconData: Icons.bed,
        name: "睡觉",
        color: 0xffDECBD5,
        fontColor: Colors.black54.value);
  }

  static MatterType get sport {
    return MatterType(
        iconData: Icons.sports_handball,
        name: "运动",
        color: 0xffEBB0B4,
        fontColor: Colors.black54.value);
  }

  static MatterType get entertainment {
    return MatterType(
        iconData: Icons.videogame_asset,
        name: "娱乐",
        color: 0xffF3CAE9,
        fontColor: Colors.black54.value);
  }

  static MatterType get newBuild {
    return MatterType(
        iconData: Icons.edit,
        name: "新建",
        fontColor: Colors.black54.value,
        color: 0xff415f91);
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
