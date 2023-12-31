// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

const double userNameLetterSpacing = 4.0;
final Paint shadowPaint = Paint()..color = Colors.grey.withAlpha(100);
const double shadowWidth = 15.0;

final Paint borderPaint = Paint()..color = Colors.white;
const double borderWidth = 3.0;

const double imageOffset = shadowWidth + borderWidth;

final Paint userNameBackgroundPaint = Paint()..color = Colors.grey.shade900;
const double userNameHeight = 70.0;
const double userNameFontSize = 50.0;
final Color userNameColor = Colors.grey.shade100;
const FontWeight userNameFontWeight = FontWeight.bold;

enum ImageType {
  Network,
  Asset,
  File,
  Memory,
  Directory,
}
