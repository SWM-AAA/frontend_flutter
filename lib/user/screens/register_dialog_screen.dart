import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/custom_text_from.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/common/screens/root_tab.dart';
import 'package:frontend/common/utils/api.dart';
import 'package:frontend/user/consts/data.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class RegisterDialogScreen extends ConsumerStatefulWidget {
  const RegisterDialogScreen({super.key});

  @override
  ConsumerState<RegisterDialogScreen> createState() => _RegisterDialogScreenState();
}

class _RegisterDialogScreenState extends ConsumerState<RegisterDialogScreen> {
  String userRealName = '';
  File? userProfileImageFile;
  String? testSendDataOnlyFicker;
  final ImagePicker picker = ImagePicker();
  final logger = Logger();
  Future pickImage() async {
    try {
      // image picker를 통해 이미지를 선택하고, 선택된 이미지를 가져옴
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 30, // 이미지 크기 압축을 위해 퀄리티를 30으로 낮춤.
      );
      if (pickedImage == null) return;
      String pathPickedImage = pickedImage.path;
      File? imageFile = File(pickedImage.path);

      var croppedImageFile = await _cropImage(imageFile: imageFile);
      setState(() {
        // file들의 경로만 받아서 저장
        testSendDataOnlyFicker = pathPickedImage;
        userProfileImageFile = croppedImageFile;
      });
    } on PlatformException catch (e) {
      logger.e(e);
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
    final dio = ref.watch(dioProvider);

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
                  // customErrorText: '한글로 2자 이상 6자 이내로 입력해주세요.',
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
                  // await postRegisterData(dio);
                  await saveInputData(context);

                  routeRootTab(context);
                },
                child: const Text('Zeppy 시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postRegisterData(Dio dio) async {
    var postName = userRealName == '' ? DEFAULT_USER_NAME : userRealName;
    var postImageData = testSendDataOnlyFicker ?? MY_PROFILE_DEFAULT_IMAGE_PATH;
    var formData = FormData.fromMap(
      {
        'image': await MultipartFile.fromFile(postImageData),
        'name': postName,
      },
    );
    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite; //??
      final response = await dio.post(
        getApi(API.register),
        data: formData,
      );
      logger.i("성공 업로드");
      logger.w(response.statusCode);
      logger.w(response.headers);
      logger.w(response.data);
    } catch (e) {
      logger.e(e);
    }
  }

  void routeRootTab(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const RootTab(),
        ),
        (route) => false);
  }

  Future<void> saveInputData(BuildContext context) async {
    if (userRealName != '') {
      ref.read(registeredUserInfoProvider.notifier).setUserName(userRealName);
    }
    // getting a directory path for saving
    if (userProfileImageFile != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String userProfileImageFilePath = directory.path + '/user_profile_image.png';
      final File newImage = await userProfileImageFile!.copy(userProfileImageFilePath);
      logger.w(directory);
      ref.read(registeredUserInfoProvider.notifier).setUserImage(userProfileImageFilePath);
    }
  }
}
