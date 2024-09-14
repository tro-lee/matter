import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';

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
      color: color ?? containerColor(context),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: SizedBox(
          height: 42,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}
