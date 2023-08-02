import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/custom_text_from.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/user/consts/data.dart';

class RegisterDialogScreen extends ConsumerStatefulWidget {
  const RegisterDialogScreen({super.key});

  @override
  ConsumerState<RegisterDialogScreen> createState() => _RegisterDialogScreenState();
}

class _RegisterDialogScreenState extends ConsumerState<RegisterDialogScreen> {
  String userRealName = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 40.0,
              ),
              const Text(
                userNameRegisterNote,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Expanded(
                child: CustomTextForm(
                  onChanged: (value) {
                    userRealName = value;
                  },
                  customHintText: '이름을 입력해주세요!',
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                onPressed: () {
                  if (userRealName != '') {
                    ref.read(userNameProvider.notifier).update((state) => userRealName);
                  }
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const RootTab(),
                      ),
                      (route) => false);
                },
                child: const Text('Zeppy 시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
