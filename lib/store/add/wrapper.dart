import 'package:buhuiwangshi/store/add/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStoreWrapper extends StatelessWidget {
  final Widget child;
  const AddStoreWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: FormStore.instance, child: child);
  }
}
