import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/friend/widgets/friend_dialog.dart';

class FriendRequestList extends StatelessWidget {
  final String name, nameTag;
  const FriendRequestList(
      {super.key, required this.name, required this.nameTag});

  @override
  Widget build(BuildContext context) {
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
                      onClickOK: () {
                        print('ok');
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
                      onClickOK: () {
                        print('ok');
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
