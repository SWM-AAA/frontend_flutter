import 'package:flutter/material.dart';
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  '친구',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onFieldSubmitted: (text) {
                        print(text);
                      },
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        hintText: '닉네임을 입력해주세요.',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        setState(() {
                          inputText = text;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          print(inputText);
                        },
                        icon: const Icon(Icons.search)),
                  )
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
