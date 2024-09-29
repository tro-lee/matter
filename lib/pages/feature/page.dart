import 'dart:ui';

import 'package:buhuiwangshi/pages/feature/buttons_area.dart';
import 'package:buhuiwangshi/pages/feature/chart.dart';
import 'package:buhuiwangshi/pages/feature/custom_area.dart';
import 'package:buhuiwangshi/pages/feature/more_area.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';

class FeaturePage extends StatelessWidget {
  const FeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return standardContainer(
      context: context,
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Theme.of(context).colorScheme.surface,
      ),
      height: double.infinity,
      width: double.infinity,
      child: const Stack(
        children: [
          Column(children: [
            SizedBox(height: 256), // 头部高度
            LabelTitle(text: "探索"),
            ButtonsArea(),
            SizedBox(height: 16),
            LabelTitle(text: "我的"),
            CustomArea(),
            LabelTitle(text: "关于"),
            MoreArea()
          ]),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Head(),
          ),
        ],
      ),
    );
  }
}

class LabelTitle extends StatelessWidget {
  final String text;

  const LabelTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
            color: Theme.of(context)
                .colorScheme
                .onSecondaryContainer
                .withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

class Head extends StatelessWidget {
  const Head({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 120),
        child: SizedBox(
          height: 256,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_circle_left_outlined),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Chart(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
