import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
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
}
