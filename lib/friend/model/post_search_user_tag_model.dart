import 'package:json_annotation/json_annotation.dart';

part 'post_search_user_tag_model.g.dart';

@JsonSerializable()
class PostSearchUserTagModel {
  late String userTag;
  PostSearchUserTagModel({
    required this.userTag,
  });
  factory PostSearchUserTagModel.fromJson(Map<String, dynamic> json) => _$PostSearchUserTagModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostSearchUserTagModelToJson(this);
}
