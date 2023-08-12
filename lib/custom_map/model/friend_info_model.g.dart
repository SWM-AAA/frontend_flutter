// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendLocationAndBattery _$FriendLocationAndBatteryFromJson(
        Map<String, dynamic> json) =>
    FriendLocationAndBattery(
      friendInfoList: (json['friendInfoList'] as List<dynamic>)
          .map((e) => FriendInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FriendLocationAndBatteryToJson(
        FriendLocationAndBattery instance) =>
    <String, dynamic>{
      'friendInfoList': instance.friendInfoList,
    };

FriendInfoModel _$FriendInfoModelFromJson(Map<String, dynamic> json) =>
    FriendInfoModel(
      userNameTag: json['userNameTag'] as String,
      liveInfo:
          LiveInfoModel.fromJson(json['liveInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FriendInfoModelToJson(FriendInfoModel instance) =>
    <String, dynamic>{
      'userNameTag': instance.userNameTag,
      'liveInfo': instance.liveInfo,
    };

LiveInfoModel _$LiveInfoModelFromJson(Map<String, dynamic> json) =>
    LiveInfoModel(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      battery: json['battery'] as int,
      isCharging: json['isCharging'] as bool,
    );

Map<String, dynamic> _$LiveInfoModelToJson(LiveInfoModel instance) =>
    <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'battery': instance.battery,
      'isCharging': instance.isCharging,
    };
