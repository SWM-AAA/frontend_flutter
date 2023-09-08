import 'package:flutter/material.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/friend/model/friend_request_model.dart';
import 'package:frontend/friend/widgets/add_friend_card.dart';

import '../widgets/friend_request_list.dart';

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
                BackButton(
                  onPressed: () {},
                ),
                const Text(
                  '친구 요청',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  AddFreindCard(
                    icon: Icons.badge_outlined,
                    name: '네임태그로 친구추가',
                  ),
                  AddFreindCard(
                    icon: Icons.call,
                    name: '전화번호로 친구추가',
                  ),
                  AddFreindCard(
                    icon: Icons.edgesensor_high,
                    name: '흔들어서 추가',
                  ),
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
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: FutureBuilder<FriendRequestListModel>(
                            future: testGetFriendRequestList(),
                            builder: (context, AsyncSnapshot<FriendRequestListModel> snapshot) {
                              if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              } else if (!snapshot.hasData) {
                                return Text("친구 신청이 없습니다.");
                              } else if (snapshot.hasData) {
                                // return Text("data");
                                final friendRequestList = snapshot.data!.friendRequestList;
                                return ListView.separated(
                                  // shrinkWrap: true,
                                  itemCount: snapshot.data!.friendRequestList.length,
                                  itemBuilder: (context, index) {
                                    return FriendRequestList(
                                      name: friendRequestList[index].nickname,
                                      nameTag: friendRequestList[index].userTag,
                                    );
                                  },
                                  separatorBuilder: (_, index) {
                                    return SizedBox(
                                      height: 1,
                                    );
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                        // FriendRequestList(
                        //   name: '김모미',
                        //   nameTag: '김모미#0009',
                        // ),
                        // FriendRequestList(
                        //   name: '김모미',
                        //   nameTag: '김모미#0009',
                        // ),
                        // FriendRequestList(
                        //   name: '김모미',
                        //   nameTag: '김모미#0009',
                        // ),
                        // FriendRequestList(
                        //   name: '김모미',
                        //   nameTag: '김모미#0009',
                        // ),
                        // FriendRequestList(
                        //   name: '김모미',
                        //   nameTag: '김모미#0009',
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<FriendRequestListModel> testGetFriendRequestList() async {
    final friendRequestList = [
      FriendRequestModel(
        userId: 1,
        nickname: '김모미',
        userTag: '김모미#0001',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 2,
        nickname: '나모미',
        userTag: '나모미#0002',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 3,
        nickname: '다모미',
        userTag: '다모미#0003',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 4,
        nickname: '라모미',
        userTag: '라모미#0004',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 5,
        nickname: '마모미',
        userTag: '마모미#0005',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 5,
        nickname: '마모미',
        userTag: '마모미#0005',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 5,
        nickname: '마모미',
        userTag: '마모미#0005',
        imageUrl: 'https://picsum.photos/200',
      ),
      FriendRequestModel(
        userId: 5,
        nickname: '마모미',
        userTag: '마모미#0005',
        imageUrl: 'https://picsum.photos/200',
      ),
    ];
    return FriendRequestListModel(
      friendRequestList: friendRequestList,
    );
  }
}
