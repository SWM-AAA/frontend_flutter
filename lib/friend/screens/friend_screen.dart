import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/provider/register_dialog_screen.dart';
import 'package:frontend/friend/model/friend_model.dart';
import 'package:frontend/friend/model/friend_request_model.dart';
import 'package:frontend/friend/repository/friend_repository.dart';
import 'package:frontend/friend/screens/request_screen.dart';
import 'package:frontend/friend/screens/search_screen.dart';
import 'package:frontend/friend/widgets/add_friend_card.dart';
import 'package:frontend/friend/widgets/friend_list.dart';
import 'package:indexed/indexed.dart';

import '../widgets/friend_request_list.dart';

class FriendScreen extends ConsumerStatefulWidget {
  const FriendScreen({super.key});

  @override
  ConsumerState<FriendScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<FriendScreen> {
  @override
  Future<List<FriendModel>>? requests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requests = ref.read(friendRepositoryProvider).getFriendList();
  }

  refetch() {
    setState(() {
      requests = ref.read(friendRepositoryProvider).getFriendList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(friendRepositoryProvider);

    return DefaultLayout(
      child: SafeArea(
        child: Indexer(
          children: [
            Indexed(
              index: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RequestScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.white, // <-- Button color
                            foregroundColor: Colors.red, // <-- Splash color
                          ),
                          child: const Icon(Icons.add_outlined,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: AppBar(
                    title: const Text(
                      '친구 목록',
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
                  child: FutureBuilder(
                      future: requests,
                      builder: (context, snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var data in snapshot.data!)
                                  FriendList(
                                    id: data.userId,
                                    name: data.nickname,
                                    nameTag: data.userTag,
                                    imageUrl: data.imageUrl,
                                  ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('친구가 없습니다.'),
                          );
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
          ],
        ),
      ),
    );
  }
}
