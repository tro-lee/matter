import 'package:buhuiwangshi/constant/candidates.dart';
import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class Matter extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final DateTime? time;
  final MatterType type;
  final String name;
  final IconData levelIcon;
  final bool showTopLine;
  final bool showBottomLine;
  final Color? topLineColor;
  final Color? bottomLineColor;
  final VoidCallback? onPressed;

  // 预计算的文本样式
  final TextStyle _nameStyle;
  final TextStyle _timeStyle;

  Matter({
    super.key,
    required this.type,
    required this.color,
    required this.fontColor,
    required this.time,
    required this.name,
    required this.levelIcon,
    this.showTopLine = false,
    this.showBottomLine = false,
    this.topLineColor,
    this.bottomLineColor,
    this.onPressed,
  })  : _nameStyle = TextStyle(
          color: fontColor,
          fontSize: 24,
        ),
        _timeStyle = TextStyle(
          fontSize: 18,
          color: fontColor,
        );

  factory Matter.fromMatterModel(
    MatterModel model, {
    bool showTopLine = false,
    bool showBottomLine = false,
    Color? topLineColor,
    Color? bottomLineColor,
    VoidCallback? onPressed,
  }) {
    return Matter(
      type: model.type,
      color: Color(model.color),
      fontColor: Color(model.fontColor),
      time: model.time,
      name: model.name,
      levelIcon: model.levelIcon,
      showTopLine: showTopLine,
      showBottomLine: showBottomLine,
      topLineColor: topLineColor,
      bottomLineColor: bottomLineColor,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      width: double.infinity,
      child: Row(
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
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: double.infinity,
            child: Column(
              children: [
                _buildLineSegment(showTopLine, color, topLineColor, true),
                _buildLineSegment(
                    showBottomLine, color, bottomLineColor, false),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            width: 64,
            height: 64,
            child: Icon(type.iconData, size: 32, color: fontColor),
          ),
        ],
      ),
    );
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
            ],
            stops: const [0.1, 0.8, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final formattedTime = _formatTime();
    return Material(
      color: color,
      borderRadius: const BorderRadius.all(Radius.circular(120)),
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () async {
                // 等待一小段时间，让动画有机会显示
                await Future.delayed(const Duration(milliseconds: 120));
                onPressed?.call();
              },
        splashColor: Colors.white38,
        highlightColor: Colors.white38,
        borderRadius: BorderRadius.circular(120),
        child: Container(
          height: 64,
          margin: const EdgeInsets.fromLTRB(20, 8, 32, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? "点我选择模板" : name,
                      textScaler: const TextScaler.linear(1),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _nameStyle,
                    ),
                    if (formattedTime.isNotEmpty)
                      Text(
                        formattedTime,
                        textScaler: const TextScaler.linear(1),
                        style: _timeStyle,
                      )
                  ],
                ),
              ),
              Icon(
                levelIcon,
                color: fontColor,
                size: 24,
              )
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime() {
    if (time == null) return '';
    return Jiffy.parseFromDateTime(time!).format(pattern: "HH:mm a");
  }
}
