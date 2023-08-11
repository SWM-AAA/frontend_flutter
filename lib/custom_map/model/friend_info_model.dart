class FriendLocationAndBattery {
  late List<FriendInfoModel> friendInfoList;
  FriendLocationAndBattery({
    required this.friendInfoList,
  });
  factory FriendLocationAndBattery.fromJson({
    required Map<String, dynamic> json,
  }) {
    return FriendLocationAndBattery(
      friendInfoList: List<FriendInfoModel>.from(
        json['data'].map(
          (entry) => FriendInfoModel.fromJson(json: entry),
        ),
      ),
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
      liveInfo: LiveInfoModel.fromJson(json: json.values.first),
    );
  }
}

class LiveInfoModel {
  late String longitude;
  late String latitude;
  late int battery;
  late bool isCharging;
  LiveInfoModel({
    required this.longitude,
    required this.latitude,
    required this.battery,
    required this.isCharging,
  });
  factory LiveInfoModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return LiveInfoModel(
      longitude: json['longitude'],
      latitude: json['latitude'],
      battery: json['battery'],
      isCharging: json['isCharging'],
    );
  }
}
