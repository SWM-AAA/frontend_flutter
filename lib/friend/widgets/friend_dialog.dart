import 'package:flutter/material.dart';

class FriendDialog extends StatelessWidget {
  final String text;
  final void Function() onClickOK;

  const FriendDialog({super.key, required this.text, required this.onClickOK});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ), //this right here
      child: SizedBox(
        height: 166,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              OverflowBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FilledButton(
                      style: const ButtonStyle(
                        foregroundColor:
                            MaterialStatePropertyAll(Color(0xff777E90)),
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xffE6E8EC)),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        child: Text(
                          '취소',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  FilledButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff3B71FE)),
                      ),
                      onPressed: onClickOK,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        child: Text(
                          '확인',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
