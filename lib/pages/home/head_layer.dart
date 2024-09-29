import 'dart:ui';

import 'package:buhuiwangshi/pages/feature/page.dart';
import 'package:buhuiwangshi/pages/home/calendar_area.dart';
import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:flutter/material.dart';

/// 底部层组件
class HeadLayer extends StatelessWidget {
  const HeadLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: SafeArea(
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "不会忘事",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(animateRoute(
                              child: const FeaturePage(),
                              direction: 'horizontal'));
                        },
                        icon: const Icon(Icons.menu),
                      ),
                    ],
                  ),
                  const CalendarArea(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 底部层组件
///
/// 这个组件用于创建一个可定制的底部层，通常用于页面的底部区域。
/// 它可以接受一个自定义的颜色、子组件和高度margin。
class BottomLayer extends StatelessWidget {
  /// 子组件，将被放置在底部层的内部容器中
  final Widget child;

  /// 可选的背景颜色
  /// 如果未提供，将使用默认的容器颜色
  final Color? color;

  /// 构造函数
  ///
  /// [child] 是必需的参数，表示要显示在底部层中的组件
  /// [color] 是可选的参数，用于自定义底部层的背景颜色
  const BottomLayer({
    super.key,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: child,
      ),
    );
  }
}
