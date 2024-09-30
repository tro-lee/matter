import 'package:buhuiwangshi/pages/permission/page.dart';
import 'package:buhuiwangshi/utils/animate_route.dart';
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _CustomButton(
            onPressed: () => Navigator.of(context).push(animateRoute(
              direction: "horizontal",
              child: const PermissionPage(),
            )),
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
          _CustomButton(
            onPressed: () => Navigator.of(context).push(animateRoute(
                direction: "horizontal",
                child: Container(
                  color: Colors.white,
                ))),
            leftChild: Icon(
              Icons.color_lens,
              size: 28,
              color: Theme.of(context)
                  .colorScheme
                  .onSecondaryContainer
                  .withOpacity(0.8),
            ),
            text: "主题色设置",
          ),
          const SizedBox(width: 16),
          _CustomButton(
            onPressed: () => Navigator.of(context).push(animateRoute(
                direction: "horizontal",
                child: Container(
                  color: Colors.white,
                ))),
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
    required this.onPressed,
  });

  final String text;
  final Widget leftChild;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
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
