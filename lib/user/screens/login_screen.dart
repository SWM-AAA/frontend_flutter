import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/permission/screens/position_permission_screen.dart';
import 'package:frontend/user/components/login_button/google_login_button.dart';
import 'package:frontend/user/components/login_button/kakao_login_button.dart';
import 'package:frontend/user/components/login_policy_text.dart';
import 'package:frontend/user/screens/register_dialog_screen.dart';
import 'package:frontend/user/utils/route.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    final secureStorage = ref.watch(secureStorageProvider);

    void showRegisterDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                24,
              ),
            ),
            content: const RegisterDialogScreen(),
            insetPadding: const EdgeInsets.symmetric(vertical: 80),
          );
        },
      );
    }

    Future<void> signInOAuth(String api) async {
      try {
        var logger = Logger();
        final uri = Uri.parse('$api?redirect_url=$APP_SCHEME');
        log(uri.toString());

        final webAuthResp = await FlutterWebAuth2.authenticate(
          url: uri.toString(),
          callbackUrlScheme: APP_SCHEME,
        );

        final accessToken =
            Uri.parse(webAuthResp).queryParameters[ACCESS_TOKEN_KEY];
        final refreshToken =
            Uri.parse(webAuthResp).queryParameters[REFRESH_TOKEN_KEY];
        final userTag = Uri.parse(webAuthResp).queryParameters[USER_TAG];
        final userId = Uri.parse(webAuthResp).queryParameters[USER_ID];

        final isFirst = Uri.parse(webAuthResp).queryParameters[IS_FIRST];
        logger.i(accessToken);
        logger.i(refreshToken);
        logger.i(isFirst);
        logger.i(userTag);
        logger.i(userId);

        await secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        await secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);
        await secureStorage.write(key: USER_TAG, value: userTag);
        await secureStorage.write(key: USER_ID, value: userId);

        if (isFirst == 'true') {
          showRegisterDialog();
        } else {
          moveToPermissionScreen(context);
        }
      } catch (e) {
        log(e.toString());
      }
    }

    void oAuthLoginPressed(API api) {
      signInOAuth(getApi(api));
    }

    void onKakaoLoginButtonClick() {
      oAuthLoginPressed(API.kakaoLogin);
    }

    void onGoogleLoginButtonClick() {
      oAuthLoginPressed(API.googleLogin);
    }

    void moveToPermission() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const PositionPermissionScreen(),
          ),
          (route) => false);
    }

    return DefaultLayout(
      backgroundDecorationImage: const DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          'assets/images/backgrounds/login_blue_background.png',
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 308,
              ),
              const Text(
                '친구들과\n위치를\n공유해요',
                style: TextStyle(
                  color: Color(0xFF22252D),
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  height: 1.20,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              const SizedBox(
                height: 32,
              ),
              Column(
                children: [
                  KakaoLoginButton(
                    onPressed: onKakaoLoginButtonClick,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GoogleLoginButton(
                    onPressed: onGoogleLoginButtonClick,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const LoginPolicyText(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
