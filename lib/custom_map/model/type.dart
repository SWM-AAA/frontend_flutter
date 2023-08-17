import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectoryUpdateMarker {
  final int markerId;
  final Marker newMarker;
  DirectoryUpdateMarker({
    required this.markerId,
    required this.newMarker,
  });
}

class MarkerInfo {
  final String markerId; // db에서 받은 유니크 user id를 marker id로 저장하자
  final String userName; // db에서 받음
  final String imagePath; // db

  MarkerInfo({
    required this.markerId,
    required this.userName,
    required this.imagePath,
  });
}
