import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/riverpod/register_dialog_screen.dart';
import 'package:frontend/custom_map/components/test_button/update_markers_button.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/components/custom_google_map.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/model/static_info_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  var logger = Logger();

  late Future<Position> currentLocation;
  late LocationSettings locationSettings;
  late StreamSubscription<Position> locationStream;

  late GoogleMapController googleMapController;
  double cameraZoom = 15;
  final List<Marker> markers = [];

  CameraPosition initCameraPosition = const CameraPosition(
    target: LatLng(
      37.540853,
      127.078971,
    ),
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();

    // createMyMarker();
    createFriendMarker();

    currentLocation = getCurrentIfPossible();
    locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );
    locationStream = Geolocator.getPositionStream(locationSettings: locationSettings) // 최소 1m 움직였을때 listen
        .listen((Position position) {
      updateMapCameraPosition(position);
      postMyLocation(position);
    });
  }

  @override
  void dispose() {
    locationStream.cancel();
    markers.clear();
    super.dispose();
  }

  Future<void> createMyMarker() async {
    String userMarkerId = "user_4"; // TODO: 서버에서 내 정보 받아야함.

    final userName = ref.read(registeredUserInfoProvider).userName;
    final userProfileImagePath = ref.read(registeredUserInfoProvider).userProfileImagePath;

    StaticInfoModel markerInfo = StaticInfoModel(
      userId: userMarkerId,
      nickname: userName,
      userTag: userName + '#0001',
      imageUrl: userProfileImagePath,
    );
    Marker userMarker = await _initRandomLocationMarker(markerInfo, ImageType.Directory);
    setState(() {
      markers.add(userMarker);
    });
  }

  Future<void> createFriendMarker() async {
    var response = await getUserInfo();
    List<StaticInfoModel> markerInfoList = FriendNameAndImage.fromJson(response.data).staticInfoList;

    for (var userMarkerInfo in markerInfoList) {
      Marker userMarker = await _initRandomLocationMarker(userMarkerInfo, ImageType.Network);
      setState(() {
        markers.add(userMarker);
      });
    }
  }

  Future<dynamic> getUserInfo() async {
    final dio = ref.read(dioProvider);
    var response;
    try {
      response = await dio.get(getApi(API.getAllUserInfo));
    } catch (e) {
      logger.e(e);
    }
    return response;
  }

  Future<Marker> _initRandomLocationMarker(StaticInfoModel userMarkerInfo, ImageType imageType) async {
    // -0.01 ~ 0.01 사이의 랜덤 변위값 생성
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
      imageType,
    );
    return thisMarker;
  }

  Future<Position> getCurrentIfPossible() async {
    checkLocationPermission();
    return await Geolocator.getCurrentPosition();
  }

  void checkLocationPermission() async {
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
      logger.i("postMyLocation 성공 업로드 ${response.statusCode.toString()} ", position);
    } catch (e) {
      logger.e(e);
    }
  }

  Future<void> updateMapCameraPosition(Position position) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: cameraZoom);
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    await updateMyMarkerLocation(latLng);
  }

  Future<void> updateMyMarkerLocation(LatLng latLng) async {
    LiveInfoModel myLiveInfoModel = LiveInfoModel(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      battery: 50,
      isCharging: false,
    );
    UserLiveInfoModel myInfoModel = UserLiveInfoModel(
      userId: 'user_4', // TODO: 서버에서 내 정보 받아야함.
      liveInfo: myLiveInfoModel,
    );
    setState(() {
      updateMarkerLocation(myInfoModel);
    });
  }

  void updateFriendLocation(List<UserLiveInfoModel> friendLiveInfoList) {
    for (UserLiveInfoModel newFriendLiveInfo in friendLiveInfoList) {
      updateMarkerLocation(newFriendLiveInfo);
    }
  }

  void updateMarkerLocation(UserLiveInfoModel friendInfoModel) {
    logger.w("updateMarkerLocation ${friendInfoModel.userId}");
    int index = markers.indexWhere(
      (element) => element.markerId.value == friendInfoModel.userId,
    );
    if (index != -1) {
      LatLng newLatLng = LatLng(
        friendInfoModel.liveInfo.latitude,
        friendInfoModel.liveInfo.longitude,
      );
      if (markers[index].position != newLatLng) {
        markers[index] = markers[index].copyWith(positionParam: newLatLng);
        logger.w(markers);
      } else {
        logger.w("위치가 같음 ${friendInfoModel.userId}");
      }
    } else {
      logger.w("index 못찾음 ${friendInfoModel.userId}");
      // TODO: 정보 없던 친구의 위치가 들어온 상황이므로, getInfo를 다시 수행해야함.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
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
        UpdateMarkersButton(
          updateMarkerLocation: (friendLiveInfoList) {
            setState(() {
              updateFriendLocation(friendLiveInfoList);
            });
          },
        )
      ],
    );
  }
}
