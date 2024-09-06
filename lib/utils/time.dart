DateTime setTime(DateTime datetime, int hour, int min) {
  return DateTime(datetime.year, datetime.month, datetime.day, hour, min);
}

DateTime getTime(int hour, int min) {
  return setTime(DateTime.now(), hour, min);
}
