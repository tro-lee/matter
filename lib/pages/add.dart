import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'package:buhuiwangshi/components/datePicker.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/components/label.dart';
import 'package:buhuiwangshi/utils/system.dart';

// 添加页
class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(1),
      ),
      child: Scaffold(
        appBar: TopAppBar(),
        body: Body(),
      ),
    );
  }
}

/// 以下是头部部分
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_circle_left_outlined,
          color: textColor(context),
        ),
      ),
      centerTitle: true,
      title: Text(
        "添加日程",
        style: TextStyle(fontSize: 28, color: textColor(context)),
      ),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text("保存",
                style: TextStyle(fontSize: 18, color: textColor(context))))
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 64);
}

/// 以下是数据部分
enum ReminderLevel { low, high }

class FormStore extends ChangeNotifier {
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

  ReminderLevel level = ReminderLevel.low; // 提醒强度
  int color = 0xF5F8FF; // 颜色
  String remark = ""; // 备注

  DateTime? datetime; // 时间
  void setDateTime(newDateTime) {
    datetime = newDateTime;
    notifyListeners();
  }

  String? icon; // 图标

  String? name; // 名称
  void setName(newName) {
    name = newName;
    notifyListeners();
  }

  String? type; // 类型

  bool get isEdited {
    return (datetime ?? icon ?? name ?? type) != null;
  }

  void setTime({datetime, isRepeatDay, isRepeatWeek}) {
    this.datetime = datetime;
    this.isRepeatDay = isRepeatDay;
    this.isRepeatWeek = isRepeatWeek;
    notifyListeners();
  }
}

/// 以下是内容部分
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [TemplateArea(), NameArea(), TimeArea()],
        ),
      ),
      create: (context) => FormStore(),
    );
  }
}

// 模板区
class TemplateArea extends StatelessWidget {
  const TemplateArea({super.key});

  @override
  Widget build(BuildContext context) {
    final name = Provider.of<FormStore>(context).name ?? '';

    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
          color: topContainerColor(context),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Row(
        children: [line(context), content(context, name)],
      ),
    );
  }

  /// 线
  Widget line(context) {
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
            child: Icon(Icons.fastfood, size: 48, color: primaryColor(context)),
          ),
        ],
      ),
    );
  }

  /// 内容
  Widget content(context, templateName) {
    var name = templateName.isEmpty ? "点我选择模板" : templateName;

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
                          fontSize: 28,
                        )),
                    Text("09:41",
                        style: TextStyle(
                          fontSize: 24,
                          color: primaryColor(context),
                        ))
                  ],
                ),
              ),
              Icon(
                Icons.notifications_none,
                color: primaryColor(context),
                size: 32,
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
            style: TextStyle(fontSize: 24),
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
                  width: 16,
                ),
                bubbleLabel(context,
                    text: getTimeText(datetime), onPressed: () {}),
              ],
            ),
          );
    return Label(text: "时间", child: content);
  }

  /// 呼出日期选择器
  showDatePicker(FormStore formStore) async {
    if (SystemUtils.hasFocus) {
      SystemUtils.hideKeyShowUnfocus();
      await Future.delayed(Duration(milliseconds: 100));
    }

    SmartDialog.show(builder: (context) {
      var datePicker = DatePicker(
        dateTime: formStore.datetime,
        isRepeatDay: formStore.isRepeatDay,
        isRepeatWeek: formStore.isRepeatWeek,
        onFinish: (datetime, isRepeatWeek, isRepeatDay) async {
          await Future.delayed(Duration(milliseconds: 200));
          SmartDialog.dismiss();
          formStore.setTime(
              datetime: datetime,
              isRepeatWeek: isRepeatWeek,
              isRepeatDay: isRepeatDay);
        },
      );
      return Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: topContainerColor(context),
            borderRadius: BorderRadius.all(Radius.circular(16))),
        child: datePicker,
      );
    });
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
              style: TextStyle(fontSize: 24, color: Colors.black38)),
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
