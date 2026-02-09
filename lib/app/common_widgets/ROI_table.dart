import 'package:flutter/cupertino.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_ui_constant.dart';

import '../modules/on_boarding/widgets/offer/offer_logic.dart';

enum _ROITableValues { interest, processingFee, tenure }

class ROITable extends StatelessWidget {
  ROITable({
    Key? key,
    this.interest,
    required this.tenure,
    this.processingFeeROI,
    this.valueTextAlignment = TextAlign.left,
    this.strikeThroughInterest = "",
    this.strikeThroughTenure = "",
    this.strikeThroughProcessingFee = "",
  }) : super(key: key);
  num? interest;
  String tenure;
  String? processingFeeROI;
  TextAlign valueTextAlignment;
  String strikeThroughInterest;
  String strikeThroughTenure;
  String strikeThroughProcessingFee;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 12, bottom: 12, right: 30),
      decoration: BoxDecoration(
        color: const Color(0xff1B3B7B).withOpacity(1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FutureBuilder<String>(
          future: _computeProcessingFee(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              String _processingFeeValue = snapshot.data!;
              return _onProcessingFeeFetched(_processingFeeValue);
            } else {
              return const SizedBox();
            }
          }),
    );
  }

  Table _onProcessingFeeFetched(String _processingFeeValue) {
    return Table(
      columnWidths: const {
        1: FlexColumnWidth(0.6),
        2: FlexColumnWidth(0.4),
      },
      children: [
        _tableRow(
          title: roiText,
          value: "$interest%",
          strikeThroughValue: strikeThroughInterest,
          roiTableValues: _ROITableValues.interest,
        ),
        _tableRow(
          title: processingFee,
          value: _processingFeeValue,
          strikeThroughValue: strikeThroughProcessingFee,
          roiTableValues: _ROITableValues.processingFee,
        ),
        _tableRow(
          title: withdrawalTenure,
          value: tenure,
          strikeThroughValue: strikeThroughTenure,
          roiTableValues: _ROITableValues.tenure,
        ),
      ],
    );
  }

  Future<String> _computeProcessingFee() async {
    String lpc = await AppAuthProvider.getLpc;
    if (lpc == 'CLP') {
      return _computeClpProcessingFee();
    } else {
      return "₹ $processingFeeROI";
    }
  }

  _computeClpProcessingFee() {
    if (processingFeeROI != null && processingFeeROI == "0.0" ||
        processingFeeROI == "0") {
      return "$processingFeeROI%";
    } else {
      return "Upto $processingFeeROI%";
    }
  }

  TableRow _tableRow({
    required _ROITableValues roiTableValues,
    required String title,
    required String value,
    String strikeThroughValue = "",
  }) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xffFFF3EB),
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ..._computeStrikeThroughValue(roiTableValues),
              ],
              style: const TextStyle(
                color: Color(0xffFFF3EB),
              ),
            ),
            textAlign: valueTextAlignment,
          ),
          // child: Text(
          //   value,
          //   textAlign: valueTextAlignment,
          //   style: const TextStyle(
          //     color: Color(0xffFFF3EB),
          //     fontSize: 12,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ),
      ],
    );
  }

  List<InlineSpan> _computeStrikeThroughValue(_ROITableValues roiTableValues) {
    switch (roiTableValues) {
      case _ROITableValues.interest:
        return strikeThroughInterest.isEmpty
            ? []
            : [
                const WidgetSpan(
                  child: SizedBox(
                    width: 5,
                  ),
                ),
                TextSpan(
                  text: "$strikeThroughInterest%",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ];
      case _ROITableValues.processingFee:
        return strikeThroughProcessingFee.isEmpty
            ? []
            : [
          const TextSpan(text: " "),
          TextSpan(
            text:"$strikeThroughProcessingFee%" ,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ];
      case _ROITableValues.tenure:
        return strikeThroughTenure.isEmpty
            ? []
            : [
                const TextSpan(text: "\n"),
                TextSpan(
                  text: strikeThroughTenure,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ];
    }
  }
}
