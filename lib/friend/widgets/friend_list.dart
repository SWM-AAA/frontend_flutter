import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendList extends ConsumerWidget {
  final int id;
  final String name, nameTag, imageUrl;

  const FriendList({
    super.key,
    required this.id,
    required this.name,
    required this.nameTag,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        ],
      ),
    );
  }
}
