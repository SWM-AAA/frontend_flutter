import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/common/consts/data.dart';
import 'package:frontend/custom_map/const/marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> userMarkerIcon(String imagePath, String userName, ImageType imageType) async {
  final Size size = Size(200, 200);
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();

  final Canvas canvas = Canvas(pictureRecorder);

  drawProfileBorderDesign(canvas, size);

  drawUserName(userName, size, canvas);

  await paintProfileImage(size, canvas, imagePath, imageType);

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
    left: size.width,
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
    left: size.width + shadowWidth,
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
    left: (size.width * 3 - textPainter.width) / 2 - userNameFontSize / 2,
    top: 0,
    width: textPainter.width + userNameFontSize,
    height: textPainter.height + userNameFontSize / 5,
    radius: const Radius.circular(10.0),
    paint: userNameBackgroundPaint,
  );

  userNameBackground.drawRoundRectangle(canvas);
}

void paintTextUserName(Size size, TextPainter textPainter, Canvas canvas) {
  double horizontalOffset = (size.width * 3 - textPainter.width) / 2;

  textPainter.paint(canvas, Offset(horizontalOffset, userNameFontSize / 20));
}

Future<void> paintProfileImage(Size size, Canvas canvas, String imagePath, ImageType imageType) async {
  Rect imageRect = Rect.fromLTWH(size.width + imageOffset, imageOffset + userNameHeight, size.width - (imageOffset * 2),
      size.height - (imageOffset * 2));

  canvas.clipPath(Path()..addOval(imageRect));

  ui.Image profileImage = await getImageFromPath(imagePath, imageType);
  paintImage(canvas: canvas, image: profileImage, rect: imageRect, fit: BoxFit.fitWidth);
}

Future<ui.Image> getImageFromPath(String imagePath, ImageType imageType) async {
  late Uint8List uint8listData;

  try {
    switch (imageType) {
      case ImageType.Directory:
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          // The file exists, proceed with loading the image
          uint8listData = imageFile.readAsBytesSync();
          break;
        }
      case ImageType.Asset:
        final ByteData byteData = await rootBundle.load(imagePath);
        uint8listData = byteData.buffer.asUint8List();
        break;
      case ImageType.Network:
        final http.Response response = await http.get(Uri.parse(imagePath));
        if (response.statusCode == 200) {
          uint8listData = response.bodyBytes;
          break;
        }
      default:
        final ByteData byteData = await rootBundle.load(MY_PROFILE_DEFAULT_IMAGE_PATH);
        uint8listData = byteData.buffer.asUint8List();
        break;
    }

    final Completer<ui.Image> completer = Completer();

    // ui.decodeImageFromList(byteData.buffer.asUint8List(), (ui.Image img) {
    ui.decodeImageFromList(uint8listData, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  } catch (e) {
    throw Exception("Error loading image");
  }
}

Future<Uint8List> convertImageToBytes(ui.Image markerAsImage) async {
  final ByteData? byteData = await markerAsImage.toByteData(format: ImageByteFormat.png);
  final Uint8List markerImageBytes = byteData!.buffer.asUint8List();
  return markerImageBytes;
}

Future<ui.Image> convertCanvasToImage(PictureRecorder pictureRecorder, Size size) async {
  final ui.Image markerImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt() * 3, size.height.toInt() + userNameHeight.toInt());
  return markerImage;
}
