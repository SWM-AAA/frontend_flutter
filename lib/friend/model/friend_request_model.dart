class FriendRequestListModel {
  late List<FriendRequestModel> friendRequestList;
  FriendRequestListModel({
    required this.friendRequestList,
  });
  factory FriendRequestListModel.fromJson(List<Map<String, Object>> json) {
    final List<FriendRequestModel> friendRequestList = [];
    json.forEach(
      (element) {
        final friendRequest = FriendRequestModel.fromJson(
          element,
        );
        friendRequestList.add(friendRequest);
      },
    );
    return FriendRequestListModel(
      friendRequestList: friendRequestList,
    );
  }
}

class FriendRequestModel {
  late int userId;
  late String nickname;
  late String userTag;
  late String imageUrl;
  FriendRequestModel({
    required this.userId,
    required this.nickname,
    required this.userTag,
    required this.imageUrl,
  });
  factory FriendRequestModel.fromJson(Map<String, dynamic> json) {
    return FriendRequestModel(
      userId: json['userId'],
      nickname: json['nickname'],
      userTag: json['userTag'],
      imageUrl: json['imageUrl'],
    );
  }
}
