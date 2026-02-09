import 'package:flutter/material.dart';

enum RemarkType {
  excellent(color: Color(0xff268E3A), name: "Excellent"),
  good(color: Color(0xff5BC275), name: "Good"),
  fair(color: Color(0xFFF0C61C), name: "Fair"),
  average(color: Color(0xFFFF919A), name: "Average"),
  belowAverage(color: Color(0xFFEE3D4B), name: "Below Average");

  final Color color;
  final String name;

  const RemarkType({required this.color, required this.name});

  static RemarkType fromString(String type) {
    Map<String, RemarkType> mapping = {
      "Excellent": RemarkType.excellent,
      "Good": RemarkType.good,
      "Fair": RemarkType.fair,
      "Average": RemarkType.average,
      "Below Average": RemarkType.belowAverage,
    };
    return mapping[type] ?? RemarkType.belowAverage;
  }
}

class KeyMetricModel {
  late final List<KeyMetric> keyMetrics;
  late final String value;
  late final RemarkType remarks;
  late final List<KeyMetricCreditAccountDetails> keyMetricCreditAccountDetails;
  late final bool isAnyValueNA;

  bool _checkIsAnyValueNA() {
    return keyMetrics.any((element) => _isNA(element.value)) ||
        _isNA(value) ||
        keyMetricCreditAccountDetails.any((element) =>
            _isNA(element.firstDataPoint) || _isNA(element.secondDataPoint));
  }

  bool _isNA(String val) {
    return val == "" || val == "-" || val == "0";
  }

  KeyMetricModel({
    required this.keyMetrics,
    required this.value,
    required this.remarks,
    required this.keyMetricCreditAccountDetails,
  }) {
    isAnyValueNA = _checkIsAnyValueNA();
  }
}

class KeyMetric {
  final String name;
  final String value;

  KeyMetric({required this.name, required this.value});
}

class KeyMetricCreditAccountDetails {
  late final int? accountSerialNumber;
  late final String accountType;
  late final String lenderName;
  late final String firstDataPoint;
  late final String secondDataPoint;

  KeyMetricCreditAccountDetails(
      {required this.accountSerialNumber,
      required this.accountType,
      required this.lenderName,
      required this.firstDataPoint,
      required this.secondDataPoint});
}
