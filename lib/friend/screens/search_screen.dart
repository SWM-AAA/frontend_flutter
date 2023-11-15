import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/friend/model/friend_search_result_model.dart';
import 'package:frontend/friend/model/post_search_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/widgets/friend_search_list.dart';

class FriendSearchScreen extends ConsumerStatefulWidget {
  const FriendSearchScreen({super.key});

  @override
  ConsumerState<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends ConsumerState<FriendSearchScreen> {
  String inputText = '';
  Future<FriendSearchResultModel>? result;
  bool isFirst = true;

  refetch() {
    setState(() {
      result = ref
          .read(friendRepositoryProvider)
          .searchUser(PostSearchModel(userTag: inputText));
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(friendRepositoryProvider);

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
                        setState(() {
                          isFirst = false;
                        });
                        Future<FriendSearchResultModel> response;
                        try {
                          response = repository
                              .searchUser(PostSearchModel(userTag: inputText));
                        } catch (error) {
                          return;
                        }
                        setState(() {
                          result = response;
                        });
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
              child: FutureBuilder(
                  future: result,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          FriendSearchList(
                            id: snapshot.data!.userId,
                            name: snapshot.data!.nickname,
                            nameTag: snapshot.data!.userTag,
                            imageUrl: snapshot.data!.imageUrl,
                            isFriendRequestSent: snapshot.data!.relationship,
                            refetch: refetch,
                          ),
                        ],
                      );
                    } else {
                      if (isFirst) {
                        return const SizedBox();
                      } else {
                        return const Center(child: Text('검색 결과가 없습니다.'));
                      }
                    }
                  }),
            )
            // Expanded(
            //   child: result == null
            //       ? isFirst == true
            //           ? const SizedBox()
            //           : const Center(
            //               child: Text('검색 결과가 없습니다.'),
            //             )
            //       : Column(
            //           children: [
            //             FriendSearchList(
            //               id: result!.userId,
            //               name: result!.nickname,
            //               nameTag: result!.userTag,
            //               imageUrl: result!.imageUrl,
            //               isFriendRequestSent: result!.relationship,
            //               refetch: refetch,
            //             ),
            //           ],
            //         ),
            // )
          ],
        ),
      ),
    );
  }
}
