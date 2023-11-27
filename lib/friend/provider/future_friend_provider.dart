import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/friend/repository/friend_repository.dart';

final futureFriendProvider = FutureProvider((ref) async {
  final repositry = ref.watch(friendRepositoryProvider);

  return repositry.getFriendList();
});
