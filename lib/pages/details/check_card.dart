import 'package:buhuiwangshi/pages/details/store.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/time.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

class CheckCard extends StatefulWidget {
  const CheckCard({super.key});

  @override
  _CheckCardState createState() => _CheckCardState();
}

class _CheckCardState extends State<CheckCard> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 120));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DetailsPageStore>(context);
    final data = store.data!;
    final color = Color(data.color);
    final bgColor = color.withOpacity(0.5);

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: data.isDone || data.isDeleted ? 64 : 122,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(32),
          ),
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: _buildCardContent(context, store, color),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.1,
            emissionFrequency: 0.05,
            numberOfParticles: 15,
            gravity: 0.2,
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
      ],
    );
  }

  Widget _buildCardContent(
      BuildContext context, DetailsPageStore store, Color color) {
    final data = store.data!;
    final isDone = data.isDone;
    final isCancel = data.isDeleted;
    // 使用AnimatedSwitcher来实现子组件的切换动画
    if (isDone || isCancel) {
      return _buildCompletedContent(context, store, isDone, isCancel);
    } else {
      return _buildUncompletedContent(context, store, color);
    }
  }

  Widget _buildUncompletedContent(
      BuildContext context, DetailsPageStore store, Color color) {
    return Padding(
      key: const ValueKey('uncompleted'),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("打卡", style: TextStyle(fontSize: 24, color: textColor)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getButton(context, text: "取消", iconData: Icons.cancel_outlined,
                  onPressed: () {
                store.cancelMatter();
                SmartDialog.showToast("取消打卡");
              }, color: topContainerColor(context)),
              _getButton(context,
                  text: "完成",
                  iconData: Icons.check_circle_outline, onPressed: () {
                store.finishMatter();
                _confettiController.play();
                SmartDialog.showToast("完成打卡");
              }, color: color),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCompletedContent(BuildContext context, DetailsPageStore store,
      bool isDone, bool isCancel) {
    final String statusText = isDone ? "打卡完成" : "打卡取消";

    final doneTimeText = getTimeText(store.data!.doneAt, pattern: "HH:mm");

    return Padding(
      key: const ValueKey('completed'),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                statusText,
                style: const TextStyle(fontSize: 18, color: textColor),
              ),
              const SizedBox(width: 8),
              Text(
                doneTimeText,
                style: const TextStyle(fontSize: 18, color: labelColor),
              ),
            ],
          ),
          _getTextButton(context, text: "重置", iconData: Icons.refresh,
              onPressed: () {
            store.resetMatter();
          }, color: topContainerColor(context)),
        ],
      ),
    );
  }

  Widget _getTextButton(
    BuildContext context, {
    required String text,
    required IconData iconData,
    required VoidCallback onPressed,
    required Color? color,
  }) {
    return TextButton(
      onPressed: onPressed,
      child:
          Text(text, style: const TextStyle(fontSize: 18, color: labelColor)),
    );
  }

  FilledButton _getButton(
    BuildContext context, {
    required String text,
    required IconData iconData,
    required VoidCallback onPressed,
    required Color? color,
  }) {
    return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: color ?? containerColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        onPressed: onPressed,
        child: SizedBox(
          width: 96,
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text,
                  style: const TextStyle(fontSize: 18, color: textColor)),
              const SizedBox(width: 4),
              Icon(iconData, size: 18, color: textColor),
            ],
          ),
        ));
  }
}
