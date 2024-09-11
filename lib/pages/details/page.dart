import 'package:flutter/material.dart';

class DetailsPage extends StatelessWidget {
  final String matterId;

  const DetailsPage({super.key, required this.matterId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(matterId),
      ),
    );
  }
}
