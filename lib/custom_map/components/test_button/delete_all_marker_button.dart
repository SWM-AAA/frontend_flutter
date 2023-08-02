import 'package:flutter/material.dart';

class DeleteAllMarkerButton extends StatelessWidget {
  final Function deleteAllMarker;
  const DeleteAllMarkerButton({
    required this.deleteAllMarker,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        deleteAllMarker();
      },
      child: Text("marker clear"),
    );
  }
}
