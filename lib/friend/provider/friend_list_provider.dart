import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/friend/model/friend_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';

final friendListProvider =
    StateNotifierProvider<FriendListNotifier, List<FriendModel>>((ref) {
  final provider = ref.watch(friendRepositoryProvider);
  return FriendListNotifier(provider: provider);
});

class FriendListNotifier extends StateNotifier<List<FriendModel>> {
  FriendRepository provider;
  FriendListNotifier({required this.provider}) : super([]) {
    getFriendList();
  }

  Future<void> getFriendList() async {
    final response = await provider.getFriendList();
    state = response;
  }
}
