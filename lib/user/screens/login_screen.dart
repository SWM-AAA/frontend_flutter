import 'package:flutter/material.dart';
import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/user/screens/components/kakao_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    void onKakaoLoginButtonClick() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const RootTab(),
        ),
      );
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
