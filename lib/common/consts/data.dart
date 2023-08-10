import 'dart:io';

// Kakao Token key (expire - Access Token 12 hours, Refresh Token 2 months
const KAKAO_ACCESS_TOKEN_KEY = 'KAKAO_ACCESS_TOKEN';
const KAKAO_REFRESH_TOKEN_KEY = 'KAKAO_REFRESH_TOKEN';
const KAKAO_REFRESH_TOKEN_EXPIRES_AT_KEY = 'KAKAO_REFRESH_TOKEN_EXPIRES_AT';

// Zeppy Token key
const ACCESS_TOKEN_KEY = 'access_token';
const REFRESH_TOKEN_KEY = 'refresh_token';
const IS_FIRST = 'is_first';

// ip
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

final deviceIp = Platform.isIOS ? simulatorIp : emulatorIp;

// app anme
const APP_NAME = 'Zeppy';
// app scheme
const APP_SCHEME = 'com.aaa';

const DEFAULT_USER_NAME = 'No Name';
// 유저 기본 프로필 이미지 경로
const MY_PROFILE_IMAGE_PATH = 'assets/images/profile_pictures/user_profile.jpeg';
const MY_PROFILE_DEFAULT_IMAGE_PATH = 'assets/images/profile_pictures/default_profile.png';
const USER_PROFILE_IMAGE_FILE_PATH = 'assets/images/profile_pictures/default_profile.png';
