import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'friend_info_model.g.dart';

// 터미널 명령어 flutter pub run build_runner build
@JsonSerializable()
class FriendLocationAndBattery {
  late List<FriendInfoModel> friendInfoList;
  FriendLocationAndBattery({
    required this.friendInfoList,
  });
  factory FriendLocationAndBattery.fromJson(Map<String, dynamic> json) => _$FriendLocationAndBatteryFromJson(json);
  Map<String, dynamic> toJson() => _$FriendLocationAndBatteryToJson(this);

  // factory FriendLocationAndBattery.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return FriendLocationAndBattery(
  //     friendInfoList: List<FriendInfoModel>.from(
  //       json['data'].map(
  //         (entry) => FriendInfoModel.fromJson(json: entry),
  //       ),
  //     ),
  //   );
  // }
}

@JsonSerializable()
class FriendInfoModel {
  late String userNameTag;
  late LiveInfoModel liveInfo;
  FriendInfoModel({
    required this.userNameTag,
    required this.liveInfo,
  });
  factory FriendInfoModel.fromJson(Map<String, dynamic> json) => _$FriendInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendInfoModelToJson(this);

  // factory FriendInfoModel.fromJson({
  //   required Map<String, dynamic> json,
  // }) {
  //   return FriendInfoModel(
  //     userNameTag: json.keys.first,
  //     liveInfo: LiveInfoModel.fromJson(json: json.values.first),
  //   );
  // }
}

@JsonSerializable()
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
