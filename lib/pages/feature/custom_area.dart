import 'package:flutter/material.dart';

class CustomArea extends StatelessWidget {
  const CustomArea({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 24),
          _CustomButton(
            leftChild: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            text: "主题色设置",
          ),
          const SizedBox(width: 16),
          _CustomButton(
            leftChild: Icon(
              Icons.settings,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.8),
            ),
            text: "类型设置",
          ),
          const SizedBox(width: 16),
          _CustomButton(
            leftChild: Icon(
              Icons.phone_android,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.8),
            ),
            text: "系统权限",
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    super.key,
    required this.text,
    required this.leftChild,
  });

  final String text;
  final Widget leftChild;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 128,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                leftChild,
                const SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondaryContainer
                        .withOpacity(0.5),
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
