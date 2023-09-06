import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/permission/screens/position_permission_screen.dart';

void moveToPermissionScreen(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const PositionPermissionScreen(),
      ),
      (route) => false);
}
