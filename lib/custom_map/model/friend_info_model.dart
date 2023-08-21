// 터미널 명령어 flutter pub run build_runner build

class FriendLocationAndBattery {
  late List<UserLiveInfoModel> friendInfoList;
  FriendLocationAndBattery({
    required this.friendInfoList,
  });

  factory FriendLocationAndBattery.fromJson(Map<String, dynamic> json) {
    final List<UserLiveInfoModel> friendInfoList = [];
    json['result'].forEach(
      (key, value) {
        final friendInfo = UserLiveInfoModel.fromJson(
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

class UserLiveInfoModel {
  late String userId;
  late LiveInfoModel liveInfo;
  UserLiveInfoModel({
    required this.userId,
    required this.liveInfo,
  });

  factory UserLiveInfoModel.fromJson(Map<String, dynamic> json) {
    return UserLiveInfoModel(
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
