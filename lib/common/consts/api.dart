import 'package:flutter_dotenv/flutter_dotenv.dart';

enum API {
  // user
  kakaoLogin,
  googleLogin,
  register,
  // map
  postLocationAndBattery,
  getLocationAndBattery,
  getAllUserInfo,
}

Map<API, String> apiMap = {
  // user
  API.kakaoLogin: '/oauth2/authorization/kakao',
  API.googleLogin: '/oauth2/authorization/google',
  API.register: '/api/v1/users/register',

  // map
  API.postLocationAndBattery: '/api/v1/users/location-and-battery',
  API.getLocationAndBattery: '/api/v1/users/all-user-location-and-battery',
  API.getAllUserInfo: '/api/test/users/all-user-information',
};
String BASE_URL = dotenv.env['AAA_PUBLIC_API_BASE'].toString();
// String BASE_URL = 'https://d2e7-125-177-98-67.ngrok-free.app';

String getApi(API apiType) {
  String api = BASE_URL;

  api += apiMap[apiType]!;
  return api;
}
