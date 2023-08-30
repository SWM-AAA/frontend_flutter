import 'package:flutter/material.dart';

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
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onPressed,
        child: Image.asset(
          'assets/images/kakao/kakao_login_button.png',
        ),
      ),
    );
  }
}
