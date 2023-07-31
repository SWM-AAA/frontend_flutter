import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/components/const/data.dart';
import 'package:frontend/custom_map/components/const/type.dart';
import 'package:frontend/custom_map/components/marker/custom_marker.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
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
        addMarker(await createMarker(
          MarkerInfo(
            markerId: randomNumber.toString(),
            userName: '휘서',
            imagePath: MY_PROFILE_IMAGE_PATH,
          ),
          LatLng(37.540853, 127.078971),
        ));
      },
      child: Text("maker"),
    );
  }
}
