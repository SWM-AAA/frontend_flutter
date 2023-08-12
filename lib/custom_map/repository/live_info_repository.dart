import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:retrofit/retrofit.dart';

part 'live_info_repository.g.dart';

final liveInfoRepositoryProvider = Provider(
  (ref) {
    final dio = ref.watch(dioProvider);
    final repository = LiveInfoRepository(dio, baseUrl: BASE_URL);
    return repository;
  },
);

@RestApi()
abstract class LiveInfoRepository {
  // base:
  factory LiveInfoRepository(Dio dio, {String baseUrl}) = _LiveInfoRepository;

  @GET('/api/v1/users/all-user-location-and-battery')
  Future<FriendLocationAndBattery> getFriendLocationAndBattery();

  // 섹션6-3 강의
}
