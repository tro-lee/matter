import 'package:buhuiwangshi/components/date_picker.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/components/place_holder.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/date.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:buhuiwangshi/utils/time.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class TimeArea extends StatelessWidget {
  const TimeArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<AddPageStore>(context);
    final datetime = formStore.datetime;

    popupDatePicker() {
      showDatePicker(formStore);
    }

    var content = formStore.datetime == null
        ? CustomPlaceholder(
            onPressed: popupDatePicker,
            text: "请选择时间",
            isWarning: formStore.isTimeWarning)
        : Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Row(
              children: [
                bubbleLabel(context,
                    color: Color(formStore.color),
                    fontColor: Color(formStore.fontColor),
                    text: getDateText(datetime,
                        isRepeatWeek: formStore.isRepeatWeek,
                        isRepeatDay: formStore.isRepeatDay),
                    onPressed: popupDatePicker),
                const SizedBox(
                  width: 8,
                ),
                bubbleLabel(context,
                    color: Color(formStore.color),
                    fontColor: Color(formStore.fontColor),
                    text: getTimeText(datetime),
                    onPressed: () => showTimePicker(context, formStore)),
              ],
            ),
          );
    return Label(text: "时间", child: content);
  }

  showTimePicker(context, AddPageStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(const Duration(milliseconds: 100));
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
  showDatePicker(AddPageStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    SmartDialog.show(
      animationTime: const Duration(milliseconds: 120),
      builder: (context) {
        var datePicker = DatePicker(
          dateTime: formStore.datetime,
          isRepeatDay: formStore.isRepeatDay,
          isRepeatWeek: formStore.isRepeatWeek,
          onFinish: (datetime, isRepeatWeek, isRepeatDay) async {
            await Future.delayed(const Duration(milliseconds: 200));
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
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: topContainerColor(context),
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: datePicker,
          ),
        );
      },
    );
  }

  /// 日期选择占位
  Widget datePlaceholder({onPressed}) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        ),
        onPressed: onPressed,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text("请输入时间",
              style: TextStyle(fontSize: 18, color: Colors.black38)),
        ));
  }

  /// 工具
  /// 气泡标签
  Widget bubbleLabel(BuildContext context,
      {text, onPressed, color, fontColor}) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          backgroundColor: color,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
      child: Text(text, style: TextStyle(fontSize: 18, color: fontColor)),
    );
  }
}
