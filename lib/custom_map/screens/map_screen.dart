import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
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
  late Future<Position> currentLocation = getCurrentIfPossible();
  late LocationSettings locationSettings;
  late StreamSubscription<Position> positionStream;

  late GoogleMapController googleMapController;
  final List<Marker> markers = [];
  int dummy = 2;
  @override
  void initState() {
    super.initState();
    currentLocation = getCurrentIfPossible();
    logger.e(currentLocation);
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

  Future<void> updateMapCameraPosition(Position position) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 12);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    updateMyMarkerPosition(latLng);
  }

  // 현재 위치를 표시하는 빨간색 마커, 내 위치를 다른 아이콘으로 표기하고싶을때 사용할것같다.
  void updateMyMarkerPosition(LatLng latLng) {
    Marker marker = Marker(
      markerId: const MarkerId('current_location'),
      position: latLng,
    );
    setState(() {
      markers.clear();

      markers.add(marker);
    });
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
  void dispose() {
    // 끝날때 스트리밍 종료
    positionStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
        ]),
      ],
    );
  }

  // map camera를 현재위치로 이동
  Future<void> goToCurrentPosition() async {
    final GoogleMapController controller = await googleMapController;
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    logger.w('Location: ${position.latitude}, ${position.longitude}');

    CameraPosition currentCamera = CameraPosition(
      // 다른 파라미터로는  bearing과 tilt가 있다
      target: LatLng(
        position.latitude,
        position.longitude,
      ),
      zoom: 19.151926040649414,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(currentCamera));
  }

  // 위치권한이 있다면 현재 위치 불러오기
  Future<Position> getCurrentIfPossible() async {
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

    return await Geolocator.getCurrentPosition();
  }
}
