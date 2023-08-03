import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/custom_text_from.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/user/consts/data.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RegisterDialogScreen extends ConsumerStatefulWidget {
  const RegisterDialogScreen({super.key});

  @override
  ConsumerState<RegisterDialogScreen> createState() => _RegisterDialogScreenState();
}

class _RegisterDialogScreenState extends ConsumerState<RegisterDialogScreen> {
  String userRealName = '';
  File? userProfileImageFile;
  final ImagePicker picker = ImagePicker();

  Future pickImage() async {
    try {
      // image picker를 통해 이미지를 선택하고, 선택된 이미지를 가져옴
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage == null) return;
      File? imageFile = File(pickedImage.path);
      imageFile = await _cropImage(imageFile: imageFile);
      setState(() {
        // file들의 경로만 받아서 저장
        userProfileImageFile = imageFile;
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        uiSettings: [
          IOSUiSettings(
            title: 'Edit Image',
          ),
          AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: const Color.fromARGB(255, 39, 39, 39),
            toolbarWidgetColor: Colors.white,
          ),
        ]);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

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
                flex: 1,
                child: CustomTextForm(
                  onChanged: (value) {
                    userRealName = value;
                  },
                  customHintText: '이름을 입력해주세요!',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  // behavior: HitTestBehaviorType.translucent,
                  onTap: () async {
                    pickImage();
                  },
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)), color: Colors.grey.shade300),
                      child: Center(
                        child: userProfileImageFile == null
                            ? const Text(
                                'No image',
                                style: TextStyle(fontSize: 15),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.file(
                                  userProfileImageFile!,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                )),
                      ),
                    ),
                  ),
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
                onPressed: () async {
                  if (userRealName != '') {
                    ref.read(registeredUserInfoProvider.notifier).setUserName(userRealName);
                  }
                  // getting a directory path for saving
                  if (userProfileImageFile != null) {
                    final Directory directory = await getApplicationDocumentsDirectory();
                    final String userProfileImageFilePath = directory.path + '/user_profile_image.png';
                    final File newImage = await userProfileImageFile!.copy(userProfileImageFilePath);
                    ref.read(registeredUserInfoProvider.notifier).setUserImage(userProfileImageFilePath);
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
