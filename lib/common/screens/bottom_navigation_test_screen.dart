import 'dart:core';
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

import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/repository/live_info_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class BottomNavigationTestScreen extends ConsumerStatefulWidget {
  final String? testScreenName;
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
          Text('테스트 전환 화면: ${widget.testScreenName}'),
          if (userNameWatch != null)
            Text(
              '$userNameWatch님 환영합니다!',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
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
              await testPostApi(dio, userNameWatch);
            },
            child: Icon(Icons.send),
          ),
          ElevatedButton(
            onPressed: () async {
              await testPostApiMove(dio, userNameWatch);
            },
            child: Icon(Icons.directions_walk),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FutureBuilder<FriendLocationAndBattery>(
                future: testGetApi(dio),
                builder: (context, AsyncSnapshot<FriendLocationAndBattery> snapshot) {
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.friendInfoList.length,
                      itemBuilder: (_, index) {
                        final item = snapshot.data!.friendInfoList[index];
                        // 아이템
                        return Row(
                          children: [
                            Text("${item.userId}"),
                            SizedBox(width: 10),
                            Text("${item.liveInfo.latitude}"),
                            SizedBox(width: 10),
                            Text("${item.liveInfo.longitude}"),
                            SizedBox(width: 10),
                            Text("${item.liveInfo.battery}"),
                            SizedBox(width: 10),
                            Text("${item.liveInfo.isCharging}"),
                          ],
                        );
                      },
                      separatorBuilder: (_, index) {
                        // 아이템 사이사이
                        return SizedBox(
                          height: 10,
                        );
                      },
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> testPostApi(Dio dio, String userNameWatch) async {
    try {
      final response = await dio.post(
        getApi(API.postLocationAndBattery),
        data: {
          "latitude": "37.570853",
          "longitude": "127.078971",
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

  Future<void> testPostApiMove(Dio dio, String userNameWatch) async {
    try {
      for (int i = 0; i < 10; ++i) {
        final response = await dio.post(
          getApi(API.postLocationAndBattery),
          data: {
            "latitude": (37.570853 - i * 0.001).toString(),
            "longitude": (127.078971 + i * 0.002).toString(),
            "battery": "50",
            "isCharging": false,
          },
        );
        await Future.delayed(Duration(seconds: 1));
      }
      logger.i("움직임 끝");
    } catch (e) {
      logger.e(e);
    }
  }

  Future<FriendLocationAndBattery> testGetApi(Dio dio) async {
    return ref.watch(liveInfoRepositoryProvider).getFriendLocationAndBattery();
  }
}
