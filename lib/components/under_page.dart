import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';

/// 底部层组件
///
/// 这个组件用于创建一个可定制的底部层，通常用于页面的底部区域。
/// 它可以接受一个自定义的颜色和子组件。
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
      // 使用提供的颜色或默认的容器颜色
      color: color ?? containerColor(context),
      // 设置内边距，左右各16，上下为0
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      // 设置宽度和高度为无限大，以填满可用空间
      width: double.infinity,
      height: double.infinity,
      // 将内容对齐到顶部左侧
      alignment: Alignment.topLeft,
      child: Container(
        // 将子组件对齐到底部左侧
        alignment: Alignment.bottomLeft,
        // 设置内部容器的高度为100
        height: 100,
        // 放置传入的子组件
        child: child,
      ),
    );
  }
}
