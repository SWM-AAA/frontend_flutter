// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformationModel _$UserInformationModelFromJson(
        Map<String, dynamic> json) =>
    UserInformationModel(
      accessToken: json['accessToken'] as String,
      userTag: json['userTag'] as String,
      userId: json['userId'] as int,
      imageUrl: json['imageUrl'] as String,
    );

Map<String, dynamic> _$UserInformationModelToJson(
        UserInformationModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'userTag': instance.userTag,
      'userId': instance.userId,
      'imageUrl': instance.imageUrl,
    };
