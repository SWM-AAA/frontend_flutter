import 'package:flutter/material.dart';

class AppleLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const AppleLoginButton({
    Key? key,
    this.width = 320,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 60,
      child: IconButton(
        onPressed: onPressed,
        icon: Image.asset(
          'assets/images/apple/login_button.png',
        ),
      ),
    );
  }
}
