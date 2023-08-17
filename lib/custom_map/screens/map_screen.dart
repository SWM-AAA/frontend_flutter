import 'dart:async';
import 'dart:math';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/api.dart';
import 'package:frontend/common/dio/dio.dart';
import 'package:frontend/common/utils/api.dart';
import 'package:frontend/custom_map/model/type.dart';
import 'package:frontend/custom_map/components/custom_google_map.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:frontend/custom_map/components/test_button/create_init_marker_button.dart';
import 'package:frontend/custom_map/components/test_button/delete_all_marker_button.dart';
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

class _MapScreenState extends ConsumerState<MapScreen> with TickerProviderStateMixin {
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

    // positionStream = Geolocator.getPositionStream(
    //         locationSettings: locationSettings) // 최소 1m 움직였을때 listen해서 아래 updateMapCameraPosition 실행
    //     .listen((Position position) {
    //   logger.w("Position: $position");
    //   updateMapCameraPosition(position);
    //   postMyLocation(position);
    // });
    //Starting the animation after 1 second.
    Future.delayed(const Duration(seconds: 1)).then((value) {
      animateCar(
        37.540853,
        127.078971,
        37.550853,
        127.068971,
        mapMarkerSink,
        this,
        googleMapController,
      );
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

  final mapMarkerStreamController = StreamController<List<Marker>>();
  StreamSink<List<Marker>> get mapMarkerSink => mapMarkerStreamController.sink;
  Stream<List<Marker>> get mapMarkerStream => mapMarkerStreamController.stream;
  Animation<double>? _animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          // height: 400,
          child: StreamBuilder<List<Marker>>(
            stream: mapMarkerStream,
            builder: (context, snapshot) {
              return CustomGoogleMap(
                initCameraPosition: initCameraPosition,
                markers: snapshot.data ?? markers,
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
              );
            },
          ),
        ),
      ],
    );
  }

  setUpMarker() async {
    const currentLocationCamera = LatLng(37.42796133580664, -122.085749655962);
    MarkerInfo markerInfo = MarkerInfo(
      markerId: currentLocationCamera.latitude.toString(),
      userName: widget.userName,
      imagePath: widget.userProfileImagePath,
    );
    Marker pickupMarker = await googleUserMarker(
      markerInfo,
      LatLng(currentLocationCamera.latitude, currentLocationCamera.longitude),
    );

    //Adding a delay and then showing the marker on screen
    await Future.delayed(const Duration(milliseconds: 500));

    markers.add(pickupMarker);
    mapMarkerSink.add(markers);
  }

  animateCar(
    double fromLat, //Starting latitude
    double fromLong, //Starting longitude
    double toLat, //Ending latitude
    double toLong, //Ending longitude
    StreamSink<List<Marker>> mapMarkerSink, //Stream build of map to update the UI
    TickerProvider provider, //Ticker provider of the widget. This is used for animation
    GoogleMapController controller, //Google map controller of our widget
  ) async {
    markers.clear();
    MarkerInfo markerInfo = MarkerInfo(
      markerId: "driverMarker",
      userName: widget.userName,
      imagePath: widget.userProfileImagePath,
    );
    Marker carMarker = await googleUserMarker(
      markerInfo,
      LatLng(fromLat, fromLong),
      // anchor: const Offset(0.5, 0.5),
    );

    //Adding initial marker to the start location.
    markers.add(carMarker);
    mapMarkerSink.add(markers);

    final animationController = AnimationController(
      duration: const Duration(seconds: 3), //Animation duration of marker
      vsync: provider, //From the widget
    );

    Tween<double> tween = Tween(begin: 0, end: 3);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        //We are calculating new latitude and logitude for our marker
        final v = _animation!.value;
        double lng = v * toLong + (1 - v) * fromLong;
        double lat = v * toLat + (1 - v) * fromLat;
        LatLng newPos = LatLng(lat, lng);

        //Removing old marker if present in the marker array
        if (markers.contains(carMarker)) markers.remove(carMarker);

        //New marker location
        carMarker = await googleUserMarker(
          markerInfo,
          newPos,
          // anchor: const Offset(0.5, 0.5),
        );
        //Adding new marker to our list and updating the google map UI.
        markers.add(carMarker);
        mapMarkerSink.add(markers);

        //Moving the google camera to the new animated location.
        // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newPos, zoom: 15.5)));
      });

    //Starting the animation
    animationController.forward();
  }
}
