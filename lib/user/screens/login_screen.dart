import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';

import 'package:frontend/user/components/apple_login_button.dart';
import 'package:frontend/user/components/google_login_button.dart';

import 'package:frontend/user/components/kakao_login_button.dart';
import 'package:frontend/user/screens/register_dialog_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';

import '../../common/consts/data.dart';
import '../utils/oauth_apis.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  var logger = Logger();
  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);
    final secureStorage = ref.watch(secureStorageProvider);

    void moveToRootTab() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false);
    }

    Future<bool> requestCheckUserRegistered(User user) async {
      if (user.kakaoAccount?.email != null) {
        final checkRegisterResp = await dio
            .post(dotenv.env['AAA_PUBLIC_API_BASE'].toString(), data: {'memberEmail': '${user.kakaoAccount?.email}'});
        return checkRegisterResp.data['isRegistered'];
      } else {
        throw Exception('email 정보 없음');
      }
    }

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

        final accessToken = Uri.parse(webAuthResp).queryParameters[ACCESS_TOKEN_KEY];
        final refreshToken = Uri.parse(webAuthResp).queryParameters[REFRESH_TOKEN_KEY];

        final isFirst = Uri.parse(webAuthResp).queryParameters[IS_FIRST];
        logger.i(accessToken);
        logger.i(refreshToken);
        logger.i(isFirst);

        await secureStorage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
        await secureStorage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

        if (isFirst == 'true') {
          showRegisterDialog();
        } else {
          moveToRootTab();
        }
      } catch (e) {
        log(e.toString());
      }
    }

    void oAuthLoginPressed(API api) {
      signInOAuth(getApiUri(api));
    }

    void onKakaoLoginButtonClick() {
      oAuthLoginPressed(API.kakaoLogin);
    }

    void onGoogleLoginButtonClick() {
      oAuthLoginPressed(API.googleLogin);
    }

    return DefaultLayout(
      backgroundDecorationImage: const DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          'assets/images/backgrounds/sample_background.png',
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const AnimatedAppName(),
                    Column(
                      children: [
                        KakaoLoginButton(
                          onPressed: onKakaoLoginButtonClick,
                        ),
                        GoogleLoginButton(
                          onPressed: onGoogleLoginButtonClick,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
