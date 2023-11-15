import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/friend/model/post_friend_request_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/widgets/friend_dialog.dart';

class FriendSearchList extends ConsumerWidget {
  final int id;
  final String name, nameTag, imageUrl;
  final bool isFriendRequestSent;
  final Function refetch;

  const FriendSearchList({
    super.key,
    required this.id,
    required this.name,
    required this.nameTag,
    required this.isFriendRequestSent,
    required this.imageUrl,
    required this.refetch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(friendRepositoryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(23),
            ),
            clipBehavior: Clip.hardEdge,
            child: Image.network(imageUrl),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  nameTag,
                  style: const TextStyle(
                      color: Color(0xff353945),
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.3),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => FriendDialog(
                  text: isFriendRequestSent
                      ? '$nameTag에게\n요청을 이미 전송하였습니다.'
                      : '$nameTag에게\n친구를 요청하시겠습니까?',
                  onClickOK: () async {
                    if (!isFriendRequestSent) {
                      await repository.postFriendRequest(
                          PostFriendRequestModel(userId: id));
                      refetch();
                    }
                    Navigator.pop(context);
                  },
                ),
              );
            },
            child: isFriendRequestSent
                ? Container(
                    alignment: AlignmentDirectional.center,
                    width: 81,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xff2d73ff),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '요청중',
                          style: TextStyle(
                            color: Color(0xff2d73ff),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                            letterSpacing: -0.28,
                          ),
                        ),
                        // const SizedBox(
                        //   width: 4,
                        // ),
                        // SvgPicture.asset(
                        //   'assets/svg/blueClose.svg',
                        // ),
                      ],
                    ))
                : Container(
                    alignment: AlignmentDirectional.center,
                    width: 81,
                    height: 33,
                    decoration: BoxDecoration(
                      color: const Color(0xff2d73ff),
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: const Text(
                      '친구요청',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Pretendard',
                        letterSpacing: -0.28,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
