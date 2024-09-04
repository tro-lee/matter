import 'package:flutter/material.dart';

Widget placeholder({onPressed, text}) {
  return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      ),
      onPressed: onPressed,
      child: Align(
        alignment: Alignment.centerLeft,
        child:
            Text(text, style: TextStyle(fontSize: 18, color: Colors.black38)),
      ));
}
