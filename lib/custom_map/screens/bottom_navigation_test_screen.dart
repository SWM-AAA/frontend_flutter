import 'package:flutter/material.dart';

class BottomNavigationTestScreen extends StatelessWidget {
  final String testScreenName;
  const BottomNavigationTestScreen({
    super.key,
    required this.testScreenName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('테스트 전환 화면: $testScreenName'),
        ],
      ),
    );
  }
}
