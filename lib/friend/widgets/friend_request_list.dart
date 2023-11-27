import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/friend/model/post_friend_response_model.dart';
import 'package:frontend/friend/provider/friend_list_provider.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/widgets/friend_dialog.dart';

class FriendRequestList extends ConsumerWidget {
  final int id;
  final String name, nameTag, imageUrl;
  final Function refetch;

  const FriendRequestList({
    super.key,
    required this.name,
    required this.nameTag,
    required this.id,
    required this.imageUrl,
    required this.refetch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(friendRepositoryProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(23),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(imageUrl),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  nameTag,
                  style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      letterSpacing: -0.3),
                ),
              ],
            ),
          ),
          // Container(
          //   width: 42,
          //   height: 42,
          //   decoration: BoxDecoration(
          //     color: const Color(0xffB4F5AE),
          //     borderRadius: BorderRadius.circular(23),
          //   ),
          //   child: const Icon(Icons.circle_outlined),
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xff2d73ff),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => FriendDialog(
                      text: '$nameTag님의\n친구요청을 수락하시겠습니까?',
                      onClickOK: () async {
                        Navigator.pop(context);
                        await repository
                            .postFriendResponse(PostFriendResponseModel(
                          userId: id,
                          accept: true,
                        ));
                        refetch();
                        await ref
                            .read(friendListProvider.notifier)
                            .getFriendList();
                      },
                    ),
                  );
                }),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xffb1b5c3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => FriendDialog(
                      text: '$nameTag님의\n친구요청을 거절하시겠습니까?',
                      onClickOK: () async {
                        await repository
                            .postFriendResponse(PostFriendResponseModel(
                          userId: id,
                          accept: false,
                        ));
                        refetch();
                        Navigator.pop(context);
                      },
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
