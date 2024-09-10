// 日期选择
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

/// todo 也许可以性能优化

/// 用于弹窗，需要Stateful
// ignore: must_be_immutable
class DatePicker extends StatefulWidget {
  DateTime? dateTime;
  bool isRepeatWeek;
  bool isRepeatDay;
  bool finsihAnimated = false;
  Function(DateTime, bool, bool) onFinish;

  DatePicker(
      {super.key,
      context,
      required this.onFinish,
      this.dateTime,
      this.isRepeatDay = false,
      this.isRepeatWeek = false}) {
    finsihAnimated = isRepeatWeek;
  }

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    var commonTextStyle = DayStyle(
        dayStrStyle: TextStyle(color: labelColor(), fontSize: 18),
        dayNumStyle: TextStyle(
            color: textColor(context),
            fontSize: 24,
            fontWeight: FontWeight.bold),
        monthStrStyle: TextStyle(
          color: labelColor(),
          fontSize: 12,
        ));

    final focusDate = widget.dateTime ?? DateTime.now();
    final fristDate = DateTime.now();
    final lastDate = focusDate.add(const Duration(days: 365));

    final EasyInfiniteDateTimelineController controller =
        EasyInfiniteDateTimelineController();

    var weekLabel = label(
      text: "是否周重复",
      child: Switch(
        activeColor: primaryColor(context),
        value: widget.isRepeatWeek,
        onChanged: (value) {
          setState(() {
            widget.isRepeatWeek = value;
            if (!value) {
              widget.isRepeatDay = false;
            }
          });
        },
      ),
    );

    final dayLabel = widget.isRepeatWeek && widget.finsihAnimated
        ? label(
            text: "是否天重复",
            child: Switch(
              activeColor: primaryColor(context),
              value: widget.isRepeatDay,
              onChanged: (value) {
                setState(() {
                  widget.isRepeatDay = value;
                });
              },
            ),
          )
        : const SizedBox();

    final easyDatePicker = getEasyDatePicker(
        controller, focusDate, fristDate, lastDate, commonTextStyle, context);

    final elevatedButton = ElevatedButton(
        onPressed: () {
          widget.onFinish(widget.dateTime ?? DateTime.now(),
              widget.isRepeatWeek, widget.isRepeatDay);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: middleContainerColor(context)),
        child: const Text("更新", style: TextStyle(fontSize: 18)));

    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      height: widget.isRepeatWeek ? 272 : 230,
      duration: const Duration(milliseconds: 200),
      onEnd: () {
        setState(() {
          widget.finsihAnimated = widget.isRepeatWeek;
        });
      },
      child: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            easyDatePicker,
            weekLabel,
            dayLabel,
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: elevatedButton,
        )
      ]),
    );
  }

  Padding label({required child, required text}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 18),
          ),
          child
        ],
      ),
    );
  }

  /// 日期选择器
  EasyInfiniteDateTimeLine getEasyDatePicker(
      EasyInfiniteDateTimelineController controller,
      DateTime focusDate,
      DateTime fristDate,
      DateTime lastDate,
      DayStyle commonTextStyle,
      BuildContext context) {
    return EasyInfiniteDateTimeLine(
      onDateChange: (selectedDate) {
        setState(() {
          focusDate = selectedDate;
          widget.dateTime = selectedDate;
        });
      },
      selectionMode: const SelectionMode.none(),
      controller: controller,
      focusDate: focusDate,
      firstDate: fristDate,
      lastDate: lastDate,
      locale: "zh",
      dayProps: EasyDayProps(
        dayStructure: DayStructure.dayStrDayNumMonth,
        todayStyle: DayStyle(
          dayStrStyle: commonTextStyle.dayStrStyle,
          dayNumStyle: commonTextStyle.dayNumStyle,
          monthStrStyle: commonTextStyle.monthStrStyle,
          borderRadius: 18,
        ),
        inactiveDayStyle: DayStyle(
          dayStrStyle: commonTextStyle.dayStrStyle,
          dayNumStyle: commonTextStyle.dayNumStyle,
          monthStrStyle: commonTextStyle.monthStrStyle,
          borderRadius: 16,
          decoration: BoxDecoration(
            color: middleContainerColor(context),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
        ),
        activeDayStyle: DayStyle(
          dayStrStyle: commonTextStyle.dayStrStyle,
          dayNumStyle: commonTextStyle.dayNumStyle,
          monthStrStyle: commonTextStyle.monthStrStyle,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              color: containerColor(context)),
        ),
      ),
    );
  }
}
