import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:buhuiwangshi/utils/colors.dart';
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

    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FeatureButton(
            icon: Icons.hourglass_bottom_outlined,
            text: "专注",
            onPressed: onPressed,
          ),
          FeatureButton(
            icon: Icons.event_outlined,
            text: "事件",
            onPressed: onPressed,
          ),
          FeatureButton(
            icon: Icons.delete_outline,
            text: "回收站",
            onPressed: onPressed,
          ),
          FeatureButton(
            icon: Icons.edit_note_outlined,
            text: "导入课表",
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const FeatureButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: containerColor(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            iconSize: 32,
            color: primaryColor(context),
            onPressed: onPressed,
            icon: Icon(icon),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: labelColor),
        ),
      ],
    );
  }
}
