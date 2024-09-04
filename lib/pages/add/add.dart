import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:buhuiwangshi/utils/colors.dart';
import 'package:buhuiwangshi/pages/add/store.dart';
import 'package:buhuiwangshi/pages/add/areas.dart';

// 添加页
class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return standardContainer(
      context: context,
      child: Scaffold(
        appBar: TopAppBar(),
        body: Body(),
      ),
    );
  }
}

/// 以下是头部部分
class TopAppBar extends StatelessWidget implements PreferredSizeWidget {
  TopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_circle_left_outlined,
          color: textColor(context),
        ),
      ),
      centerTitle: true,
      title: Text(
        "添加日程",
        style: TextStyle(fontSize: 24, color: textColor(context)),
      ),
      actions: [
        TextButton(
            onPressed: () {},
            child: Text("保存",
                style: TextStyle(fontSize: 18, color: textColor(context))))
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 64);
}

/// 以下是内容部分
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [TemplateArea(), NameArea(), TimeArea(), TypeArea()],
        ),
      ),
      create: (context) => FormStore(),
    );
  }
}
