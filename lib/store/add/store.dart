import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';

class FormStore extends ChangeNotifier {
  static FormStore? _instance;
  static FormStore get instance {
    _instance ??= FormStore();
    return _instance!;
  }

  static reset() {
    _instance = FormStore();
  }

  bool isRepeatWeek = false; // 是否周重复
  void setIsRepeatWeek(newIsRepeatWeek) {
    isRepeatWeek = newIsRepeatWeek;
    notifyListeners();
  }

  bool isRepeatDay = false; // 是否天重复
  void setIsRepeatDay(newIsRepeatDay) {
    isRepeatDay = newIsRepeatDay;
    notifyListeners();
  }

  String level = "low"; // 提醒强度
  void setLevel(level) {
    this.level = level;
    notifyListeners();
  }

  int color = 0xFFEBF1FF; // 颜色
  void setColor(color) {
    this.color = color;
    notifyListeners();
  }

  int fontColor = Colors.black54.value; // 字体颜色
  void setFontColor(color) {
    fontColor = color;
    notifyListeners();
  }

  /// 重置颜色
  void resetColor() {
    fontColor = Colors.black54.value;
    color = 0xFFEBF1FF;
    notifyListeners();
  }

  String remark = ""; // 备注
  /// 修改备注
  void setRemark(newValue) {
    remark = newValue;
    notifyListeners();
  }

  DateTime? datetime; // 时间
  // 只修改日期
  void setDate(DateTime newDateTime) {
    if (datetime != null) {
      datetime = DateTime(newDateTime.year, newDateTime.month, newDateTime.day,
          datetime!.hour, datetime!.minute);
    } else {
      datetime = newDateTime;
    }
    notifyListeners();
  }

  // 只修改时间
  void setTime(Time time) {
    if (datetime != null) {
      datetime = DateTime(datetime!.year, datetime!.month, datetime!.day,
          time.hour, time.minute);
      notifyListeners();
    }
  }

  String? name; // 名称
  void setName(newName) {
    name = newName;
    notifyListeners();
  }

  MatterType? type; // 类型
  void setType(MatterType mti) {
    type = mti;
    notifyListeners();
  }

  // 修改日期相关配置，例如日期、是否天重复、是否周重复
  void setDateConfig({datetime, isRepeatDay, isRepeatWeek}) {
    setDate(datetime);
    this.isRepeatDay = isRepeatDay;
    this.isRepeatWeek = isRepeatWeek;
    notifyListeners();
  }

  // 套用模板
  void setCustom({fontColor, color, type, time, name}) {
    this.fontColor = fontColor;
    this.color = color;
    this.type = type;
    datetime = time;
    this.name = name;
    notifyListeners();
  }
}
