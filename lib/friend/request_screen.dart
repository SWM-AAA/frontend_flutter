import 'package:flutter/material.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/friend/widgets/add_friend_card.dart';

import 'widgets/friend_request_list.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    size: 40,
                  ),
                ),
                const Text(
                  '친구 요청',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            const AddFreindCard(icon: Icons.badge_outlined, name: '네임태그로 친구추가'),
            const AddFreindCard(icon: Icons.call, name: '전화번호로 친구추가'),
            const AddFreindCard(icon: Icons.edgesensor_high, name: '흔들어서 추가'),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: const SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '친구 요청 목록',
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FriendRequestList(
                    name: '김모미',
                    nameTag: '김모미#0009',
                  ),
                  FriendRequestList(
                    name: '김모미',
                    nameTag: '김모미#0009',
                  ),
                  FriendRequestList(
                    name: '김모미',
                    nameTag: '김모미#0009',
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
