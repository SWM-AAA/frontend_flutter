// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_information_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInformationModel _$UserInformationModelFromJson(
        Map<String, dynamic> json) =>
    UserInformationModel(
      access_token: json['access_token'] as String,
      user_tag: json['user_tag'] as String,
      user_id: json['user_id'] as int,
    );

Map<String, dynamic> _$UserInformationModelToJson(
        UserInformationModel instance) =>
    <String, dynamic>{
      'access_token': instance.access_token,
      'user_tag': instance.user_tag,
      'user_id': instance.user_id,
    };
