import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:buhuiwangshi/components/matter.dart';
import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/pages/home/store.dart';

class ContentLayer extends StatelessWidget {
  const ContentLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      width: double.infinity,
      height: double.infinity,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: FutureBuilder<void>(
        future: HomePageStore.initializeMattersList(),
        builder: (context, snapshot) => _buildFutureResult(context, snapshot),
      ),
    );
  }

  Widget _buildFutureResult(
      BuildContext context, AsyncSnapshot<void> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      return _buildMattersList();
    }
  }

  Widget _buildMattersList() {
    return Selector<HomePageStore, List<MatterModel>>(
      selector: (_, store) => store.mattersList,
      builder: (context, mattersList, child) {
        return AnimatedSwitcher(
          key: const Key('AnimatedSwitcher'),
          duration: const Duration(milliseconds: 60),
          transitionBuilder: _buildTransition,
          child: _buildListView(mattersList),
        );
      },
    );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOut),
      ),
      child: child,
    );
  }

  Widget _buildListView(List<MatterModel> mattersList) {
    return ListView.builder(
      key: ValueKey<String>(mattersList.firstOrNull?.id ?? ''),
      padding: const EdgeInsets.only(top: 156, bottom: 100),
      itemCount: mattersList.length,
      itemBuilder: (context, index) =>
          _buildMatterItem(context, mattersList, index),
    );
  }

  Widget _buildMatterItem(
      BuildContext context, List<MatterModel> mattersList, int index) {
    return Matter.fromMatterModel(
      fontColor: Theme.of(context).colorScheme.onSecondaryContainer,
      mattersList[index],
      showTopLine: index != 0,
      showBottomLine: index != mattersList.length - 1,
      topLineColor: Color(index - 1 >= 0 ? mattersList[index - 1].color : 0),
      bottomLineColor: Color(
          index + 1 < mattersList.length ? mattersList[index + 1].color : 0),
      onPressed: () => _onMatterPressed(context, mattersList[index].id),
    );
  }

  void _onMatterPressed(BuildContext context, String matterId) {
    // TODO: Implement navigation to details page
    // Navigator.of(context).push(animateRoute(
    //   direction: 'horizontal',
    //   child: DetailsPage(matterId: matterId),
    // ));
  }
}
