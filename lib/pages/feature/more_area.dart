import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:flutter/material.dart';

class MoreArea extends StatelessWidget {
  const MoreArea({
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

    return Column(
      children: [
        RectButton(
          text: "帮助",
          onPressed: onPressed,
        ),
        const SizedBox(height: 16),
        RectButton(
          text: "了解我们",
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class RectButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const RectButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final fontColor =
        Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.info, size: 24, color: fontColor),
                  const SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                      color: fontColor,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, size: 24, color: fontColor)
          ],
        ),
      ),
    );
  }
}
