class FriendNameAndImage {
  late List<StaticInfoModel> staticInfoList;
  FriendNameAndImage({
    required this.staticInfoList,
  });

  factory FriendNameAndImage.fromJson(List<dynamic> json) {
    final List<StaticInfoModel> staticInfoList = [];
    for (var element in json) {
      final staticInfo = StaticInfoModel.fromJson(
        element,
      );
      staticInfoList.add(staticInfo);
    }
    return FriendNameAndImage(
      staticInfoList: staticInfoList,
    );
  }
}

class StaticInfoModel {
  late int userId;
  late String nickname;
  late String userTag;
  late String imageUrl;

  StaticInfoModel({
    required this.userId,
    required this.nickname,
    required this.userTag,
    required this.imageUrl,
  });
  factory StaticInfoModel.fromJson(Map<String, dynamic> json) {
    return StaticInfoModel(
      userId: json['userId'],
      nickname: json['nickname'],
      userTag: json['userTag'],
      imageUrl: json['imageUrl'],
    );
  }
}
