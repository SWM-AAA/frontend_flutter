import 'package:flutter/material.dart';

class PositionPermissionDialog extends StatelessWidget {
  const PositionPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('위치 권한 허용'),
      content: const Text('설정에서 “위치 서비스"를 “항상 허용"으로 설정해야합니다. 그렇지 않으면 앱이 제대로 작동하지 않습니다.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('항상 허용으로 설정'),
        ),
      ],
    );
  }
}
