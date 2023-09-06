import 'package:flutter/material.dart';

class PositionExplainDialog extends StatelessWidget {
  const PositionExplainDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('위치 관리'),
      content:
          const Text('위치데이터(위도, 경도)는 사용자가 직접 추가한 친구에 한에서 공유됩니다.\n메모리에 올리고, 친구가 바로 가져가는 형태로 \nZeppy는 수집, 가공하지 않습니다.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
