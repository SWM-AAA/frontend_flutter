import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KakaoLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const KakaoLoginButton({
    Key? key,
    this.width = 280,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xfffee500),
        ),
        width: width,
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svg/kakao.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                '카카오 로그인',
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    color: Color(0xff000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
