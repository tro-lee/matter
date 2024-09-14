import 'package:buhuiwangshi/components/under_page.dart';
import 'package:buhuiwangshi/datebase/matter.dart';
import 'package:buhuiwangshi/pages/details/check_card.dart';
import 'package:buhuiwangshi/pages/details/detail_card.dart';
import 'package:buhuiwangshi/pages/details/store.dart';
import 'package:buhuiwangshi/pages/edit/page.dart';
import 'package:buhuiwangshi/utils/animate_route.dart';
import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  final String matterId;

  const DetailsPage({super.key, required this.matterId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsPageStore(),
      child: _DetailsPageContent(matterId: matterId),
    );
  }
}

class _DetailsPageContent extends StatelessWidget {
  final String matterId;

  const _DetailsPageContent({required this.matterId});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DetailsPageStore>(context, listen: false);
    return standardContainer(
      child: FutureBuilder<MatterModel?>(
        future: store.loadData(matterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("获取事项失败"));
          } else {
            return const _PageContainer();
          }
        },
      ),
      context: context,
    );
  }
}

class _PageContainer extends StatelessWidget {
  const _PageContainer();

  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsPageStore>(
      child: const Column(
        children: [
          SizedBox(height: 16),
          DetailCard(),
          SizedBox(height: 16),
          CheckCard(),
        ],
      ),
      builder: (context, store, child) {
        final color = Color(store.data!.color);

        return Stack(
          children: [
            BottomLayer(
              color: color,
              child: const _BottomButtons(),
            ),
            SafeArea(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 42),
                decoration: BoxDecoration(
                  color: topContainerColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: child,
              ),
            ),
            const _HelpText(),
          ],
        );
      },
    );
  }
}

class _BottomButtons extends StatelessWidget {
  const _BottomButtons();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<DetailsPageStore>(context, listen: false);
    final matterId = store.data!.id;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_circle_left_outlined, color: textColor),
        ),
        TextButton(
          onPressed: () {
            // 实现编辑功能
            Navigator.of(context).push(animateRoute(
                child: EditPage(matterId: matterId), direction: "horizontal"));
          },
          child: const Text(
            "编辑",
            style: TextStyle(fontSize: 18, color: textColor),
          ),
        )
      ],
    );
  }
}

class _HelpText extends StatelessWidget {
  const _HelpText();

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 16,
      child: Center(
        child: Text("选择不同类型，探索更多模块",
            style: TextStyle(fontSize: 14, color: Colors.black26)),
      ),
    );
  }
}
