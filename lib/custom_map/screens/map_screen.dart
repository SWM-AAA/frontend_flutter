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
  late GoogleMapController googleMapController;
  final List<Marker> markers = [];
  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: MarkerId("1"),
        draggable: true,
        onTap: () => print("Marker!"),
        position: LatLng(37.540853, 127.078971),
        infoWindow: InfoWindow(
          title: 'Marker Title Fourth ',
          snippet: 'My Custom Subtitle',
        ),
      ),
    );
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
            mapToolbarEnabled: true,
            buildingsEnabled: false,
            myLocationButtonEnabled: true,
            myLocationEnabled: true, // 내 위치를 중앙 파란점 + 방향 화살표
            compassEnabled: false, // 맵 회전시 다시 북쪽을 향하게하는 나침반
            markers: Set.from(markers),
          ),
        ),
      ],
    );
  }
}
