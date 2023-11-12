import 'package:frontend/custom_map/const/marker.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:frontend/custom_map/model/static_info_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<Marker> googleUserMarker(
    StaticInfoModel markerInfo, LatLng latLng, ImageType imageType) async {
  return Marker(
    markerId: MarkerId(markerInfo.userId.toString()),
    draggable: false,
    position: latLng,
    onTap: () {
      print('Marker tapped=----------- ${markerInfo.userId}');
    },
    icon: await userMarkerIcon(
      markerInfo.imageUrl,
      markerInfo.nickname,
      imageType,
    ),
  );
}
