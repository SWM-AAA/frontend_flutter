import 'package:flutter_dotenv/flutter_dotenv.dart';

enum API {
  // user
  register,
  // map
  postLocationAndBattery,
  getLocationAndBattery,
  getAllUserInfo,
}

Map<API, String> apiMap = {
  // user

  API.register: '/api/v1/users/register',

  // map
  API.postLocationAndBattery: '/api/v1/users/location-and-battery',
  API.getLocationAndBattery: '/api/v1/users/all-user-location-and-battery',
  API.getAllUserInfo: '/api/test/users/all-user-information',
};
String BASE_URL = dotenv.env['AAA_PUBLIC_API_BASE'].toString();
