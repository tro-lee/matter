import 'package:buhuiwangshi/services/notification.dart';
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
      child: Consumer<HomePageStore>(
        builder: (context, store, child) {
          return AnimatedSwitcher(
            key: ValueKey<DateTime>(store.selectedDate),
            duration: const Duration(milliseconds: 60),
            transitionBuilder: _buildTransition,
            child: store.isLoading
                ? const Center(
                    key: ValueKey<String>('loading'),
                    child: CircularProgressIndicator(),
                  )
                : _buildMattersList(store.mattersList),
          );
        },
      ),
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

  Widget _buildMattersList(List<MatterModel> mattersList) {
    if (mattersList.isEmpty) {
      return const Center(child: Text('暂无事项'));
    }

    return ListView.builder(
      key: ValueKey<String>(mattersList.first.id),
      padding: const EdgeInsets.only(top: 156, bottom: 100),
      itemCount: mattersList.length,
      itemBuilder: (context, index) =>
          _buildMatterItem(context, mattersList, index),
    );
  }

  Widget _buildMatterItem(
      BuildContext context, List<MatterModel> mattersList, int index) {
    return RepaintBoundary(
      child: Matter.fromMatterModel(
        fontColor: Theme.of(context).colorScheme.onSecondaryContainer,
        mattersList[index],
        showBottomLine: index != mattersList.length - 1,
        bottomLineColor: Color(
            index + 1 < mattersList.length ? mattersList[index + 1].color : 0),
        onPressed: () => _onMatterPressed(context, mattersList[index].id),
        onFinish: () => HomePageStore.finishMatter(mattersList[index].id),
        onCancel: () => HomePageStore.cancelMatter(mattersList[index].id),
      ),
    );
  }

  void _onMatterPressed(BuildContext context, String matterId) {
    NotificationService.showNotification('事项提醒', '事项提醒');
    // TODO: Implement navigation to details page
    // Navigator.of(context).push(animateRoute(
    //   direction: 'horizontal',
    //   child: DetailsPage(matterId: matterId),
    // ));
  }
}
