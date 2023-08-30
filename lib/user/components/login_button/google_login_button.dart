import 'package:flutter/material.dart';

class GoogleLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;

  const GoogleLoginButton({
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
          'assets/images/google/google_login_button.png',
        ),
      ),
    );
  }
}
