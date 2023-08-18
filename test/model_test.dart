import 'package:flutter_test/flutter_test.dart';
import 'dart:convert';

import 'package:frontend/custom_map/model/friend_info_model.dart';

void main() {
  test('FriendLocationAndBattery JSON Serialization and Deserialization', () {
    const json = '''
      {
          "result": {
              "user_3": {
                  "latitude": "37.123456",
                  "longitude": "127.123456",
                  "battery": "90",
                  "isCharging": false
              },
              "user_2": {
                  "latitude": "37.655555",
                  "longitude": "127.123456",
                  "battery": "90",
                  "isCharging": false
              },
              "user_1": {
                  "latitude": "37.123456",
                  "longitude": "127.123456",
                  "battery": "90",
                  "isCharging": false
              }
          }
      }
    ''';

    final parsedJson = jsonDecode(json);

    final model = FriendLocationAndBattery.fromJson(parsedJson);

    expect(model.friendInfoList, isA<List<UserLiveInfoModel>>());
    expect(model.friendInfoList.length, parsedJson['result'].length);
    expect(model.friendInfoList[0].userId, 'user_3');
  });
}
