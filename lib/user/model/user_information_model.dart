import 'package:json_annotation/json_annotation.dart';

part 'user_information_model.g.dart';

@JsonSerializable()
class UserInformationModel {
  late String accessToken;
  late String userTag;
  late int userId;
  late String imageUrl;
  UserInformationModel({
    required this.accessToken,
    required this.userTag,
    required this.userId,
    required this.imageUrl,
  });

  factory UserInformationModel.fromJson(Map<String, dynamic> json) =>
      _$UserInformationModelFromJson(json);
}
