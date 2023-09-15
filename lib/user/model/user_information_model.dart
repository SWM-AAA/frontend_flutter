import 'package:json_annotation/json_annotation.dart';

part 'user_information_model.g.dart';

@JsonSerializable()
class UserInformationModel {
  late String access_token;
  late String user_tag;
  late int user_id;

  UserInformationModel({
    required this.access_token,
    required this.user_tag,
    required this.user_id,
  });
  factory UserInformationModel.fromJson(Map<String, dynamic> json) =>
      _$UserInformationModelFromJson(json);
}
