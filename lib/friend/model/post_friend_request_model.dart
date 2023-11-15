import 'package:json_annotation/json_annotation.dart';

part 'post_friend_request_model.g.dart';

@JsonSerializable()
class PostFriendRequestModel {
  late int userId;
  PostFriendRequestModel({
    required this.userId,
  });
  factory PostFriendRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PostFriendRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostFriendRequestModelToJson(this);
}
