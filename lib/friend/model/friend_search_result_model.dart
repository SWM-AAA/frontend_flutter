import 'package:json_annotation/json_annotation.dart';

part 'friend_search_result_model.g.dart';

@JsonSerializable()
class FriendSearchResultModel {
  late int userId;
  late String nickname;
  late String userTag;
  late String imageUrl;
  late bool relationship;
  late bool friend;
  FriendSearchResultModel({
    required this.userId,
    required this.nickname,
    required this.userTag,
    required this.imageUrl,
    required this.relationship,
    required this.friend,
  });
  factory FriendSearchResultModel.fromJson(Map<String, dynamic> json) =>
      _$FriendSearchResultModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendSearchResultModelToJson(this);
}
