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
    // 移除这里的数据获取逻辑
  }

  @override
  Widget build(BuildContext context) {
    final homePageStore = Provider.of<HomePageStore>(context);

    var clipRRect = ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: FutureBuilder<void>(
        future: homePageStore.initializeMattersList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<HomePageStore>(
              builder: (context, store, child) {
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: store.mattersList.length,
                  itemBuilder: (context, index) {
                    return Matter.fromMatterModel(
                      store.mattersList[index],
                      showTopLine: index != 0,
                      showBottomLine: index != store.mattersList.length - 1,
                      topLineColor: Color(index - 1 >= 0
                          ? store.mattersList[index - 1].color
                          : 0),
                      bottomLineColor: Color(
                          index + 1 < store.mattersList.length
                              ? store.mattersList[index + 1].color
                              : 0),
                      onPressed: () {
                        Navigator.of(context).push(animateRoute(
                            direction: 'horizontal',
                            child: DetailsPage(
                                matterId: store.mattersList[index].id)));
                      },
                    );
                  },
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
