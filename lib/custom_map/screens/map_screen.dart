import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController googleMapController;
  final List<Marker> markers = [];
  int dummy = 2;
  @override
  void initState() {
    super.initState();
  }

  CameraPosition initCameraPosition = const CameraPosition(
    // 건국대 position
    target: LatLng(
      37.540853,
      127.078971,
    ),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: GoogleMap(
            mapType: MapType.normal, // hybrid, normal
            initialCameraPosition: initCameraPosition,
            onMapCreated: (controller) {
              setState(() {
                googleMapController = controller;
              });
            },
            mapToolbarEnabled: true,
            buildingsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true, // 내 위치를 중앙 파란점 + 방향 화살표
            compassEnabled: false, // 맵 회전시 다시 북쪽을 향하게하는 나침반
            markers: Set.from(markers),
            onTap: (LatLng latLng) {
              googleMapController.animateCamera(
                CameraUpdate.newLatLng(
                  initCameraPosition.target,
                ),
              );
            },
          ),
        ),
        ElevatedButton(
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
            setState(() {
              markers.add(marker);
            });
          },
          child: Text("maker"),
        ),
        ElevatedButton(
            onPressed: () {
              setState(() {
                markers.clear();
              });
            },
            child: Text("marker clear")),
      ],
    );
  }
}
