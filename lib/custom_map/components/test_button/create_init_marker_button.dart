import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:frontend/custom_map/model/marker_static_info_model.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:frontend/custom_map/model/static_info_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateInitMarkerButton extends StatelessWidget {
  final Function(Marker) addMarker;
  const CreateInitMarkerButton({
    required this.addMarker,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        print("dfsdfdfdfdf");
        Random random = Random();
        int randomNumber = random.nextInt(100); // 0부터 99까지의 랜덤 숫자 생성
        addMarker(await googleUserMarker(
          StaticInfoModel(
            userId: randomNumber.toString(),
            nickname: '휘서',
            userTag: '휘서#0001',
            imageUrl: MY_PROFILE_IMAGE_PATH,
          ),
          LatLng(37.540853, 127.078971),
          ImageType.Asset,
        ));
      },
      child: Text("maker"),
    );
  }
}
