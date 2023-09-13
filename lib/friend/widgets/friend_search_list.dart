import 'package:flutter/material.dart';
import 'package:frontend/friend/widgets/friend_dialog.dart';

class FreindSearchList extends StatelessWidget {
  final String name, nameTag;
  final bool isFriendRequestSent;
  const FreindSearchList(
      {super.key,
      required this.name,
      required this.nameTag,
      required this.isFriendRequestSent});

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                Text(nameTag),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context, builder: (_) => const FriendDialog());
            },
            child: Container(
              alignment: AlignmentDirectional.center,
              width: 100,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(23),
              ),
              child: isFriendRequestSent
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '요청중',
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.close),
                      ],
                    )
                  : const Text(
                      '친구요청',
                      style: TextStyle(fontSize: 20),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
