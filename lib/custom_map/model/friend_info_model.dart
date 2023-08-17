import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

// 터미널 명령어 flutter pub run build_runner build

class FriendLocationAndBattery {
  late List<FriendInfoModel> friendInfoList;
  FriendLocationAndBattery({
    required this.friendInfoList,
  });

  factory FriendLocationAndBattery.fromJson(Map<String, dynamic> json) {
    final List<FriendInfoModel> friendInfoList = [];
    json['result'].forEach(
      (key, value) {
        final friendInfo = FriendInfoModel.fromJson(
          {key: value},
        );
        friendInfoList.add(friendInfo);
      },
    );
    return FriendLocationAndBattery(
      friendInfoList: friendInfoList,
    );
  }
}

class FriendInfoModel {
  late String userId;
  late LiveInfoModel liveInfo;
  FriendInfoModel({
    required this.userId,
    required this.liveInfo,
  });

  factory FriendInfoModel.fromJson(Map<String, dynamic> json) {
    return FriendInfoModel(
      userId: json.keys.first,
      liveInfo: LiveInfoModel.fromJson(json.values.first),
    );
  }
}

class LiveInfoModel {
  late double longitude;
  late double latitude;
  late int battery;
  late bool isCharging;
  LiveInfoModel({
    required this.longitude,
    required this.latitude,
    required this.battery,
    required this.isCharging,
  });
  factory LiveInfoModel.fromJson(Map<String, dynamic> json) {
    return LiveInfoModel(
      longitude: double.tryParse(json["longitude"]) ?? 0.0,
      latitude: double.tryParse(json["latitude"]) ?? 0.0,
      battery: int.tryParse(json["battery"]) ?? 0,
      isCharging: json['isCharging'],
    );
  }
}
