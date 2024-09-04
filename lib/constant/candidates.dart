import 'package:flutter/material.dart';

/// 用于添加页的模板 和 类型选择
class MatterTypeItem {
  IconData iconData;
  String name;

  MatterTypeItem({required this.iconData, required this.name});
}

final matterTypeItems = <MatterTypeItem>[
  MatterTypeItem(iconData: Icons.fastfood, name: "吃饭"),
  MatterTypeItem(iconData: Icons.menu_book, name: "学习"),
  MatterTypeItem(iconData: Icons.work, name: "工作"),
  MatterTypeItem(iconData: Icons.bed, name: "睡觉"),
  MatterTypeItem(iconData: Icons.sports_handball, name: "运动"),
  MatterTypeItem(iconData: Icons.videogame_asset, name: "娱乐"),
];
