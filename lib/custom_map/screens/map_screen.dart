import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final Completer<GoogleMapController> googleMapController =
        Completer<GoogleMapController>();
    Set<Marker> mapMarkers = {};

    const CameraPosition initCameraPosition = CameraPosition(
      // 건국대 position
      target: LatLng(
        37.540853,
        127.078971,
      ),
      zoom: 14.4746,
    );
    // void addMarkerRandomFromInitPosition() {
    //   int randomInt = Random().nextInt(100);
    //   LatLng latLng = LatLng(
    //     37.540853 + (randomInt * 0.001),
    //     127.078971 + (randomInt * 0.001),
    //   );
    //   Marker marker = Marker(
    //     markerId: MarkerId(randomInt.toString()),
    //     position: latLng,
    //   );
    //   print('Location ${randomInt}: ${latLng.latitude}, ${latLng.longitude}');

    //   setState(() {
    //     mapMarkers.add(marker);
    //   });
    // }

    return Column(
      children: [
        SizedBox(
          height: 500,
          child: Stack(children: [
            GoogleMap(
              mapType: MapType.normal, // hybrid, normal
              initialCameraPosition: initCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                googleMapController.complete(controller);
              },
              myLocationEnabled: true, // 내 위치를 중앙 파란점 + 방향 화살표
              myLocationButtonEnabled: true, // 우측 상단 내위치로 버튼
              compassEnabled: true, // 맵 회전시 다시 북쪽을 향하게하는 나침반
              mapToolbarEnabled: false, // 모르겠음
              markers: mapMarkers,
            ),
          ]),
        ),
        // IconButton(
        //   onPressed: addMarkerRandomFromInitPosition,
        //   icon: Icon(Icons.add_location_alt_outlined),
        //   iconSize: 30,
        // ),
      ],
    );
  }
}
