import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateInitMarkerButton extends StatelessWidget {
  final List<Marker> markers;
  final Function(Marker) addMarker;
  const CreateInitMarkerButton({
    required this.markers,
    required this.addMarker,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Random random = Random();
        int randomNumber = random.nextInt(100); // 0부터 99까지의 랜덤 숫자 생성
        Marker marker = Marker(
          markerId: MarkerId(randomNumber.toString()),
          draggable: true,
          onTap: () => print("Marker!"),
          position: LatLng(37.540853, 127.078971),
          icon: await createMarkerIcon(
            'assets/images/profile_pictures/user_profile.jpeg',
            '휘서',
            Size(200.0, 200.0),
          ),
        );
        addMarker(marker);
      },
      child: Text("maker"),
    );
  }
}
