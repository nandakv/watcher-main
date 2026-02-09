import 'package:flutter/material.dart';

class CreditScoreUpdate {
  final String creditPoint;
  final String scoreChange;
  final String scoreTitle;
  final Color textColor;
  final String icon;

  CreditScoreUpdate({
    required this.creditPoint,
    required this.scoreChange,
    required this.scoreTitle,
    required this.textColor,
    required this.icon,
  });
}
