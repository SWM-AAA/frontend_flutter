import 'package:flutter/material.dart';
import 'package:frontend/common/screens/root_tab.dart';

class PermissionCompleteExplain extends StatelessWidget {
  const PermissionCompleteExplain({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '모두 완료되었습니다!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 36,
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: -0.72,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          const Text(
            '친구들과 함께 일상을 공유할 준비되셨나요?',
            style: TextStyle(
              color: Color(0xFF2C72FF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const RootTab(),
                  ),
                  (route) => false);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              backgroundColor: const Color(0xFF22252D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            child: const Text('시작하기',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                )),
          )
        ],
      ),
    );
  }
}
