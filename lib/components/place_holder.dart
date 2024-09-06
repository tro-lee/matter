import 'package:flutter/material.dart';

Widget placeholder({
  VoidCallback? onPressed,
  required String text,
  bool isWarning = false,
}) {
  return TextButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
    ),
    onPressed: onPressed,
    child: Row(
      children: [
        if (isWarning)
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.warning, color: Colors.red, size: 18),
          ),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: isWarning ? Colors.red : Colors.black38,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
