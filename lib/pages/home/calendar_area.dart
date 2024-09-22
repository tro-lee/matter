import 'package:buhuiwangshi/pages/home/store.dart';
import 'package:flutter/material.dart';
import 'package:buhuiwangshi/utils/date.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/*
刷新时间和显示逻辑流程图：

┌─────────────────┐
│    初始化组件    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  初始化日期列表  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 加载初始日期数据 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  滚动到今天日期  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│    显示日历     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  用户滚动日历   │◄─────┐
└────────┬────────┘      │
         │               │
         ▼               │
┌─────────────────┐      │
│ 检查是否需要加载│      │
│   更多日期      │      │
└────────┬────────┘      │
         │               │
         ▼               │
┌─────────────────┐      │
│ 如果需要，加载  │      │
│   更多日期      │      │
└────────┬────────┘      │
         │               │
         └───────────────┘

说明：
1. 组件初始化时，首先初始化日期列表。
2. 加载初始的日期数据（前后各15天，共30天）。
3. 将日历滚动到今天的日期。
4. 显示日历界面。
5. 用户滚动日历时，检查是否接近边缘。
6. 如果接近边缘，加载更多日期（前后或后前7天）。
7. 重复步骤5-6，实现无限滚动。

注意：
- 日期的刷新是在用户滚动时触发的，而不是定时刷新。
- 显示逻辑保证了日历始终居中于今天��并可以向前后无限滚动。
- 每次加载新日期后，都会重新构建界面以显示新数据。
*/

/// 日历区域
class CalendarArea extends StatefulWidget {
  const CalendarArea({super.key});

  @override
  State<CalendarArea> createState() => CalendarAreaState();
}

class CalendarAreaState extends State<CalendarArea> {
  // 滚动控制器，用于控制日历的滚动
  final ScrollController _scrollController = ScrollController();
  // 存储日期的列表
  List<DateTime> dates = [];
  // 初始加载的天数
  final int initialDays = 15;
  // 每次加载更多时加载的天数
  final int daysToLoad = 15;
  // 上一次震动的日期索引
  int _lastVibratedIndex = -1;
  // 标记是否是初始滚动
  bool _isInitialScroll = true;

  @override
  void initState() {
    super.initState();
    // 初始化日期列表
    _initializeDates();
    // 加载更多日期（向前）
    _loadMoreDates(false);
    // 添加滚动监听器
    _scrollController.addListener(_onScroll);
    // 在下一帧渲染完成后滚动到今天的日期
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();

      Future.delayed(const Duration(milliseconds: 1000), () {
        // 初始滚动完成后，将标记设置为false
        if (_isInitialScroll) {
          _isInitialScroll = false;
        }
      });
    });
  }

  // 初始化日期列表
  void _initializeDates() {
    final now = getZeroTime(DateTime.now());
    // 生成以今天为中心的日期列表
    dates = List.generate(initialDays,
        (index) => now.subtract(Duration(days: initialDays ~/ 2 - index)));
  }

  // 滚动到今天的日期
  void _scrollToToday() {
    // 查找今天的日期在列表中的索引
    final todayIndex = dates.indexWhere((date) =>
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day);
    if (todayIndex != -1) {
      // 延迟100毫秒后执行滚动，确保布局已完成
      _scrollController.animateTo(
        todayIndex * 56.0, // 假设每个日期项的宽度为56
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // 滚动监听器回调
  void _onScroll() {
    // 当滚动到接近末尾时，加载更多未来的日期
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      _loadMoreDates(true);
    }
    // 当滚动到接近开头时，加载更多过去的日期
    else if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent + 100) {
      _loadMoreDates(false);
    }

    // 计算当前中心日期的索引
    int currentIndex = (_scrollController.offset / 56.0).round();
    if (currentIndex != _lastVibratedIndex && !_isInitialScroll) {
      _lastVibratedIndex = currentIndex;
      // 触发轻微震动
      HapticFeedback.lightImpact();
    }
  }

  // 加载更多日期
  void _loadMoreDates(bool forward) {
    setState(() {
      if (forward) {
        // 向未来加载更多日期
        final lastDate = dates.last;
        dates.addAll(List.generate(
            daysToLoad, (index) => lastDate.add(Duration(days: index + 1))));
      } else {
        // 向过去加载更多日期
        final firstDate = dates.first;
        dates.insertAll(
            0,
            List.generate(daysToLoad,
                    (index) => firstDate.subtract(Duration(days: index + 1)))
                .reversed);
      }
    });

    if (!forward) {
      // 如果是向过去加载，需要调整滚动位置以保持当前视图
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.offset + daysToLoad * 56.0);
      });
    }
  }

  // 获取星期几的中文表示
  String _getWeekDay(DateTime date) {
    if (date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day) {
      return "今天";
    }
    final weekDays = ["一", "二", "三", "四", "五", "六", "日"];
    return "周${weekDays[date.weekday - 1]}";
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Selector<HomePageStore, DateTime>(
                    selector: (_, store) => store.selectedDate,
                    builder: (context, selectedDate, child) {
                      return _CalItem(
                        data: [
                          _getWeekDay(dates[index]),
                          dates[index].toString()
                        ],
                        key: Key(dates[index].toString()),
                        onPressed: (date) {
                          HomePageStore.refresh(date: date);
                        },
                        isSelected:
                            selectedDate.toString() == dates[index].toString(),
                        primaryColor: Theme.of(context).colorScheme.primary,
                        onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
                        onSurfaceColor: Theme.of(context).colorScheme.onSurface,
                      );
                    },
                  ),
                );
              },
              childCount: dates.length,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 释放滚动控制器资源
    _scrollController.dispose();
    super.dispose();
  }
}

/// 日历项
class _CalItem extends StatelessWidget {
  final List<String> data;
  final Function(DateTime) onPressed;
  final bool isSelected;
  final Color primaryColor;
  final Color onPrimaryColor;
  final Color onSurfaceColor;

  const _CalItem({
    super.key,
    required this.data,
    required this.onPressed,
    required this.isSelected,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.onSurfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      throw Exception("数据异常");
    }

    final fontColor = isSelected ? onPrimaryColor : onSurfaceColor;

    return Container(
      width: 48,
      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      decoration: isSelected
          ? BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)))
          : null,
      child: TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)))),
        onPressed: () {
          onPressed(DateTime.parse(data[1]));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getDateText(DateTime.parse(data[1]),
                  pattern: "M/d", isLocale: false),
              style: TextStyle(color: fontColor, fontSize: 12, height: 1),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              data[0],
              style: TextStyle(color: fontColor, fontSize: 16, height: 1),
            ),
          ],
        ),
      ),
    );
  }
}
