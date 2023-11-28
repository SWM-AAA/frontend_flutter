import 'package:json_annotation/json_annotation.dart';

part 'friend_response_model.g.dart';

@JsonSerializable()
class FriendResponseModel {
  late int userId;
  late bool accept;
  FriendResponseModel({
    required this.userId,
    required this.accept,
  });
  factory FriendResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FriendResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$FriendResponseModelToJson(this);
}
