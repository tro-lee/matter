import 'package:buhuiwangshi/utils/standard.dart';
import 'package:flutter/material.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return standardContainer(
        context: context,
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 48),
          body: _Page(),
        ));
  }
}

class _Page extends StatelessWidget {
  const _Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).colorScheme.surface);
  }
}
