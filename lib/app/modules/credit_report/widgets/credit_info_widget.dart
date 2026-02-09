import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_report_tile.dart';
import 'package:privo/app/theme/app_colors.dart';

import '../credit_report_helper_mixin.dart';

class CreditInfoWidget extends StatelessWidget {
  final CreditInfoType type;
  final Decoration? decoration;
  final EdgeInsetsGeometry padding;
  CreditInfoWidget({
    super.key,
    required this.type,
    this.decoration,
    this.padding = const EdgeInsets.all(16),
  });

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return CreditReportTile(
      title: type.title,
      subTitle: "${type.impactLevel} Impact",
      onTap: () => logic.onCreditInfoTap(type),
      iconPath: type.iconPath,
      iconPadding: 5,
      rightInfoWidget: _rightWidget(),
      decoration: decoration,
      padding: padding,
    );
  }

  Widget _rightWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          _computeMetricValue(),
          style: const TextStyle(
            fontSize: 12,
            height: 16 / 12,
            fontWeight: FontWeight.w600,
            color: navyBlueColor,
          ),
        ),
        Text(
          "${logic.creditReport.keyMetricInfos[type]?.remarks.name}",
          style: TextStyle(
            fontSize: 10,
            height: 1.4,
            fontWeight: FontWeight.w500,
            color: logic.creditReport.keyMetricInfos[type]?.remarks.color,
          ),
        ),
      ],
    );
  }

  String _computeMetricValue() {
    switch (type) {
      case CreditInfoType.onTimePayments:
      case CreditInfoType.creditUtilisation:
      case CreditInfoType.creditMix:
        return "${logic.creditReport.keyMetricInfos[type]?.value}%";
      case CreditInfoType.creditAge:
        return logic.creditReport.keyMetricInfos[type]?.value ?? "";

      case CreditInfoType.creditEnquiries:
        return "${logic.creditReport.keyMetricInfos[type]?.value}";
    }
  }
}
