import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectoryUpdateMarker {
  final int markerId;
  final Marker newMarker;
  DirectoryUpdateMarker({
    required this.markerId,
    required this.newMarker,
  });
}
