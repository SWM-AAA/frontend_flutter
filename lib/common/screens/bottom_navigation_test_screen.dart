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
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/repository/live_info_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
          ),
          Expanded(
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
                          Text("${item.userNameTag}"),
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

  Future<FriendLocationAndBattery> testGetApi(Dio dio) async {
    // try {
    //   logger.i("get 결과" + getApi(API.getLocationAndBattery));

    //   final response = await dio.get(getApi(API.getLocationAndBattery));
    //   logger.w(response.statusCode);
    //   logger.w(response.headers);
    //   logger.w(response.data);
    //   return response.data['result'];
    // } catch (e) {
    //   logger.e(e);
    //   return null;
    // }
    // TODO: baseUrl을 안쓰며느 dio의 기본 baseUrl로 설정되는데, 그거 나중에 설정하기

    return ref.watch(liveInfoRepositoryProvider).getFriendLocationAndBattery();
  }
}
