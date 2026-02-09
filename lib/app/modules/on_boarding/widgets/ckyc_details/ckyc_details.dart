import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/blue_border_button.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/modules/on_boarding/widgets/ckyc_details/ckyc_details_logic.dart';
import 'package:privo/app/theme/app_colors.dart';

class CKYCDetails extends StatefulWidget {
  const CKYCDetails({Key? key}) : super(key: key);

  @override
  State<CKYCDetails> createState() => _CKYCDetailsState();
}

class _CKYCDetailsState extends State<CKYCDetails>
    with AfterLayoutMixin, DetailRow {
  final logic = Get.find<CKYCDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CKYCDetailsLogic>(
      builder: (logic) => logic.isPageLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 38,
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: cardBoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 58,
                                ),
                                Container(
                                  width: Get.width,
                                  color: const Color(0xffF4F8FF),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        logic.cKycModel.fullName,
                                        style: nameTextStyle(),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: DetailTable(),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Above information is fetched from CKYC',
                            style: infoTextStyle(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlueButton(
                            onPressed: logic.onCKYCPressed,
                            buttonColor: activeButtonColor,
                            title: "Yes, Confirm Details",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          BlueBorderButton(
                            onPressed: () => logic.onAadhaarXML(
                              fromCKYC: true,
                            ),
                            buttonColor: activeButtonColor,
                            title: "No, Proceed With Aadhaar",
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.memory(
                            base64.decode(logic.cKycModel.imageDetails
                                .singleWhere((element) =>
                                    element.ckycimageType == "Photograph")
                                .ckycimageData),
                            height: 76,
                            width: 76,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  TextStyle infoTextStyle() {
    return const TextStyle(
        fontSize: 12,
        letterSpacing: 0.09,
        color: Color(0xff344157),
        fontStyle: FontStyle.italic);
  }

  TextStyle nameTextStyle() {
    return const TextStyle(
        fontSize: 16,
        letterSpacing: 0.12,
        fontWeight: FontWeight.w600,
        color: titleTextColor);
  }

  BoxDecoration cardBoxDecoration() {
    return BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.12),
              offset: Offset(0, 3),
              blurRadius: 5)
        ]);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.afterLayout();
  }
}

class DetailTable extends StatelessWidget with DetailRow {
  DetailTable({Key? key}) : super(key: key);

  final logic = Get.find<CKYCDetailsLogic>();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(0.3),
        1: FlexColumnWidth(0.7),
      },
      children: [
        row(key: 'PAN : ', value: logic.cKycModel.panValue),
        row(key: "Father's Name :", value: logic.cKycModel.fatherFullName),
        row(
            key: "Address :",
            value: "${logic.cKycModel.permanentAddLine1}\n"
                "${logic.cKycModel.permanentAddLine2}\n"
                "${logic.cKycModel.permanentAddLine3}\n"
                "${logic.cKycModel.permanentCity}\n"
                "${logic.cKycModel.permanentDistrict}\n"
                "${logic.cKycModel.permanentPincode}\n")
      ],
    );
  }
}

abstract class DetailRow {
  TableRow row({required String key, required String value}) {
    return TableRow(
      children: [
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              key,
              style: keyTextStyle(),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              value,
              style: valueTextStyle(),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle valueTextStyle() =>
      const TextStyle(letterSpacing: 0.11, color: titleTextColor);

  TextStyle keyTextStyle() {
    return const TextStyle(
      fontSize: 12,
      letterSpacing: 0.09,
      color: Color(0xff5E6066),
    );
  }
}
