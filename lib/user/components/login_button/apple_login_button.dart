import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppleLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const AppleLoginButton({
    Key? key,
    this.width = 280,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      width: width,
      height: 48,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svg/Apple_logo_white.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text(
              'Apple로 로그인',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )
          ],
        ),
      ),
    );
  }
}
