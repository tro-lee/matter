import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  final String matterId;

  const EditPage({super.key, required this.matterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("编辑")),
    );
  }
}
