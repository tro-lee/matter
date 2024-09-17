/// 日程 AI 模型
class MatterAiModel {
  String name;
  String type;
  String time;
  String remark;
  bool isWeeklyRepeat;
  String weeklyRepeatDays;
  bool isDailyClusterRepeat;

  MatterAiModel({
    required this.name,
    required this.type,
    required this.time,
    required this.remark,
    required this.isWeeklyRepeat,
    required this.weeklyRepeatDays,
    required this.isDailyClusterRepeat,
  });

  factory MatterAiModel.fromJson(Map<String, dynamic> json) {
    return MatterAiModel(
      name: json['name'],
      type: json['type'],
      time: json['time'],
      remark: json['remark'],
      isWeeklyRepeat: json['isWeeklyRepeat'] == 1,
      weeklyRepeatDays: json['weeklyRepeatDays'],
      isDailyClusterRepeat: json['isDailyClusterRepeat'] == 1,
    );
  }
}
