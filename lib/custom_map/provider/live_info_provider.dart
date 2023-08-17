import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/repository/live_info_repository.dart';

final liveInfoProvider = StateNotifierProvider<LiveInfoStateNotifier, List<FriendInfoModel>>((ref) {
  final repository = ref.watch(liveInfoRepositoryProvider);
  final notifier = LiveInfoStateNotifier(repository: repository);
  return notifier;
});

class LiveInfoStateNotifier extends StateNotifier<List<FriendInfoModel>> {
  final LiveInfoRepository repository;
  LiveInfoStateNotifier({
    required this.repository,
  }) : super([]) {
    // 이 notifier가 생성되는 순간 get을 실행한다.
    getFriendLocationAndBattery();
  }
  // [] 상태를 바라보다, 변경되면 렌더링
  // 캐시하는것을 future builder가 아닌 state notifier로 직접구현
  getFriendLocationAndBattery() async {
    final response = await repository.getFriendLocationAndBattery();
    state = response.friendInfoList;
  }
}
