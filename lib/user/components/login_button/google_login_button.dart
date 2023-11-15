import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
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
                'assets/svg/Google_Logo.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Google 계정으로 로그인',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff4285f4),
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
