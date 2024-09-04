import 'package:flutter/material.dart';

class LabelStyle {
  TextStyle? labelTextStyle;
  EdgeInsets? labelPadding;
  double? labelWidth;
  double? safeWidth;

  LabelStyle(
      {this.labelTextStyle,
      this.labelWidth,
      this.labelPadding,
      this.safeWidth});
}

class Label extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final String text;
  final LabelStyle? labelStyle;

  Label(
      {super.key,
      this.height = 64,
      this.width = double.infinity,
      required this.text,
      required this.child,
      this.labelStyle});

  @override
  Widget build(BuildContext context) {
    var _labelStyle = labelStyle ??
        LabelStyle(
            labelTextStyle: TextStyle(fontSize: 24),
            labelPadding: EdgeInsets.fromLTRB(24, 16, 0, 16),
            labelWidth: 96,
            safeWidth: 64);

    return SizedBox(
      height: height,
      width: width,
      child: Row(
        children: [
          Container(
            width: _labelStyle.labelWidth,
            padding: _labelStyle.labelPadding,
            child: Text(text, style: _labelStyle.labelTextStyle),
          ),
          SizedBox(
            width: _labelStyle.safeWidth,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
