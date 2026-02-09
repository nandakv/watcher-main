import 'package:flutter/material.dart';

class CreditScoreScaleModel {
  final String imagePath;
  final int minScore;
  final int maxScore;
  final String title;
  final Color color;
  final String details;

  CreditScoreScaleModel({
    required this.imagePath,
    required this.minScore,
    required this.maxScore,
    required this.title,
    required this.color,
    required this.details,
  });
}
