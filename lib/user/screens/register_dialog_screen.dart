import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/components/custom_text_from.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/provider/register_dialog_screen.dart';
import 'package:frontend/common/secure_storage/secure_storage.dart';
import 'package:frontend/user/consts/data.dart';
import 'package:frontend/user/model/user_information_model.dart';
import 'package:frontend/user/utils/route.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:frontend/common/consts/data.dart';

class RegisterDialogScreen extends ConsumerStatefulWidget {
  const RegisterDialogScreen({super.key});

  @override
  ConsumerState<RegisterDialogScreen> createState() =>
      _RegisterDialogScreenState();
}

class _RegisterDialogScreenState extends ConsumerState<RegisterDialogScreen> {
  String userRealName = '';
  File? userProfileImageFile;
  final logger = Logger();

  Future pickImageFromDevice() async {
    try {
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 30,
      );

      if (pickedImage == null) {
        // TODO: 이전 버전 스마트폰에서 null값이 됨.
        return;
      }
      File? imageFile = File(pickedImage.path);

      File? croppedImageFile;
      try {
        croppedImageFile = await cropImageRectangle(imageFile: imageFile);
      } catch (e) {
        logger.e(e);
      }
      setState(() {
        userProfileImageFile = croppedImageFile ?? imageFile;
      });
    } on PlatformException catch (e) {
      logger.e(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> cropImageRectangle({required File imageFile}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        uiSettings: [
          IOSUiSettings(
            title: 'crop rectangle Image',
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

  Future<void> postRegisterData(Dio dio, secureStorage) async {
    var postName = userRealName == '' ? DEFAULT_USER_NAME : userRealName;
    MultipartFile postImageData = await selectValidImageData();
    try {
      var formData = FormData.fromMap(
        {
          'profileimage': postImageData,
          'nickname': postName,
        },
      );
      ref.read(registeredUserInfoProvider.notifier).setUserName(userRealName);
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;
      dio.options.headers = {};
      final response = await dio.post(
        getApi(API.register),
        data: formData,
      );
      logger.w("postRegisterData response : ${response.data}");

      await updateUserInfo(response, secureStorage);

      dio.options.contentType = 'application/json';
    } catch (e) {
      logger.e(e);
    }
  }

  Future<MultipartFile> selectValidImageData() async {
    var postImageData = userProfileImageFile != null
        ? await MultipartFile.fromFile(userProfileImageFile!.path,
            filename: userProfileImageFile!.path.split('/').last)
        : await createMultipartFileFromAssets(MY_PROFILE_DEFAULT_IMAGE_PATH);
    return postImageData;
  }

  Future<MultipartFile> createMultipartFileFromAssets(String assetPath) async {
    Uint8List imageBytes = await loadAssetImage(assetPath);
    String fileName = assetPath.split('/').last;
    return MultipartFile.fromBytes(
      imageBytes,
      filename: fileName,
    );
  }

  Future<Uint8List> loadAssetImage(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<void> updateUserInfo(Response<dynamic> response, secureStorage) async {
    var userInformationModel = UserInformationModel.fromJson(response.data);
    await secureStorage.write(
        key: ACCESS_TOKEN_KEY, value: userInformationModel.accessToken);
    await secureStorage.write(
        key: USER_TAG, value: userInformationModel.userTag);
    await secureStorage.write(
        key: USER_ID, value: userInformationModel.userId.toString());
    await secureStorage.write(
        key: PROFILE_URL, value: userInformationModel.imageUrl);
    ref
        .read(registeredUserInfoProvider.notifier)
        .setUserImage(userInformationModel.imageUrl);
  }

  Future<void> saveRegisterData(BuildContext context) async {
    final secureStorage = ref.read(secureStorageProvider);
    if (userRealName != '') {
      ref.read(registeredUserInfoProvider.notifier).setUserName(userRealName);
    }
    if (userProfileImageFile != null) {
      String userProfileImageFilePath =
          await secureStorage.read(key: PROFILE_URL) ?? '';
      ref
          .read(registeredUserInfoProvider.notifier)
          .setUserImage(userProfileImageFilePath);
    }
  }

  // Future<String> saveImageInDeviceDirectory() async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   const String userProfileImageFilePath = MY_PROFILE_DEFAULT_IMAGE_PATH;
  //   final File newImage =
  //       await userProfileImageFile!.copy(userProfileImageFilePath);
  //   return userProfileImageFilePath;
  // }

  @override
  Widget build(BuildContext context) {
    final dio = ref.watch(dioProvider);
    final secureStorage = ref.watch(secureStorageProvider);

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
                  onTap: () async {
                    pickImageFromDevice();
                  },
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color: Colors.grey.shade300),
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
                  if (userRealName == '') return;
                  await postRegisterData(dio, secureStorage);
                  // await saveRegisterData(context);

                  moveToPermissionScreen(context);
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
