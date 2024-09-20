import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:buhuiwangshi/utils/colors.dart';
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
        RectButton(
          text: "关于我们",
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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: textColor),
            ),
            const Icon(Icons.chevron_right, size: 24)
          ],
        ),
      ),
    );
  }
}
