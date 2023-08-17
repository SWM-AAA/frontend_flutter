import 'package:frontend/custom_map/model/type.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> googleUserMarker(MarkerInfo markerInfo, LatLng latLng) async {
  return Marker(
    markerId: MarkerId(markerInfo.markerId),
    draggable: true,
    onTap: () => print("tapped!"),
    position: latLng,
    icon: await userMarkerIcon(
      markerInfo.imagePath,
      markerInfo.userName,
    ),
  );
}
