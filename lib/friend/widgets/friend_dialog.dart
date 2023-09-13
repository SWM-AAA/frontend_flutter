import 'package:flutter/material.dart';

class FriendDialog extends StatelessWidget {
  const FriendDialog({super.key});

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
              const Text(
                '땡땡김#0001에게',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const Text(
                '친구를 요청하시겠습니까?',
                style: TextStyle(
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
                      onPressed: () {}),
                  FilledButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xff3B71FE)),
                        // fixedSize: MaterialStatePropertyAll(
                        //   Size(125, 45),
                        // ),
                      ),
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
                      ),
                      onPressed: () {}),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
