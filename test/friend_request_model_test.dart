import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:frontend/friend/model/friend_request_model.dart';

void main() {
  test('FriendRequestListModel JSON Serialization and Deserialization', () {
    const json = '''
      [
    {
        "userId": 1,
        "nickname": "유형석",
        "userTag": "유형석#0001",
        "imageUrl": "http://k.kakaocdn.net/dn/NTlng/btsiOItaLg4/IFk69ICIuy8FaKHqx5w9Sk/img_110x110.jpg"
    },
    {
        "userId": 4,
        "nickname": "fl",
        "userTag": "fl#0001",
        "imageUrl": "https://zeppy-test.s3.ap-northeast-2.amazonaws.com/user/profile-image/4"
    },
    {
        "userId": 5,
        "nickname": "seven",
        "userTag": "seven#0001",
        "imageUrl": "https://zeppy-test.s3.ap-northeast-2.amazonaws.com/user/profile-image/5"
    }
]
    ''';

    final parsedJson = jsonDecode(json);

    final model = FriendRequestListModel.fromJson(parsedJson);

    expect(model.friendRequestList, isA<List<FriendRequestModel>>());
    expect(model.friendRequestList.length, parsedJson.length);
    expect(model.friendRequestList[2].userId, 'user_5');
  });
}
