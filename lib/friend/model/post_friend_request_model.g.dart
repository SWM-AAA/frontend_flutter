// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_friend_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostFriendRequestModel _$PostFriendRequestModelFromJson(
        Map<String, dynamic> json) =>
    PostFriendRequestModel(
      userId: json['userId'] as int,
      accept: json['accept'] as bool,
    );

Map<String, dynamic> _$PostFriendRequestModelToJson(
        PostFriendRequestModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'accept': instance.accept,
    };
