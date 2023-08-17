// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveInfoModel _$LiveInfoModelFromJson(Map<String, dynamic> json) => LiveInfoModel(
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      battery: json['battery'] as int,
      isCharging: json['isCharging'] as bool,
    );

Map<String, dynamic> _$LiveInfoModelToJson(LiveInfoModel instance) => <String, dynamic>{
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'battery': instance.battery,
      'isCharging': instance.isCharging,
    };
