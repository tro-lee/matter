import 'dart:core';

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

// 生成最近四周的日期数组
List<List<int>> generateFourWeeksDates() {
  return generateWeeksDates(4);
}
