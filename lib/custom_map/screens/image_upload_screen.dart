import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  State<ImageUploadScreen> createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  // image picker 를 할 객체
  final ImagePicker picker = ImagePicker();
  // 선택된 단일 이미지를 담을 곳
  File? image;
  // 여러 이미지를 담을 리스트
  List<File>? multipleImages = [];

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
            children: [
              ElevatedButton(
                onPressed: () async {
                  // image picker를 통해 이미지를 선택하고, 선택된 이미지를 가져옴
                  List<XFile>? pickedMultipleImage =
                      await picker.pickMultiImage();
                  setState(() {
                    // file들의 경로만 받아서 저장
                    multipleImages =
                        pickedMultipleImage!.map((e) => File(e.path)).toList();
                  });
                },
                child: Text("multiple image upload"),
              ),
              multipleImages == null
                  ? Text("no image") // 불러온 이미지가 없을땐 no image 표시
                  : Expanded(
                      // child가 확장 가능한 위젯
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: multipleImages!.length,
                        itemBuilder: (context, index) {
                          // 경로를 통해 이미지를 불러온다.
                          return GridTile(
                              child: Image.file(multipleImages![index]));
                        },
                      ),
                    ),
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
