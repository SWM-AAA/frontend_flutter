import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/friend/widgets/friend_search_list.dart';

class FriendSearchScreen extends StatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: AppBar(
                leading: const BackButton(),
                title: const Text(
                  '네임태그로 친구추가',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                elevation: 0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SearchBar(
                elevation: const MaterialStatePropertyAll(
                  0,
                ),
                backgroundColor: const MaterialStatePropertyAll(
                  Color(0xfff9f9f9),
                ),
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
                trailing: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/svg/Search.svg',
                      ),
                      onPressed: () {
                        print(inputText);
                      },
                    ),
                  ),
                ],
                hintText: '친구 닉네임을 입력해주세요.',
                hintStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    color: Color(
                      0xffb1b5c3,
                    ),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Row(
                children: [
                  Text(
                    '검색결과',
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: const [
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: false,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                  FreindSearchList(
                    name: '김모미',
                    nameTag: '김모미#0001',
                    isFriendRequestSent: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
