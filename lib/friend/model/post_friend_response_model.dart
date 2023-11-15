import 'package:json_annotation/json_annotation.dart';

part 'post_friend_response_model.g.dart';

@JsonSerializable()
class PostFriendResponseModel {
  late int userId;
  late bool isAccept;
  PostFriendResponseModel({
    required this.userId,
    required this.isAccept,
  });
  factory PostFriendResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PostFriendResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostFriendResponseModelToJson(this);
}
