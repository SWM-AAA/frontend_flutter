class SearchFriendToRequestListModel {
  late List<SearchFriendToRequestModel> friendRequestList;
  SearchFriendToRequestListModel({
    required this.friendRequestList,
  });
  factory SearchFriendToRequestListModel.fromJson(List<Map<String, Object>> json) {
    final List<SearchFriendToRequestModel> friendRequestList = [];
    json.forEach(
      (element) {
        final friendRequest = SearchFriendToRequestModel.fromJson(
          element,
        );
        friendRequestList.add(friendRequest);
      },
    );
    return SearchFriendToRequestListModel(
      friendRequestList: friendRequestList,
    );
  }
}

class SearchFriendToRequestModel {
  late int userId;
  late String nickname;
  late String userTag;
  late String imageUrl;
  late bool isRequested;
  SearchFriendToRequestModel({
    required this.userId,
    required this.nickname,
    required this.userTag,
    required this.imageUrl,
    required this.isRequested,
  });
  factory SearchFriendToRequestModel.fromJson(Map<String, dynamic> json) {
    return SearchFriendToRequestModel(
      userId: json['userId'],
      nickname: json['nickname'],
      userTag: json['userTag'],
      imageUrl: json['imageUrl'],
      isRequested: json['isRequested'],
    );
  }
}
