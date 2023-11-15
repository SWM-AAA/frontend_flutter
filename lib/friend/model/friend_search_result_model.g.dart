// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_search_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendSearchResultModel _$FriendSearchResultModelFromJson(
        Map<String, dynamic> json) =>
    FriendSearchResultModel(
      userId: json['userId'] as int,
      nickname: json['nickname'] as String,
      userTag: json['userTag'] as String,
      imageUrl: json['imageUrl'] as String,
      relationship: json['relationship'] as bool,
    );

Map<String, dynamic> _$FriendSearchResultModelToJson(
        FriendSearchResultModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'nickname': instance.nickname,
      'userTag': instance.userTag,
      'imageUrl': instance.imageUrl,
      'relationship': instance.relationship,
    };
