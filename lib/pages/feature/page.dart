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
      child: const Column(
        children: [
          Head(),
          LabelTitle(text: "数据"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: Chart(),
          ),
          // 探索
          LabelTitle(text: "探索"),
          ButtonsArea(),
          // 我的
          SizedBox(height: 16),
          LabelTitle(text: "我的"),
          CustomArea(),
          // 关于
          SizedBox(height: 16),
          LabelTitle(text: "关于"),
          MoreArea()
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
    return AppBar(
      toolbarHeight: 48,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }
}
