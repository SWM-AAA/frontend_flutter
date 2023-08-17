import 'package:frontend/custom_map/model/marker_static_info_model.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> googleUserMarker(MarkerInfo markerInfo, LatLng latLng) async {
  return Marker(
    markerId: MarkerId(markerInfo.markerId),
    draggable: false,
    position: latLng,
    icon: await userMarkerIcon(
      markerInfo.imagePath,
      markerInfo.userName,
    ),
  );
}
