import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createMarkerIcon(String imagePath, String userName, Size size) async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Radius radius = Radius.circular(size.width / 2);

  drawProfileBorderDesign(canvas, size, radius);

  drawUserName(userName, size, canvas);

  await paintProfileImage(size, canvas, imagePath);

  ui.Image markerImage = await convertCanvasToImage(pictureRecorder, size);
  Uint8List markerImageBytes = await convertImageToBytes(markerImage);
  BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(markerImageBytes);
  return bitmapDescriptor;
}

void drawProfileBorderDesign(Canvas canvas, Size size, Radius radius) {
  drawShadowCircle(canvas, size, radius);
  drawBorderCircle(canvas, size, radius);
}

void drawShadowCircle(Canvas canvas, Size size, Radius radius) {
  canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0.0, userNameHeight, size.width, size.height),
        radius,
      ),
      shadowPaint);
}

void drawBorderCircle(Canvas canvas, Size size, Radius radius) {
  canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
            shadowWidth, shadowWidth + userNameHeight, size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
        radius,
      ),
      borderPaint);
}

void drawUserName(String userName, Size size, Canvas canvas) {
  TextPainter textPainter = configureUserNameTextPainter(userName);
  drawUserNameBackground(canvas, size, textPainter);
  paintTextUserName(size, textPainter, canvas);
}

TextPainter configureUserNameTextPainter(String userName) {
  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  );
  textPainter.text = TextSpan(
    text: userName,
    style: TextStyle(
      fontSize: userNameFontSize,
      color: userNameColor,
      fontWeight: userNameFontWeight,
      letterSpacing: userNameLetterSpacing,
    ),
  );

  textPainter.layout();
  return textPainter;
}

void drawUserNameBackground(Canvas canvas, Size size, TextPainter textPainter) {
  canvas.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (size.width - textPainter.width) / 2 - userNameFontSize / 2,
        0,
        textPainter.width + userNameFontSize,
        textPainter.height + userNameFontSize / 5,
      ),
      const Radius.circular(10.0),
    ),
    userNameBackgroundPaint,
  );
}

void paintTextUserName(Size size, TextPainter textPainter, Canvas canvas) {
  double horizontalOffset = (size.width - textPainter.width) / 2;

  textPainter.paint(canvas, Offset(horizontalOffset, userNameFontSize / 5));
}

Future<void> paintProfileImage(Size size, Canvas canvas, String imagePath) async {
  Rect imageRect = Rect.fromLTWH(
      imageOffset, imageOffset + userNameHeight, size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  canvas.clipPath(Path()..addOval(imageRect));

  ui.Image profileImage = await getImageFromPath(imagePath);
  paintImage(canvas: canvas, image: profileImage, rect: imageRect, fit: BoxFit.fitWidth);
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  final ByteData byteData = await rootBundle.load(imagePath);
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<Uint8List> convertImageToBytes(ui.Image markerAsImage) async {
  final ByteData? byteData = await markerAsImage.toByteData(format: ImageByteFormat.png);
  final Uint8List markerImageBytes = byteData!.buffer.asUint8List();
  return markerImageBytes;
}

Future<ui.Image> convertCanvasToImage(PictureRecorder pictureRecorder, Size size) async {
  final ui.Image markerImage =
      await pictureRecorder.endRecording().toImage(size.width.toInt(), size.height.toInt() + userNameHeight.toInt());
  return markerImage;
}
