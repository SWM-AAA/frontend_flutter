import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:image_picker/image_picker.dart';

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
// image picker 를 할 객체
  final ImagePicker picker = ImagePicker();
  // 선택된 단일 이미지를 담을 곳
  File? image;

  @override
  Widget build(BuildContext context) {
    final userNameWatch = ref.watch(registeredUserInfoProvider).userName;
    final userProfileImagePathWatch = ref.watch(registeredUserInfoProvider).userProfileImagePath;
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (userNameWatch != null) Text('$userNameWatch님 환영합니다!'),
          Text('테스트 전환 화면: ${widget.testScreenName}'),
          userProfileImagePathWatch == MY_PROFILE_DEFAULT_IMAGE_PATH
              ? Image.asset(
                  userProfileImagePathWatch,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(userProfileImagePathWatch),
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                )
        ],
      ),
    );
  }
}
