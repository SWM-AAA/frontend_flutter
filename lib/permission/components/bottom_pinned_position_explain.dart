import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/provider/register_dialog_screen.dart';

class BottomPinnedPositionExplain extends ConsumerWidget {
  const BottomPinnedPositionExplain({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(registeredUserInfoProvider).userName;
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$userName님,\n위치를 알려주세요',
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
            'Zeppy 앱을 통해 친구의 앱이 사용 중이 아닐 때도\n항상 친구의 위치를 확인할 수 있습니다.\n위치를 어떻게 관리하나요?',
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
            onPressed: () {},
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
            child: const Text('다음',
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
