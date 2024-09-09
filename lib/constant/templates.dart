import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/utils/time.dart';
import 'package:flutter/material.dart';

Function _genTemplate(MatterType type, DateTime time, String name) {
  return (onFinish) => TextButton(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () {
          onFinish(type, time, name);
        },
        child: Matter(
            color: Color(type.color),
            fontColor: Color(type.fontColor),
            type: type,
            levelIcon: Icons.notifications_off_outlined,
            time: time,
            name: name),
      );
}

List<Function> getTemplates() {
  return [
    _genTemplate(MatterType.food, getTime(8, 0), "吃早饭"),
    _genTemplate(MatterType.study, getTime(9, 0), "学习"),
    _genTemplate(MatterType.work, getTime(10, 0), "写代码"),
    _genTemplate(MatterType.food, getTime(12, 0), "吃午餐"),
    _genTemplate(MatterType.sleep, getTime(13, 0), "睡午觉"),
    _genTemplate(MatterType.work, getTime(14, 0), "开周会"),
    _genTemplate(MatterType.sport, getTime(16, 0), "运动"),
    _genTemplate(MatterType.food, getTime(18, 0), "吃晚餐"),
    _genTemplate(MatterType.entertainment, getTime(20, 0), "打游戏"),
    _genTemplate(MatterType.sleep, getTime(21, 0), "睡觉"),
  ];
}

final templates = getTemplates();
