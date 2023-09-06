import 'package:flutter/material.dart';

class FriendRequestList extends StatelessWidget {
  final String name, nameTag;
  const FriendRequestList(
      {super.key, required this.name, required this.nameTag});

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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffB4F5AE),
              borderRadius: BorderRadius.circular(23),
            ),
            child: const Icon(Icons.circle_outlined),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xffFFCACA),
              borderRadius: BorderRadius.circular(23),
            ),
            child: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
