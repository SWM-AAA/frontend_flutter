import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createMarkerIcon(String imagePath, String userName, Size size) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint userNameBackgroundPaint = Paint()..color = Colors.blue.shade900;
  final double userNameHeight = 70.0;
  final double userNameFontSize = 50.0;
  final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
  final double shadowWidth = 15.0;

  final Paint borderPaint = Paint()..color = Colors.white;
  final double borderWidth = 3.0;

  final double imageOffset = shadowWidth + borderWidth;

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, userNameHeight, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  // Add border circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            shadowWidth, shadowWidth + userNameHeight, size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint);

  // Add username text
  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );
  textPainter.text = TextSpan(
    text: userName,
    style: TextStyle(
      fontSize: userNameFontSize,
      color: Colors.blue.shade100,
      fontWeight: FontWeight.bold,
      letterSpacing: 4.0,
    ),
  );

  textPainter.layout();

  // add username background rectangle
  Rect userNameRect = Rect.fromLTWH(
    (size.width - textPainter.width) / 2 - userNameFontSize / 2,
    0,
    textPainter.width + userNameFontSize,
    textPainter.height + userNameFontSize / 5,
  );
  canvas.drawRRect(RRect.fromRectAndRadius(userNameRect, Radius.circular(10.0)), userNameBackgroundPaint);
  // Add username text
  textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        userNameFontSize / 5,
      ));

  // Oval for the image
  Rect oval = Rect.fromLTWH(
      imageOffset, imageOffset + userNameHeight, size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Add image
  ui.Image image = await getImageFromPath(imagePath);
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  // Convert canvas to image
  final ui.Image markerAsImage =
      await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt() + userNameHeight.toInt());

  // Convert image to bytes
  final ByteData? byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData!.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  final ByteData byteData = await rootBundle.load(imagePath);
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}
