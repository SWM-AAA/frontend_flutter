import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/friend/model/search_friend_to_request_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/widgets/friend_search_list.dart';
import 'package:logger/logger.dart';

class FriendSearchScreen extends ConsumerStatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  ConsumerState<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends ConsumerState<FriendSearchScreen> {
  String inputText = '';
  var logger = Logger();

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
            FutureBuilder<Widget>(
              future: testGetFriendRequestList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Widget> testGetFriendRequestList() async {
    // try {
    //   dynamic result = await ref.watch(friendRepositoryProvider).getSearchUserTag('김모미#0001');
    //   logger.w(result);
    //   return FreindSearchList(
    //     name: '김모미',
    //     nameTag: '김모미#0001',
    //     isFriendRequestSent: false,
    //   );
    // } catch (e) {
    //   logger.e(e);
    //   return Text("검색 결과가 없습니다.");
    // }
    final searchFriendToRequestModel = SearchFriendToRequestModel(
      userId: 1,
      nickname: '김모미',
      userTag: '김모미#0001',
      imageUrl: 'https://picsum.photos/200',
      isRequested: false,
    );
    return FreindSearchList(
      name: searchFriendToRequestModel.nickname,
      nameTag: searchFriendToRequestModel.userTag,
      isFriendRequestSent: searchFriendToRequestModel.isRequested,
    );
  }
}
