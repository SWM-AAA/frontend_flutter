import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/custom_map/components/test_button/update_markers_button.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/model/marker_static_info_model.dart';
import 'package:frontend/custom_map/components/custom_google_map.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/components/test_button/create_init_marker_button.dart';
import 'package:frontend/custom_map/model/static_info_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String userName;
  final String userProfileImagePath;

  const MapScreen({
    super.key,
    required this.userName,
    required this.userProfileImagePath,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
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
    zoom: 14,
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
      postMyLocation(position);
    });

    initMarkerSet();
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

  Future<void> postMyLocation(Position position) async {
    final dio = ref.watch(dioProvider);

    try {
      final response = await dio.post(
        getApi(API.postLocationAndBattery),
        data: {
          "latitude": position.latitude.toString(),
          "longitude": position.longitude.toString(),
          "battery": "50",
          "isCharging": false,
        },
      );
      logger.i("성공 업로드");
      logger.w(response.statusCode);
      logger.w(response.headers);
      print(response.headers);
      logger.w(response.data);
    } catch (e) {
      logger.e(e);
    }
  }

  // 현재 위치를 표시하는 빨간색 마커, 내 위치를 다른 아이콘으로 표기하고싶을때 사용할것같다.
  void updateMyMarkerPosition(LatLng latLng) async {
    String userMarkerId = 'I';
    await updateMyMarkerLocation(userMarkerId, latLng);
  }

  Future<void> updateMyMarkerLocation(String userMarkerId, LatLng latLng) async {
    StaticInfoModel markerInfo = StaticInfoModel(
      userId: userMarkerId,
      nickname: widget.userName,
      userTag: widget.userName + '#0001',
      imageUrl: widget.userProfileImagePath,
    );
    Marker newMarker = await googleUserMarker(markerInfo, latLng, ImageType.Directory);

    setState(() {
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
          child: CustomGoogleMap(
            initCameraPosition: initCameraPosition,
            markers: markers,
            // markers: snapshot.data ?? markers,
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
        UpdateMarkersButton(
          updateMarkerLocation: (friendLiveInfoList) {
            setState(() {
              for (FriendInfoModel newFriendLiveInfo in friendLiveInfoList) {
                int index = markers.indexWhere(
                  (element) => element.markerId.value == newFriendLiveInfo.userId,
                );
                if (index != -1) {
                  LatLng newLatLng = LatLng(
                    newFriendLiveInfo.liveInfo.latitude,
                    newFriendLiveInfo.liveInfo.longitude,
                  );
                  if (markers[index].position != newLatLng) {
                    markers[index] = markers[index].copyWith(positionParam: newLatLng);
                  }
                } else {
                  // markers.add(newMarker);
                }
              }
            });
          },
        )
      ],
    );
  }

  Future<void> initMarkerSet() async {
    var response = await getUserInfo();

    List<StaticInfoModel> markerInfoList = FriendNameAndImage.fromJson(response.data).staticInfoList;

    for (var userMarkerInfo in markerInfoList) {
      Marker thisMarker = await TEST_createRandomLocationMarker(userMarkerInfo);

      setState(() {
        markers.add(thisMarker);
      });
    }
  }

  Future<Marker> TEST_createRandomLocationMarker(StaticInfoModel userMarkerInfo) async {
    double move_lat = (Random().nextInt(21) - 10) / 1000;
    double move_lng = (Random().nextInt(21) - 10) / 1000;

    Marker thisMarker = await googleUserMarker(
      StaticInfoModel(
        userId: userMarkerInfo.userId,
        nickname: userMarkerInfo.nickname,
        userTag: userMarkerInfo.userTag,
        imageUrl: userMarkerInfo.imageUrl,
      ),
      LatLng(37.540853 + move_lat, 127.078971 + move_lng),
      ImageType.Network,
    );
    return thisMarker;
  }

  Future<dynamic> getUserInfo() async {
    final dio = ref.read(dioProvider);
    var response;
    try {
      response = await dio.get(
        getApi(API.getAllUserInfo),
      );
      logger.w(response.statusCode);
      logger.w(response.headers);
      logger.w(response.data);
    } catch (e) {
      logger.e(e);
    }
    return response;
  }
}
