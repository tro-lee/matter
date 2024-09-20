import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';

/// 底部层组件
class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const BottomLayer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "不会忘事",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    height: 1),
              ),
              Text(
                "今天又是元气满满的一天",
                style: TextStyle(fontSize: 16, color: labelColor, height: 1),
              ),
            ],
          ),
          // Column(
          //   children: [
          //     IconButton(
          //       onPressed: () {
          //         Navigator.of(context).push(
          //           animateRoute(
          //             child: const FeaturePage(),
          //             direction: "horizontal",
          //           ),
          //         );
          //       },
          //       icon: const Icon(Icons.menu_open, size: 24, color: labelColor),
          //     ),
          //   ],
          // )
        ],
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
    return Container(
      decoration: const BoxDecoration(
        color: surfaceDimColor,
        // gradient: LinearGradient(
        //     colors: [Color(0xffc9def4), Color(0xfff5ccd4), Color(0xffb8a4c9)]),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}
