// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_friend_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFriendResponseModel _$PostFriendResponseModelFromJson(
        Map<String, dynamic> json) =>
    PostFriendResponseModel(
      userId: json['userId'] as int,
      isAccept: json['isAccept'] as bool,
    );

Map<String, dynamic> _$PostFriendResponseModelToJson(
        PostFriendResponseModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'isAccept': instance.isAccept,
    };
