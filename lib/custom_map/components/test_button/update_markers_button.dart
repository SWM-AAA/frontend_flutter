import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';
import 'package:frontend/custom_map/model/marker_static_info_model.dart';
import 'package:frontend/custom_map/components/marker/google_user_marker.dart';
import 'package:frontend/custom_map/components/marker/user_marker_icon.dart';
import 'package:frontend/custom_map/repository/live_info_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateMarkersButton extends ConsumerStatefulWidget {
  final Function(List<FriendInfoModel>) updateMarkerLocation;
  // final List<Marker> markers;

  const UpdateMarkersButton({
    required this.updateMarkerLocation,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<UpdateMarkersButton> createState() => _UpdateMarkersButtonState();
}

class _UpdateMarkersButtonState extends ConsumerState<UpdateMarkersButton> {
  @override
  Widget build(BuildContext context) {
    final List<FriendInfoModel> newMarkers = [];

    return ElevatedButton(
      onPressed: () async {
        try {
          var response = await testGetApi();
          if (response != null) {
            widget.updateMarkerLocation(response.friendInfoList);
          }
        } catch (e) {}
      },
      child: Text("maker"),
    );
  }

  Future<FriendLocationAndBattery> testGetApi() async {
    return ref.watch(liveInfoRepositoryProvider).getFriendLocationAndBattery();
  }
}
