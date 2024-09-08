import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/store/home_page_store.dart';
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
      borderRadius: const BorderRadius.vertical(top: Radius.circular(64)),
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
                  itemCount: store.mattersList.length,
                  itemBuilder: (context, index) {
                    return Matter.fromMatterModel(store.mattersList[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(64)),
        color: topContainerColor(context),
      ),
      margin: const EdgeInsets.fromLTRB(0, 148, 0, 0),
      width: double.infinity,
      height: double.infinity,
      child: clipRRect,
    );
  }
}
