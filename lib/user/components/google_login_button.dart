import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const GoogleLoginButton({
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
          'assets/images/google/login_button.png',
        ),
      ),
    );
  }
}
