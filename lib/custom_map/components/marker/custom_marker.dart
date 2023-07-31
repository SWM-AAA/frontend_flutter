import 'package:frontend/custom_map/components/const/data.dart';
import 'package:frontend/custom_map/components/const/type.dart';
import 'package:frontend/custom_map/components/marker_icon.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> createMarker(MarkerInfo markerInfo, LatLng latLng) async {
  return Marker(
    markerId: MarkerId(markerInfo.markerId),
    draggable: true,
    onTap: () => print("tapped!"),
    position: latLng,
    icon: await createMarkerIcon(
      MY_PROFILE_IMAGE_PATH,
      markerInfo.userName,
    ),
  );
}
