import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/common/screens/root_tab.dart';

void moveToRootTab(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const RootTab(),
      ),
      (route) => false);
}
