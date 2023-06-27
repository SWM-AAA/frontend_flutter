import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Token key
const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// 토큰, 유저 정보와 같은 민감 정보를 저장하기 위한 보안 storage
const secureStorage = FlutterSecureStorage();

// ip
const emulatorIp = '10.0.2.2:3000';
const simulatorIp = '127.0.0.1:3000';

final deviceIp = Platform.isIOS ? simulatorIp : emulatorIp;

// app anme
const APP_NAME = 'Zeppy';
