import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/user/screens/components/kakao_login_button.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    void moveToRootTab() {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const RootTab(),
          ),
          (route) => false);
    }

    void processKakaoLogin() async {
      //REMOVE: 아직 IOS 플랫폼 등록을 하지 않아 임시로 안드로이드에서만 카카오 로그인을 테스트합니다.
      if (Platform.isIOS) {
        moveToRootTab();
        return;
      }
      OAuthToken? resp;
      // INFO: 앱 키 해시 확인 코드
      // final keyHash = await KakaoSdk.origin;
      // print('카카오 키해시: $keyHash');
      if (await isKakaoTalkInstalled()) {
        try {
          resp = await UserApi.instance.loginWithKakaoTalk();
          print(resp);
          moveToRootTab();
        } catch (error) {
          print('카카오톡으로 로그인 실패1 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청에서 로그인 취소 시
          // 의도적 실패로 간주 카카오계정으로 로그인 시도 없이 로그인 취소 처리
          if (error is PlatformException && error.code == 'CANCLED') {
            return;
          }

          // 카카오에 연결된 카카오 계정이 없을 때, 카카오 계정 로그인 호출
          try {
            resp = await UserApi.instance.loginWithKakaoAccount();
            print(resp);
            moveToRootTab();
          } catch (error) {
            print('카카오 계정으로 로그인 실패2 $error');
            return;
          }
        }
      } else {
        try {
          resp = await UserApi.instance.loginWithKakaoAccount();
          print(resp);
          moveToRootTab();
        } catch (error) {
          print('카카오 계정으로 로그인 실패3 $error');
          return;
        }
      }
    }

    void onKakaoLoginButtonClick() {
      processKakaoLogin();
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AnimatedAppName(),
                    const SizedBox(
                      height: 12.0,
                    ),
                    KakaoLoginButton(
                      onPressed: onKakaoLoginButtonClick,
                    ),
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
