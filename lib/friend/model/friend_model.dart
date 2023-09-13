class FriendListModel {
  late List<FriendModel> friendRequestList;
  FriendListModel({
    required this.friendRequestList,
  });
  factory FriendListModel.fromJson(List<Map<String, Object>> json) {
    final List<FriendModel> friendRequestList = [];
    json.forEach(
      (element) {
        final friendRequest = FriendModel.fromJson(
          element,
        );
        friendRequestList.add(friendRequest);
      },
    );
    return FriendListModel(
      friendRequestList: friendRequestList,
    );
  }
}

class FriendModel {
  late int userId;
  late String nickname;
  late String userTag;
  late String imageUrl;
  FriendModel({
    required this.userId,
    required this.nickname,
    required this.userTag,
    required this.imageUrl,
  });
  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      userId: json['userId'],
      nickname: json['nickname'],
      userTag: json['userTag'],
      imageUrl: json['imageUrl'],
    );
  }
}
