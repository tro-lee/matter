import 'package:jiffy/jiffy.dart';

DateTime setTime(DateTime datetime, int hour, int min) {
  return DateTime(datetime.year, datetime.month, datetime.day, hour, min);
}

DateTime getTime(int hour, int min) {
  return setTime(DateTime.now(), hour, min);
}

/// 时间文案
String getTimeText(datetime, {String? pattern}) {
  if (datetime == null) {
    return "";
  }

  var timeJiffy = Jiffy.parseFromDateTime(datetime!);
  return timeJiffy.format(pattern: pattern ?? "HH:mm a");
}
