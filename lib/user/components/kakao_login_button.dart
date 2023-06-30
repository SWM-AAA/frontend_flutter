import 'package:flutter/material.dart';

class KakaoLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const KakaoLoginButton({
    Key? key,
    this.width = 320,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 80,
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(
          'assets/images/kakao/login_button.png',
        ),
      ),
    );
  }
}
