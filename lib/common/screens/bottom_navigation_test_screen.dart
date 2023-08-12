import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/common/utils/api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

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
  var logger = Logger();

  @override
  Widget build(BuildContext context) {
    final userNameWatch = ref.watch(registeredUserInfoProvider).userName;
    final userProfileImagePathWatch = ref.watch(registeredUserInfoProvider).userProfileImagePath;
    final dio = ref.watch(dioProvider);
    final secureStorage = ref.watch(secureStorageProvider);

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
                ),
          ElevatedButton(
            onPressed: () async {
              logger.i("push get button0");
              await testGetApi(dio);
            },
            child: Icon(Icons.search),
          ),
          ElevatedButton(
            onPressed: () async {
              var accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

              // logger.w(accessToken);
              await testPostApi(dio, userNameWatch);
            },
            child: Icon(Icons.send),
          ),
          ElevatedButton(
            onPressed: () {
              print("push get button2");
            },
            child: Icon(Icons.delete),
          )
        ],
      ),
    );
  }

  Future<void> testPostApi(Dio dio, String userNameWatch) async {
    try {
      final response = await dio.post(
        getApi(API.postLocationAndBattery),
        data: {
          "latitude": "87.123456",
          "longitude": "87.123456",
          "battery": "50",
          "isCharging": false,
        },
      );
      logger.i("성공 업로드");
      logger.w(response.statusCode);
      logger.w(response.headers);
      print(response.headers);
      logger.w(response.data);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> testGetApi(Dio dio) async {
    try {
      logger.i("get 결과" + getApi(API.getLocationAndBattery));

      final response = await dio.get(getApi(API.getLocationAndBattery));
      logger.w(response.statusCode);
      logger.w(response.headers);
      logger.w(response.data);
    } catch (e) {
      logger.e(e);
    }
  }
}
