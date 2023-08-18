import 'package:flutter/material.dart';

class BasicLoginButton extends StatelessWidget {
  final double? width;
  final void Function()? onPressed;
  const BasicLoginButton({
    Key? key,
    this.width = 320,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.black54)),
        onPressed: () {
          onPressed!();
        },
        child: Text('LOGIN',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}
