import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatelessWidget {
  GoogleMapController? googleMapController;
  final CameraPosition initCameraPosition;
  final List<Marker> markers;
  final Function(GoogleMapController) updateControllerOnMapCreated;
  final Function(CameraPosition) onCameraMove;
  CustomGoogleMap({
    required this.initCameraPosition,
    required this.markers,
    required this.updateControllerOnMapCreated,
    required this.onCameraMove,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal, // hybrid, normal
      initialCameraPosition: initCameraPosition,
      onMapCreated: (controller) {
        updateControllerOnMapCreated(controller);
      },
      mapToolbarEnabled: true,
      buildingsEnabled: false,
      myLocationButtonEnabled: true,
      myLocationEnabled: true, // 내 위치를 중앙 파란점 + 방향 화살표
      compassEnabled: false, // 맵 회전시 다시 북쪽을 향하게하는 나침반
      markers: Set.from(markers),
      onCameraMove: (position) {
        onCameraMove(position);
      },
    );
  }
}
