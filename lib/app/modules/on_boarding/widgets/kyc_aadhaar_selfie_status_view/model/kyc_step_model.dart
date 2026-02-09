import 'package:flutter/material.dart';

class KycStepModel {
  final bool isVerified;
  final String iconPath;
  final TextSpan textSpan;

  KycStepModel({
    required this.isVerified,
    required this.iconPath,
    required this.textSpan,
  });
}
