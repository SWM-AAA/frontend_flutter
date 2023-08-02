import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/components/const/data.dart';
import 'package:frontend/custom_map/components/const/type.dart';
import 'package:frontend/custom_map/components/custom_google_map.dart';
import 'package:frontend/custom_map/components/marker/custom_marker.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
import 'package:frontend/custom_map/components/test_button/create_init_marker_button.dart';
import 'package:frontend/custom_map/components/test_button/delete_all_marker_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
  final List<Marker> markers = [];

  CameraPosition initCameraPosition = const CameraPosition(
    // 건국대 position
    target: LatLng(
      37.540853,
      127.078971,
    ),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    currentLocation = getCurrentIfPossible();
    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

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
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 18);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    updateMyMarkerPosition(latLng);
  }

  // 현재 위치를 표시하는 빨간색 마커, 내 위치를 다른 아이콘으로 표기하고싶을때 사용할것같다.
  void updateMyMarkerPosition(LatLng latLng) async {
    MarkerInfo markerInfo = MarkerInfo(
      markerId: 'I',
      userName: '휘서',
      imagePath: MY_PROFILE_IMAGE_PATH,
    );
    Marker newMarker = await createMarker(markerInfo, latLng);

    setState(() {
      // markers.removeWhere((element) => element.markerId.value == 'I');
      // markers.add(newMarker);
      int index = markers.indexWhere((element) => element.markerId.value == 'I');
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
        SizedBox(
          height: 400,
          child: CustomGoogleMap(
            initCameraPosition: initCameraPosition,
            markers: markers,
            updateControllerOnMapCreated: (GoogleMapController controller) {
              setState(() {
                googleMapController = controller;
              });
            },
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          CreateInitMarkerButton(
            addMarker: (Marker marker) {
              setState(() {
                markers.add(marker);
                logger.v("marker");
              });
            },
          ),
          DeleteAllMarkerButton(
            deleteAllMarker: () {
              setState(() {
                print('fsdf');
                markers.clear();
              });
            },
          )
        ]),
      ],
    );
  }
}
