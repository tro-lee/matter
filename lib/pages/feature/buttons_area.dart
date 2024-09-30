import 'package:buhuiwangshi/pages/add/page.dart';
import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:flutter/material.dart';

class ButtonsArea extends StatelessWidget {
  const ButtonsArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    onPressed() {
      Navigator.of(context).push(animateRoute(
          direction: "horizontal",
          child: Container(
            color: Colors.white,
          )));
    }

    onPressedAdd() {
      Navigator.of(context).push(animateRoute(
        direction: "horizontal",
        child: const AddPage(),
      ));
    }

    return SizedBox(
      height: 96,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          FeatureButton(
            text: "添加",
            subText: "✋",
            bottomText: "手动添加事项",
            onPressed: onPressedAdd,
          ),
          const SizedBox(width: 16), // Add spacing between buttons
          FeatureButton(
            text: "专注",
            subText: "⌛",
            bottomText: "已坚持 16 分钟",
            onPressed: onPressed,
          ),
          const SizedBox(width: 16), // Add spacing between buttons
          FeatureButton(
            text: "事件",
            subText: "📅",
            bottomText: "下一个事件",
            onPressed: onPressed,
          ),
          const SizedBox(width: 16),
          FeatureButton(
            text: "回收站",
            subText: "🗑️",
            bottomText: "清空回收站",
            onPressed: onPressed,
          ),
          const SizedBox(width: 16),
          FeatureButton(
            text: "导入课表",
            subText: "📋",
            bottomText: "导入成功",
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String text;
  final String subText;
  final String bottomText;
  final VoidCallback onPressed;

  const FeatureButton({
    super.key,
    required this.text,
    required this.subText,
    required this.bottomText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Future.delayed(const Duration(milliseconds: 120), () {
          onPressed();
        }),
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5),
                    fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Text(
                  bottomText,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelSmall!.fontSize,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
