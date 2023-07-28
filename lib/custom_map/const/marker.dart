import 'dart:ui';
import 'package:flutter/material.dart';

const double userNameLetterSpacing = 4.0;
final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
const double shadowWidth = 15.0;

final Paint borderPaint = Paint()..color = Colors.white;
const double borderWidth = 3.0;

const double imageOffset = shadowWidth + borderWidth;

final Paint userNameBackgroundPaint = Paint()..color = Colors.blue.shade900;
const double userNameHeight = 70.0;
const double userNameFontSize = 50.0;
final Color userNameColor = Colors.blue.shade100;
const FontWeight userNameFontWeight = FontWeight.bold;
