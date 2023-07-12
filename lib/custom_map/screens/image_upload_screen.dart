import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  final ImagePicker picker = ImagePicker();
  File? image;

  @override
  Widget build(BuildContext context) {
    // 나중에 DefaultLayout으로 감싸줄 거라 바로 Container부터 들어가도 됩니다.
    // 화면 테스트해야 하면 Scaffold 씌워서 main.dart에 넣기
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: renderAppBar(),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  XFile? pickedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    image = File(pickedImage!.path);
                  });
                },
                child: Text("image upload"),
              ),
              image == null
                  ? Text("no image")
                  : Image.file(
                      image!,
                      height: 200,
                      width: 200,
                    )
            ],
          ),
        ));
  }

  AppBar? renderAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color.fromARGB(255, 215, 119, 119),
      // elevation은 Appbar가 앞으로 튀어나온 듯한 효과를 줌
      elevation: 0,
      title: Text(
        'IMAGE UPLOAD',
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      // AppBar위에 올라가는 위젯들의 색상을 지정
      foregroundColor: Colors.black,
    );
  }
}
