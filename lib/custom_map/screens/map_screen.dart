import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/model/type.dart';
import 'package:frontend/custom_map/components/custom_google_map.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:frontend/custom_map/components/test_button/create_init_marker_button.dart';
import 'package:frontend/custom_map/components/test_button/delete_all_marker_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MapScreen extends StatefulWidget {
  final String userName;
  final String userProfileImagePath;

  const MapScreen({
    super.key,
    required this.userName,
    required this.userProfileImagePath,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // 로그관리를 위한 변수
  var logger = Logger();
  late Future<Position> currentLocation;
  late LocationSettings locationSettings;
  late StreamSubscription<Position> positionStream;

  late GoogleMapController googleMapController;
  double cameraZoom = 15;
  final List<Marker> markers = [];

  CameraPosition initCameraPosition = const CameraPosition(
    // 건국대 position
    target: LatLng(
      37.540853,
      127.078971,
    ),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    currentLocation = getCurrentIfPossible();
    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    logger.w(widget.userName);
    logger.w(widget.userProfileImagePath);

    positionStream = Geolocator.getPositionStream(
            locationSettings: locationSettings) // 최소 1m 움직였을때 listen해서 아래 updateMapCameraPosition 실행
        .listen((Position position) {
      logger.w("Position: $position");
      updateMapCameraPosition(position);
    });
  }

  @override
  void dispose() {
    // 끝날때 스트리밍 종료
    positionStream.cancel();
    super.dispose();
  }

  // 위치권한이 있다면 현재 위치 불러오기
  Future<Position> getCurrentIfPossible() async {
    checkLocationPermisstion();
    return await Geolocator.getCurrentPosition();
  }

  void checkLocationPermisstion() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  Future<void> updateMapCameraPosition(Position position) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: cameraZoom);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    updateMyMarkerPosition(latLng);
  }

  // 현재 위치를 표시하는 빨간색 마커, 내 위치를 다른 아이콘으로 표기하고싶을때 사용할것같다.
  void updateMyMarkerPosition(LatLng latLng) async {
    String userMarkerId = 'I';
    await updateMarkerLocation(userMarkerId, latLng);
  }

  Future<void> updateMarkerLocation(String userMarkerId, LatLng latLng) async {
    MarkerInfo markerInfo = MarkerInfo(
      markerId: userMarkerId,
      userName: widget.userName,
      imagePath: widget.userProfileImagePath,
    );
    Marker newMarker = await googleUserMarker(markerInfo, latLng);

    setState(() {
      // markers.removeWhere((element) => element.markerId.value == 'I');
      // markers.add(newMarker);
      int index = markers.indexWhere((element) => element.markerId.value == userMarkerId);
      if (index != -1) {
        markers[index] = newMarker;
      } else {
        markers.add(newMarker);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // height: 400,
          child: CustomGoogleMap(
            initCameraPosition: initCameraPosition,
            markers: markers,
            updateControllerOnMapCreated: (GoogleMapController controller) {
              setState(() {
                googleMapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPosition) {
              setState(() {
                cameraZoom = cameraPosition.zoom;
              });
            },
          ),
        ),
      ],
    );
  }
}
