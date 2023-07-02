import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/user/components/kakao_login_button.dart';
import 'package:frontend/user/screens/register_dialog_screen.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
        final checkRegisterResp = await dio.post(
            dotenv.env['AAA_PUBLIC_API_BASE'].toString(),
            data: {'memberEmail': '${user.kakaoAccount?.email}'});
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

    void processKakaoLogin() async {
      //REMOVE: 아직 IOS 플랫폼 등록을 하지 않아 임시로 안드로이드에서만 카카오 로그인을 테스트합니다.
      if (Platform.isIOS) {
        moveToRootTab();
        return;
      }
      // OAuthToken? resp;
      // // INFO: 앱 키 해시 확인 코드
      // // final keyHash = await KakaoSdk.origin;
      // // print('카카오 키해시: $keyHash');
      // if (await isKakaoTalkInstalled()) {
      //   try {
      //     resp = await UserApi.instance.loginWithKakaoTalk();
      //   } catch (error) {
      //     print('카카오톡 앱으로 로그인에 실패하였습니다: Error: $error');

      //     // 사용자가 카카오톡 설치 후 디바이스 권한 요청에서 로그인 취소 시
      //     // 의도적 실패로 간주 카카오계정으로 로그인 시도 없이 로그인 취소 처리
      //     if (error is PlatformException && error.code == 'CANCLED') {
      //       return;
      //     }

      //     // 카카오에 연결된 카카오 계정이 없을 때, 카카오 계정 로그인 호출
      //     try {
      //       resp = await UserApi.instance.loginWithKakaoAccount();
      //     } catch (error) {
      //       print('카카오 계정으로 로그인에 실패하였습니다: Error: $error');
      //       return;
      //     }
      //   }
      // } else {
      //   try {
      //     resp = await UserApi.instance.loginWithKakaoAccount();
      //   } catch (error) {
      //     print('카카오 계정으로 로그인에 실패하였습니다: Error: $error');
      //     return;
      //   }
      // }

      // await secureStorage.write(
      //     key: KAKAO_REFRESH_TOKEN_KEY, value: resp.refreshToken);
      // await secureStorage.write(
      //     key: KAKAO_ACCESS_TOKEN_KEY, value: resp.accessToken);
      // await secureStorage.write(
      //     key: KAKAO_REFRESH_TOKEN_EXPIRES_AT_KEY,
      //     value: resp.refreshTokenExpiresAt.toString());

      try {
        final user = await UserApi.instance.me();
        //final isRegistered = await requestCheckUserRegistered(user);
        if (false) {
          //TODO: 사용자가 이미 가입되어 있는 상태라면 바로 Zeppy에
          // Refresh Token, AccessToken받는 request 호출하기
          moveToRootTab();
        } else {
          //TODO: 사용자가 가입되어 있지 않은 상태라면 사용자 실명 받는 팝업 띄우기
          showRegisterDialog();
        }
      } catch (error) {
        throw Exception('사용자 정보 요청 실패 $error');
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
