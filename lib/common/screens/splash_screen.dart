import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/animated_app_title.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/layouts/default_layout.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/user/screens/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  void checkToken() async {
    final secureStorage = ref.read(secureStorageProvider);
    final refreshToken = await secureStorage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await secureStorage.read(key: ACCESS_TOKEN_KEY);

    // REMOVE: token 붙이기 전까지 딜레이 임시로 줌
    await Future.delayed(const Duration(milliseconds: 1500));

    if (refreshToken == null || accessToken == null) {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
          (route) => false);
    } else {
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => const LoginScreen(), // TEST : RootTab(), 로그인 테스트를 위해 잠시 변경
          ),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();

    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      backgroundDecorationImage: DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage(
          'assets/images/backgrounds/sample_background.png',
        ),
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedAppName(),
                      SizedBox(
                        height: 56.0,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
