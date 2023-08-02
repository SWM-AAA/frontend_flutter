import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createMarkerIcon(String imagePath, String userName) async {
  final Size size = Size(200, 200);
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();

  final Canvas canvas = Canvas(pictureRecorder);

  drawProfileBorderDesign(canvas, size);

  drawUserName(userName, size, canvas);

  await paintProfileImage(size, canvas, imagePath);

  ui.Image markerImage = await convertCanvasToImage(pictureRecorder, size);
  Uint8List markerImageBytes = await convertImageToBytes(markerImage);
  BitmapDescriptor bitmapDescriptor = BitmapDescriptor.fromBytes(markerImageBytes);
  return bitmapDescriptor;
}

void drawProfileBorderDesign(Canvas canvas, Size size) {
  drawShadowCircle(canvas, size);
  drawBorderCircle(canvas, size);
}

class RoundRectangle {
  final double left;
  final double top;
  final double width;
  final double height;
  final Radius radius;
  final Paint paint;

  RoundRectangle({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.radius,
    required this.paint,
  });
  drawRoundRectangle(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, width, height),
        radius,

      ),
      paint,
    );
  }
}

void drawShadowCircle(Canvas canvas, Size size) {
  RoundRectangle shadowCircle = RoundRectangle(
    left: 0.0,
    top: userNameHeight,
    width: size.width,
    height: size.height,
    radius: Radius.circular(size.width / 2),
    paint: shadowPaint,
  );
  shadowCircle.drawRoundRectangle(canvas);
}

void drawBorderCircle(Canvas canvas, Size size) {
  RoundRectangle borderCircle = RoundRectangle(
    left: shadowWidth,
    top: shadowWidth + userNameHeight,
    width: size.width - (shadowWidth * 2),
    height: size.height - (shadowWidth * 2),
    radius: Radius.circular(size.width / 2),
    paint: borderPaint,
  );
  borderCircle.drawRoundRectangle(canvas);
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
  RoundRectangle userNameBackground = RoundRectangle(
    left: (size.width - textPainter.width) / 2 - userNameFontSize / 2,
    top: 0,
    width: textPainter.width + userNameFontSize,
    height: textPainter.height + userNameFontSize / 5,
    radius: const Radius.circular(10.0),
    paint: userNameBackgroundPaint,
  );

  userNameBackground.drawRoundRectangle(canvas);
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
