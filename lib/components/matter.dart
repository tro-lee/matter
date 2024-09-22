import 'dart:math';
import 'package:buhuiwangshi/constant/matter_type.dart';
import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/system.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';

class Matter extends StatefulWidget {
  final Color color;
  final Color fontColor;
  final DateTime? time;
  final MatterType type;
  final String name;
  final String remark;
  final bool showBottomLine;
  final Color? bottomLineColor;
  final VoidCallback? onPressed;
  final VoidCallback? onFinish;
  final VoidCallback? onCancel;
  final bool isWeeklyRepeat;
  final List<int> weeklyRepeatDays;
  final bool isDailyClusterRepeat;
  final bool isDone;
  final DateTime? doneAt;

  const Matter({
    super.key,
    required this.type,
    required this.color,
    required this.fontColor,
    required this.time,
    required this.name,
    this.remark = '',
    this.showBottomLine = false,
    this.bottomLineColor,
    this.onPressed,
    this.onFinish,
    this.onCancel,
    this.isWeeklyRepeat = false,
    this.weeklyRepeatDays = const [],
    this.isDailyClusterRepeat = false,
    this.isDone = false,
    this.doneAt,
  });

  factory Matter.fromMatterModel(
    MatterModel model, {
    bool showBottomLine = false,
    Color? bottomLineColor,
    VoidCallback? onPressed,
    VoidCallback? onFinish,
    VoidCallback? onCancel,
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
      showBottomLine: showBottomLine,
      bottomLineColor: bottomLineColor,
      onPressed: onPressed,
      onFinish: onFinish,
      onCancel: onCancel,
      isWeeklyRepeat: model.isWeeklyRepeat,
      weeklyRepeatDays: model.weeklyRepeatDays,
      isDailyClusterRepeat: model.isDailyClusterRepeat,
      isDone: model.isDone,
      doneAt: model.doneAt,
    );
  }

  @override
  State<Matter> createState() => _MatterState();
}

class _MatterState extends State<Matter> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleFinish() {
    HapticFeedback.lightImpact();
    widget.onFinish?.call();
    _confettiController.play();
  }

  void _handleCancel() {
    HapticFeedback.lightImpact();
    widget.onCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MatterLine(
                color: widget.color,
                fontColor: widget.fontColor,
                showBottomLine: widget.showBottomLine,
                bottomLineColor: widget.bottomLineColor,
                type: widget.type,
                isDone: widget.isDone,
                onFinish: _handleFinish,
                onCancel: _handleCancel,
              ),
              Expanded(
                child: MatterContent(
                  color: widget.color,
                  fontColor: widget.fontColor,
                  time: widget.time,
                  name: widget.name,
                  remark: widget.remark,
                  onPressed: widget.onPressed,
                  isWeeklyRepeat: widget.isWeeklyRepeat,
                  weeklyRepeatDays: widget.weeklyRepeatDays,
                  isDailyClusterRepeat: widget.isDailyClusterRepeat,
                  isDone: widget.isDone,
                  doneAt: widget.doneAt,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0,
              numberOfParticles: 20,
              gravity: 0.3,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MatterLine extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final bool showBottomLine;
  final Color? bottomLineColor;
  final MatterType type;
  final VoidCallback? onFinish;
  final VoidCallback? onCancel;
  final bool isDone;

  const MatterLine({
    Key? key,
    required this.color,
    required this.fontColor,
    required this.showBottomLine,
    this.bottomLineColor,
    required this.type,
    this.onFinish,
    this.onCancel,
    required this.isDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        onTap: isDone ? onCancel : onFinish,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            type.iconData,
            size: 32,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}

class MatterContent extends StatelessWidget {
  final Color color;
  final Color fontColor;
  final DateTime? time;
  final String name;
  final String remark;
  final VoidCallback? onPressed;
  final bool isWeeklyRepeat;
  final List<int> weeklyRepeatDays;
  final bool isDailyClusterRepeat;
  final bool isDone;
  final DateTime? doneAt;

  const MatterContent({
    super.key,
    required this.color,
    required this.fontColor,
    required this.time,
    required this.name,
    required this.remark,
    this.onPressed,
    required this.isWeeklyRepeat,
    required this.weeklyRepeatDays,
    required this.isDailyClusterRepeat,
    required this.isDone,
    this.doneAt,
  });

  TextStyle get _nameStyle => TextStyle(
        color: fontColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  TextStyle get _timeStyle => TextStyle(
        fontSize: 16,
        color: fontColor.withOpacity(0.8),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onLongPress: () => HapticFeedback.heavyImpact(),
          onTap: _handleTap,
          splashColor: Colors.white24,
          highlightColor: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                  child: child,
                );
              },
              child: Column(
                key: ValueKey<String>(isDone ? 'done' : 'content'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleAndEmoji(),
                  if (!isDone && remark.isNotEmpty)
                    Divider(color: fontColor.withOpacity(0.2)),
                  if (!isDone && remark.isNotEmpty) _buildRemark(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndEmoji() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDone ? "完成 $name" : name,
                textScaler: const TextScaler.linear(1),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _nameStyle,
              ),
              Row(
                children: [
                  Text(
                    _formatTime((isDone ? doneAt : time) ?? DateTime.now()),
                    textScaler: const TextScaler.linear(1),
                    style: _timeStyle,
                  ),
                  const SizedBox(width: 8),
                  _buildRepeatInfo(),
                ],
              ),
            ],
          ),
        ),
        if (isDone)
          Text(
            _getRandomEmoji(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  String _getRandomEmoji() {
    final List<String> emojis = [
      '😀',
      '😎',
      '🥳',
      '🤩',
      '😍',
      '🥵',
      '🤯',
      '🎉',
      '👍',
      '💪'
    ];
    final Random random = Random();
    return emojis[random.nextInt(emojis.length)];
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
    return Flexible(
      child: Text(
        remark,
        textScaler: const TextScaler.linear(1),
        style: _timeStyle,
      ),
    );
  }

  Future<void> _handleTap() async {
    await Future.delayed(const Duration(milliseconds: 120));
    HapticFeedback.lightImpact();
    onPressed?.call();
    SystemUtils.hideKeyShowUnfocus();
  }

  String _formatTime(DateTime time) {
    return Jiffy.parseFromDateTime(time).format(pattern: "HH:mm a");
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
