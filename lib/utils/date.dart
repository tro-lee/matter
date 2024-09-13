import 'dart:core';

import 'package:jiffy/jiffy.dart';

List<List<int>> generateWeeksDates(int num) {
  DateTime now = DateTime.now();
  int year = now.year;
  int month = now.month;
  int day = now.day;

  DateTime monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
  int lastDay = monthEnd.day;

  List<List<int>> weeks = [];

  int startWeekDay = now.weekday;
  day = day - startWeekDay + 1; // 当前周的周一

  if (day < 0) {
    DateTime lastMonthEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
    int lastMonthlastDay = lastMonthEnd.day;
    day += lastMonthlastDay;
    lastDay = lastMonthlastDay;
  }

  for (int i = 0; i < num; i++) {
    List<int> weekDays = [];
    for (int j = 0; j < 7; j++) {
      if (day > lastDay) {
        day = 1;
        year = month == 12 ? year + 1 : year;
        month = month == 12 ? 1 : month + 1;
      }
      weekDays.add(day);
      day++;
    }
    weeks.add(weekDays);
  }
  return weeks;
}

// 生成最近1周的日期数组
List<int> generateOneWeeksDates() {
  return generateWeeksDates(1)[0];
}

// 生成最近四周的日期数组
List<List<int>> generateFourWeeksDates() {
  return generateWeeksDates(4);
}

/// 日期文案
String getDateText(datetime,
    {bool? isRepeatWeek, bool? isRepeatDay, bool isLocale = true}) {
  if (datetime == null) {
    return "";
  }

  var dateTimeJiffy = Jiffy.parseFromDateTime(datetime!).startOf(Unit.day);

  if (isRepeatDay != null && isRepeatDay) {
    return "每天";
  }

  if (isRepeatWeek != null && isRepeatWeek) {
    return "每${dateTimeJiffy.E}";
  }

  if (isLocale) {
    var todayJiffy = Jiffy.now().startOf(Unit.day);
    final daydiff = dateTimeJiffy.diff(todayJiffy, unit: Unit.day);
    final map = {0: "今天", 1: "明天", 2: "后天"};
    if (map.containsKey(daydiff)) {
      return map[daydiff] ?? '';
    }
  }

  return dateTimeJiffy.format(pattern: "MM/dd");
}
