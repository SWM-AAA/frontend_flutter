import 'dart:io';

// Kakao Token key (expire - Access Token 12 hours, Refresh Token 2 months
const KAKAO_ACCESS_TOKEN_KEY = 'KAKAO_ACCESS_TOKEN';
const KAKAO_REFRESH_TOKEN_KEY = 'KAKAO_REFRESH_TOKEN';
const KAKAO_REFRESH_TOKEN_EXPIRES_AT_KEY = 'KAKAO_REFRESH_TOKEN_EXPIRES_AT';

// Zeppy Token key
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// ip
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

final deviceIp = Platform.isIOS ? simulatorIp : emulatorIp;

// app anme
const APP_NAME = 'Zeppy';
