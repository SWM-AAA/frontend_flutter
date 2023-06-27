import 'package:flutter/material.dart';

class SampleScreen extends StatelessWidget {
  const SampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 나중에 DefaultLayout으로 감싸줄 거라 바로 Container부터 들어가도 됩니다.
    // 화면 테스트해야 하면 Scaffold 씌워서 main.dart에 넣기
    return const Placeholder();
  }
}
