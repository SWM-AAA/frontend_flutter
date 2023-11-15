import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/provider/register_dialog_screen.dart';
import 'package:frontend/friend/model/friend_request_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/screens/search_screen.dart';
import 'package:frontend/friend/widgets/add_friend_card.dart';

import '../widgets/friend_request_list.dart';

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  @override
  Future<List<FriendRequestModel>>? requests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requests = ref.read(friendRepositoryProvider).getFriendRequestList();
  }

  refetch() {
    setState(() {
      requests = ref.read(friendRepositoryProvider).getFriendRequestList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(registeredUserInfoProvider).userName;

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
                  '친구요청',
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
            Expanded(
              child: FutureBuilder<List<FriendRequestModel>>(
                future: requests,
                builder: (context, snapshot) {
                  Widget receivedFriendRequestWidget;
                  if (snapshot.hasData) {
                    print(snapshot.data!.length);
                    if (snapshot.data!.isEmpty) {
                      receivedFriendRequestWidget = const SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('친구 요청이 없습니다.'),
                          ],
                        ),
                      );
                    } else {
                      receivedFriendRequestWidget = SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final friendRequestList = snapshot.data!;
                            return FriendRequestList(
                              id: friendRequestList[index].userId,
                              name: friendRequestList[index].nickname,
                              nameTag: friendRequestList[index].userTag,
                              imageUrl: friendRequestList[index].imageUrl,
                              refetch: refetch,
                            );
                          },
                          childCount: snapshot.data!.length,
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    receivedFriendRequestWidget = SliverToBoxAdapter(
                      child: Text("${snapshot.error}"),
                    );
                  } else {
                    receivedFriendRequestWidget = const SliverToBoxAdapter(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(children: [
                          AddFreindCard(
                              icon: SvgPicture.asset(
                                'assets/svg/nameTag.svg',
                              ),
                              name: '네임태그로 친구추가',
                              iconBackGroundColor: const Color(0xffFFEBE4),
                              clickHandler: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FriendSearchScreen()));
                              }),
                          // AddFreindCard(
                          //   icon: SvgPicture.asset(
                          //     'assets/svg/call-off.svg',
                          //   ),
                          //   name: '전화번호로 친구추가',
                          //   iconBackGroundColor: const Color(0xffDEF5E9),
                          //   clickHandler: () {},
                          // ),
                          // AddFreindCard(
                          //   icon: SvgPicture.asset(
                          //     'assets/svg/screen rotate.svg',
                          //   ),
                          //   iconBackGroundColor: const Color(0xffEBECFF),
                          //   name: '흔들어서 추가',
                          //   clickHandler: () {},
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '내 유저 태그: $userInfo',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 12),
                                child: Row(
                                  children: [
                                    Text(
                                      '친구 요청 목록',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Pretendard',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ]),
                      ),
                      receivedFriendRequestWidget,
                    ],
                  );
                },
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
