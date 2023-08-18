import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/custom_map/model/friend_info_model.dart';

import 'package:frontend/custom_map/repository/live_info_repository.dart';

class UpdateMarkersButton extends ConsumerStatefulWidget {
  final Function(List<UserLiveInfoModel>) updateMarkerLocation;
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
    return ElevatedButton(
      onPressed: () async {
        try {
          var response = await getLocationAndBattery();
          if (response != null) {
            widget.updateMarkerLocation(response.friendInfoList);
          }
        } catch (e) {}
      },
      child: Text("maker"),
    );
  }

  Future<FriendLocationAndBattery> getLocationAndBattery() async {
    return ref.watch(liveInfoRepositoryProvider).getFriendLocationAndBattery();
  }
}
