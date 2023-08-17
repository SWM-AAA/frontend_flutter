import 'package:json_annotation/json_annotation.dart';

part 'access_key_model.g.dart';

@JsonSerializable()
class UpdatedAccessKeyModel {
  late String access_token;
  UpdatedAccessKeyModel({
    required this.access_token,
  });
  factory UpdatedAccessKeyModel.fromJson(Map<String, dynamic> json) => _$UpdatedAccessKeyModelFromJson(json);
  // factory UpdatedAccessKeyModel.fromJson(Map<String, dynamic> json) {
  //   return UpdatedAccessKeyModel(
  //     access_token: json['access_token'] as String,
  //   );
  // }
}
