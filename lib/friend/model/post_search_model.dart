import 'package:json_annotation/json_annotation.dart';

part 'post_search_model.g.dart';

@JsonSerializable()
class PostSearchModel {
  late String userTag;

  PostSearchModel({required this.userTag});
  factory PostSearchModel.fromJson(Map<String, dynamic> json) =>
      _$PostSearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$PostSearchModelToJson(this);
}
