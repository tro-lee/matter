import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/pages/details/page.dart';
import 'package:buhuiwangshi/pages/home/store.dart';
import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopLayer extends StatefulWidget {
  const TopLayer({super.key});

  @override
  State<TopLayer> createState() => _TopLayerState();
}

class _TopLayerState extends State<TopLayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var clipRRect = ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: FutureBuilder<void>(
        future: HomePageStore.initializeMattersList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // 使用Consumer监听HomePageStore的变化
            return Consumer<HomePageStore>(
              builder: (context, store, child) {
                // 使用AnimatedSwitcher实现切换动画效果
                return AnimatedSwitcher(
                  key: const Key('AnimatedSwitcher'),
                  // 设置动画持续时间为60毫秒
                  duration: const Duration(milliseconds: 60),
                  // 自定义过渡动画，使用FadeTransition实现淡入淡出效果
                  transitionBuilder: (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
                  // 使用ListView.builder构建可滚动列表
                  child: ListView.builder(
                    // 使用第一个事项的ID作为key，如果列表为空则使用空字符串
                    key: ValueKey<String>(
                        store.mattersList.firstOrNull?.id ?? ''),
                    // 设置顶部内边距为8
                    padding: const EdgeInsets.only(top: 8),
                    // 列表项数量为事项列表的长度
                    itemCount: store.mattersList.length,
                    // 构建每个列表项
                    itemBuilder: (context, index) {
                      // 使用Matter.fromMatterModel创建Matter组件
                      return Matter.fromMatterModel(
                        store.mattersList[index],
                        // 除第一项外，其他项显示顶部线条
                        showTopLine: index != 0,
                        // 除最后一项外，其他项显示底部线条
                        showBottomLine: index != store.mattersList.length - 1,
                        // 设置顶部线条颜色，如果存在上一项则使用上一项的颜色，否则为透明
                        topLineColor: Color(index - 1 >= 0
                            ? store.mattersList[index - 1].color
                            : 0),
                        // 设置底部线条颜色，如果存在下一项则使用下一项的颜色，否则为透明
                        bottomLineColor: Color(
                            index + 1 < store.mattersList.length
                                ? store.mattersList[index + 1].color
                                : 0),
                        // 点击事项时的回调函数
                        onPressed: () {
                          // 使用自定义的动画路由跳转到详情页面
                          Navigator.of(context).push(animateRoute(
                              direction: 'horizontal',
                              child: DetailsPage(
                                  matterId: store.mattersList[index].id)));
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          color: topContainerColor(context),
        ),
        margin: const EdgeInsets.only(top: 98),
        width: double.infinity,
        height: double.infinity,
        child: clipRRect,
      ),
    );
  }
}
