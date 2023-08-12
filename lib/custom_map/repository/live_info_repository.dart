import 'package:dio/dio.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:retrofit/retrofit.dart';

part 'live_info_repository.g.dart';

@RestApi()
abstract class LiveInfoRepository {
  // base:
  factory LiveInfoRepository(Dio dio, {String baseUrl}) = _LiveInfoRepository;

  @GET('/api/v1/users/all-user-location-and-battery')
  Future<FriendLocationAndBattery> getFriendLocationAndBattery();

  // 섹션6-3 강의
}
