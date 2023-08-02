import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';

class BottomNavigationTestScreen extends ConsumerStatefulWidget {
  final String testScreenName;
  const BottomNavigationTestScreen({
    super.key,
    required this.testScreenName,
  });

  @override
  ConsumerState<BottomNavigationTestScreen> createState() => _BottomNavigationTestScreenState();
}

class _BottomNavigationTestScreenState extends ConsumerState<BottomNavigationTestScreen> {
  String? userName;

  @override
  Widget build(BuildContext context) {
    final userNameWatch = ref.watch(userNameProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userNameWatch != null) Text('$userNameWatch님 환영합니다!'),
          Text('테스트 전환 화면: ${widget.testScreenName}'),
        ],
      ),
    );
  }
}
