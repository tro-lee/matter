import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

class Matter extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final DateTime? time;
  final MatterType type;
  final String name;
  final String remark;
  final bool showTopLine;
  final bool showBottomLine;
  final Color? topLineColor;
  final Color? bottomLineColor;
  final VoidCallback? onPressed;
  final VoidCallback? onIconPressed;
  final bool isWeeklyRepeat;
  final List<int> weeklyRepeatDays;
  final bool isDailyClusterRepeat;

  TextStyle get _nameStyle => TextStyle(
        color: fontColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get _timeStyle => TextStyle(
        fontSize: 18,
        color: fontColor.withOpacity(0.8),
      );

  const Matter({
    super.key,
    required this.type,
    required this.color,
    required this.fontColor,
    required this.time,
    required this.name,
    this.remark = '',
    this.showTopLine = false,
    this.showBottomLine = false,
    this.topLineColor,
    this.bottomLineColor,
    this.onPressed,
    this.onIconPressed,
    this.isWeeklyRepeat = false,
    this.weeklyRepeatDays = const [],
    this.isDailyClusterRepeat = false,
  });

  factory Matter.fromMatterModel(
    MatterModel model, {
    bool showTopLine = false,
    bool showBottomLine = false,
    Color? topLineColor,
    Color? bottomLineColor,
    VoidCallback? onPressed,
    VoidCallback? onIconPressed,
    Color? color,
    Color? fontColor,
  }) {
    return Matter(
      type: model.type,
      color: color ?? Color(model.color),
      fontColor: fontColor ?? Color(model.fontColor),
      time: model.time,
      name: model.name,
      remark: model.remark,
      showTopLine: showTopLine,
      showBottomLine: showBottomLine,
      topLineColor: topLineColor,
      bottomLineColor: bottomLineColor,
      onPressed: onPressed,
      onIconPressed: onIconPressed,
      isWeeklyRepeat: model.isWeeklyRepeat,
      weeklyRepeatDays: model.weeklyRepeatDays,
      isDailyClusterRepeat: model.isDailyClusterRepeat,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLine(),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          _buildVerticalLine(),
          _buildIconButton(),
        ],
      ),
    );
  }

  Widget _buildVerticalLine() {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          _buildLineSegment(showBottomLine, color, bottomLineColor, false),
        ],
      ),
    );
  }

  Widget _buildIconButton() {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        splashColor: Colors.white24,
        highlightColor: Colors.white24,
        onTap: () {
          HapticFeedback.lightImpact();
          onIconPressed?.call();
        },
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(type.iconData, size: 32, color: fontColor),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onLongPress: () => HapticFeedback.lightImpact(),
          onTap: _handleTap,
          splashColor: Colors.white24,
          highlightColor: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                _buildTimeInfo(),
                if (remark.isNotEmpty)
                  Divider(color: fontColor.withOpacity(0.2)),
                if (remark.isNotEmpty) _buildRemark(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      name.isEmpty ? "点我选择模板" : name,
      textScaler: const TextScaler.linear(1),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: _nameStyle,
    );
  }

  Widget _buildTimeInfo() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                _formatTime(),
                textScaler: const TextScaler.linear(1),
                style: _timeStyle,
              ),
              const SizedBox(width: 8),
              _buildRepeatInfo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatInfo() {
    if (isDailyClusterRepeat) {
      return Text(
        '每日',
        textScaler: const TextScaler.linear(1),
        style: _timeStyle,
      );
    } else if (isWeeklyRepeat) {
      return Expanded(
        child: Text(
          '每${_formatWeeklyRepeatDays()}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textScaler: const TextScaler.linear(1),
          style: _timeStyle,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRemark() {
    return Text(
      remark,
      textScaler: const TextScaler.linear(1),
      style: _timeStyle,
    );
  }

  Future<void> _handleTap() async {
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.lightImpact();
    onPressed?.call();
    SystemUtils.hideKeyShowUnfocus();
  }

  String _formatTime() {
    if (time == null) return '';
    return Jiffy.parseFromDateTime(time!).format(pattern: "HH:mm a");
  }

  String _formatWeeklyRepeatDays() {
    return weeklyRepeatDays.map((day) {
      switch (day) {
        case 0:
          return '周日';
        case 1:
          return '周一';
        case 2:
          return '周二';
        case 3:
          return '周三';
        case 4:
          return '周四';
        case 5:
          return '周五';
        case 6:
          return '周六';
        default:
          return '';
      }
    }).join(', ');
  }
}

Widget _buildLineSegment(
    bool showLine, Color backgroundColor, Color? lineColor, bool isTopLine) {
  if (!showLine) return const Expanded(child: SizedBox.shrink());
  return Expanded(
    child: Container(
      width: 8,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: isTopLine ? Alignment.bottomCenter : Alignment.topCenter,
          end: isTopLine ? Alignment.topCenter : Alignment.bottomCenter,
          colors: [
            backgroundColor,
            backgroundColor,
            blendColors(lineColor ?? backgroundColor, backgroundColor, 0.5),
            lineColor ?? backgroundColor,
            lineColor ?? backgroundColor,
          ],
          stops: const [0.1, 0.5, 0.7, 0.9, 1.0],
        ),
      ),
    ),
  );
}
