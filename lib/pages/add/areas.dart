import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'package:buhuiwangshi/components/datePicker.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:buhuiwangshi/pages/add/store.dart';

// 模板区
class TemplateArea extends StatelessWidget {
  const TemplateArea({super.key});

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormStore>(context);
    final name = formStore.name ?? '';
    final time = formStore.datetime;
    final icon = formStore.type?.iconData ?? Icons.edit;

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
          color: topContainerColor(context),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [line(context, icon), content(context, name, time)],
      ),
    );
  }

  /// 线
  Widget line(context, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 8,
            height: double.infinity,
            color: middleContainerColor(context),
          ),
          Container(
            decoration: BoxDecoration(
              color: middleContainerColor(context),
              borderRadius: BorderRadius.all(Radius.circular(180)),
            ),
            width: 64,
            height: 64,
            child: Icon(icon, size: 32, color: primaryColor(context)),
          ),
        ],
      ),
    );
  }

  /// 内容
  Widget content(context, templateName, datetime) {
    var name = templateName.isEmpty ? "点我选择模板" : templateName;

    String time = '00:00';
    if (datetime != null) {
      var timeJiffy = Jiffy.parseFromDateTime(datetime!);
      time = timeJiffy.format(pattern: "HH:mm a");
    }

    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
        decoration: BoxDecoration(
            color: middleContainerColor(context),
            borderRadius: BorderRadius.all(Radius.circular(120))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryColor(context),
                          fontSize: 24,
                        )),
                    time.isEmpty
                        ? SizedBox()
                        : Text(time,
                            style: TextStyle(
                              fontSize: 18,
                              color: primaryColor(context),
                            ))
                  ],
                ),
              ),
              Icon(
                Icons.notifications_none,
                color: primaryColor(context),
                size: 24,
              )
            ],
          ),
        ),
      ),
    );
  }
}

// 名称编辑区
class NameArea extends StatelessWidget {
  const NameArea({super.key});

  @override
  Widget build(BuildContext context) {
    final setName = Provider.of<FormStore>(context).setName;

    return Label(
        text: "名称",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
          child: TextField(
            onChanged: setName,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration.collapsed(
                hintText: "请输入名称", hintStyle: TextStyle(color: Colors.black38)),
          ),
        ));
  }
}

// 时间编辑区
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
        ? datePlaceholder(onPressed: popupDatePicker)
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

// 类型编辑区
// ignore: must_be_immutable
class TypeArea extends StatefulWidget {
  var isPopup = false;
  TypeArea({key});

  @override
  State<TypeArea> createState() => _TypeAreaState();
}

class _TypeAreaState extends State<TypeArea> {
  @override
  Widget build(BuildContext context) {
    var formStore = Provider.of<FormStore>(context);
    var type = formStore.type;
    popupTypePicker() {
      showTypePicker(formStore);
    }

    var content = type == null
        ? typePlaceholder(onPressed: popupTypePicker)
        : TextButton(
            onPressed: popupTypePicker,
            child: Row(
              children: [
                Icon(
                  type.iconData,
                  size: 24,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  type.name,
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          );

    return Label(
      text: "类型",
      child: content,
    );
  }

  void showTypePicker(FormStore formStore) {
    SmartDialog.show(builder: (context) {
      return standardContainer(
        context: context,
        child: Container(
          decoration: BoxDecoration(
              color: topContainerColor(context),
              borderRadius: BorderRadius.all(Radius.circular(24))),
          padding: EdgeInsets.fromLTRB(28, 16, 28, 16),
          width: 256,
          child: Wrap(alignment: WrapAlignment.spaceBetween, children: [
            for (var item in matterTypeItems)
              typeLabel(context, matterTypeItem: item, onPressed: (type) async {
                await Future.delayed(Duration(milliseconds: 200));
                SmartDialog.dismiss();
                formStore.setType(type);
              })
          ]),
        ),
      );
    });
  }

  // 标签
  Widget typeLabel(BuildContext context,
      {required MatterTypeItem matterTypeItem,
      required Function(MatterTypeItem) onPressed}) {
    final icon = matterTypeItem.iconData;
    final text = matterTypeItem.name;
    return TextButton(
      onPressed: () async {
        onPressed(matterTypeItem);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: IntrinsicWidth(
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: primaryColor(context),
              ),
              SizedBox(width: 4),
              Text(text,
                  style: TextStyle(fontSize: 18, color: primaryColor(context))),
            ],
          ),
        ),
      ),
    );
  }

  /// 日期选择占位
  Widget typePlaceholder({onPressed}) {
    return TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        ),
        onPressed: onPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text("请输入类型",
              style: TextStyle(fontSize: 18, color: Colors.black38)),
        ));
  }
}
