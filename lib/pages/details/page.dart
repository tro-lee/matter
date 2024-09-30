import 'package:buhuiwangshi/models/matter_model.dart';
import 'package:buhuiwangshi/pages/details/check_card.dart';
import 'package:buhuiwangshi/pages/details/detail_card.dart';
import 'package:buhuiwangshi/pages/details/store.dart';
import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatelessWidget {
  final String matterId;

  const DetailsPage({super.key, required this.matterId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      key: const Key("DetailsPage"),
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
      context: context,
      child: FutureBuilder<MatterModel?>(
        future: store.loadData(matterId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("获取事项失败"));
          } else {
            return const _Page();
          }
        },
      ),
    );
  }
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Icon(Icons.drag_handle, size: 32),
        ),
        DetailCard(),
        SizedBox(height: 16),
        CheckCard(),
      ],
    );
  }
}
