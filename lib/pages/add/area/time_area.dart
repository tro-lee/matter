import 'package:buhuiwangshi/components/date_picker.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class TimeArea extends StatelessWidget {
  TimeArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);
    final datetime = formStore.datetime;

    popupDatePicker() {
      showDatePicker(formStore);
    }

    var content = formStore.datetime == null
        ? placeholder(onPressed: popupDatePicker, text: "请选择时间")
        : Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Row(
              children: [
                bubbleLabel(context,
                    text: getDateText(datetime,
                        isRepeatWeek: formStore.isRepeatWeek,
                        isRepeatDay: formStore.isRepeatDay),
                    onPressed: popupDatePicker),
                SizedBox(
                  width: 8,
                ),
                bubbleLabel(context,
                    text: getTimeText(datetime),
                    onPressed: () => showTimePicker(context, formStore)),
              ],
            ),
          );
    return Label(text: "时间", child: content);
  }

  showTimePicker(context, FormStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(Duration(milliseconds: 100));
    }

    final datetime = formStore.datetime ?? DateTime.now();
    final value = Time(hour: datetime.hour, minute: datetime.minute);

    Navigator.of(context).push(
      showPicker(
        backgroundColor: topContainerColor(context),
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.46),
        disableAutoFocusToNextInput: true,
        accentColor: primaryColor(context),
        is24HrFormat: true,
        showCancelButton: false,
        okText: "更新",
        context: context,
        value: value,
        onChange: formStore.setTime,
      ),
    );
  }

  /// 呼出日期选择器
  showDatePicker(FormStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(Duration(milliseconds: 100));
    }

    SmartDialog.show(
      builder: (context) {
        var datePicker = DatePicker(
          dateTime: formStore.datetime,
          isRepeatDay: formStore.isRepeatDay,
          isRepeatWeek: formStore.isRepeatWeek,
          onFinish: (datetime, isRepeatWeek, isRepeatDay) async {
            await Future.delayed(Duration(milliseconds: 200));
            SmartDialog.dismiss();
            formStore.setDateConfig(
                datetime: datetime,
                isRepeatWeek: isRepeatWeek,
                isRepeatDay: isRepeatDay);
          },
        );
        return standardContainer(
          context: context,
          child: Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: topContainerColor(context),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            child: datePicker,
          ),
        );
      },
    );
  }

  /// 日期文案
  String getDateText(datetime, {bool? isRepeatWeek, bool? isRepeatDay}) {
    if (datetime == null) {
      return "";
    }

    var dateTimeJiffy = Jiffy.parseFromDateTime(datetime!).startOf(Unit.day);
    var todayJiffy = Jiffy.now().startOf(Unit.day);

    if (isRepeatDay != null && isRepeatDay) {
      return "每天";
    }

    if (isRepeatWeek != null && isRepeatWeek) {
      return "每${dateTimeJiffy.E}";
    }

    final daydiff = dateTimeJiffy.diff(todayJiffy, unit: Unit.day);
    final map = {0: "今天", 1: "明天", 2: "后天"};
    if (map.containsKey(daydiff)) {
      return map[daydiff] ?? '';
    }

    return dateTimeJiffy.format(pattern: "MM/dd");
  }

  /// 时间文案
  String getTimeText(datetime) {
    if (datetime == null) {
      return "";
    }

    var timeJiffy = Jiffy.parseFromDateTime(datetime!);
    return timeJiffy.format(pattern: "HH:mm a");
  }

  /// 日期选择占位
  Widget datePlaceholder({onPressed}) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        ),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("请输入时间",
              style: TextStyle(fontSize: 18, color: Colors.black38)),
        ));
  }

  /// 工具
  /// 气泡标签
  Widget bubbleLabel(BuildContext context, {text, onPressed}) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          backgroundColor: middleContainerColor(context),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
      child: Text(text,
          style: TextStyle(fontSize: 18, color: primaryColor(context))),
    );
  }
}
