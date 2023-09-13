import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/friend/model/friend_model.dart';
import 'package:frontend/friend/model/friend_request_model.dart';
import 'package:frontend/friend/model/friend_response_model.dart';
import 'package:frontend/friend/model/post_friend_request_model.dart';
import 'package:frontend/friend/model/post_search_user_tag_model.dart';
import 'package:frontend/friend/model/search_friend_to_request_model.dart';
import 'package:retrofit/retrofit.dart';
part 'friend_repository.g.dart';

final friendRepositoryProvider = Provider(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = FriendRepository(dio, baseUrl: BASE_URL);
    return repository;
  },
);

@RestApi()
abstract class FriendRepository {
  // base
  factory FriendRepository(Dio dio, {String baseUrl}) = _FriendRepository;

  @GET('/api/v1/friends/requests')
  Future<List<FriendRequestModel>> getFriendRequestList();

  @GET('/api/v1/friends')
  Future<List<FriendModel>> getFriendList();

  @POST('/api/v1/friends/response')
  Future<void> postFriendResponse(@Body() FriendResponseModel friendResponseModel);

  @POST('/api/v1/friends/response')
  Future<void> postFriendRequest(@Body() PostFriendRequestModel postFriendRequestModel);

  @GET('/api/v1/users/search/usertag')
  Future<HttpResponse<SearchFriendToRequestModel>> getSearchUserTag(@Query('userTag') String userTag);
}
