import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'friend_info_model.g.dart';

// 터미널 명령어 flutter pub run build_runner build

class FriendLocationAndBattery {
  late List<FriendInfoModel> friendInfoList;
  FriendLocationAndBattery({
    required this.friendInfoList,
  });

  factory FriendLocationAndBattery.fromJson({
    required Map<String, dynamic> json,
  }) {
    final List<FriendInfoModel> friendInfoList = [];
    json['result'].forEach(
      (key, value) {
        final friendInfo = FriendInfoModel.fromJson(
          json: {key: value},
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
  late String userNameTag;
  late LiveInfoModel liveInfo;
  FriendInfoModel({
    required this.userNameTag,
    required this.liveInfo,
  });

  factory FriendInfoModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return FriendInfoModel(
      userNameTag: json.keys.first,
      liveInfo: LiveInfoModel.fromJson(json.values.first),
    );
  }
}

@JsonSerializable()
class LiveInfoModel {
  late String longitude;
  late String latitude;
  late String battery;
  late bool isCharging;
  LiveInfoModel({
    required this.longitude,
    required this.latitude,
    required this.battery,
    required this.isCharging,
  });
  factory LiveInfoModel.fromJson(Map<String, dynamic> json) => _$LiveInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$LiveInfoModelToJson(this);

  // factory LiveInfoModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return LiveInfoModel(
  //     longitude: json['longitude'],
  //     latitude: json['latitude'],
  //     battery: json['battery'],
  //     isCharging: json['isCharging'],
  //   );
  // }
}
