import 'package:json_annotation/json_annotation.dart';

part 'post_friend_request_model.g.dart';

@JsonSerializable()
class PostFriendRequestModel {
  late int userId;
  late bool accept;
  PostFriendRequestModel({
    required this.userId,
    required this.accept,
  });
  factory PostFriendRequestModel.fromJson(Map<String, dynamic> json) => _$PostFriendRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostFriendRequestModelToJson(this);
}
