import 'package:flutter_dotenv/flutter_dotenv.dart';

enum API {
  kakaoLogin,
  googleLogin,
}

Map<API, String> social2OauthPath = {
  API.kakaoLogin: '/oauth2/authorization/kakao',
  API.googleLogin: '/oauth2/authorization/google',
};

String getApiUri(API api) {
  String apiUri = dotenv.env['AAA_PUBLIC_API_BASE'].toString();
  apiUri += social2OauthPath[api]!;
  return apiUri;
}
