import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'statement_of_account_logic.dart';

class StatementOfAccount extends StatelessWidget {
  StatementOfAccount(
      {Key? key, required this.fromDateString, required this.toDateString,required this.loanId})
      : super(key: key);

  String fromDateString;
  String toDateString;
  String loanId;

  final logic = Get.put(StatementOfAccountLogic());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Loan Statement",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.47,
              color: darkBlueColor),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 19, top: 8),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F9FF),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 10),
                  child: Text(
                    "Specify the date range to download",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 0.19,
                        color: Color(0xFF707070)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 11),
                  child: SizedBox(
                    height: 52,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime format = DateFormat("dd/MM/yyyy")
                                  .parse(fromDateString);
                              Get.log("Loan Start date ${format.toString()}");
                              final dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: format,
                                  firstDate: format,
                                  lastDate: DateTime.now());
                              if (dateTime != null) {
                                logic.fromDate.value = dateTime;
                                DateFormat dateFormat =
                                    DateFormat("yyyy-MM-dd");

                                logic.fromDateString.value =
                                    DateFormat("dd/MM/yyyy")
                                        .format(dateTime)
                                        .toString();
                              }
                            },
                            child: _startDate(),
                          ),
                          flex: 1,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final dateTime = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1990),
                                  lastDate: DateTime.now());
                              if (dateTime != null) {
                                logic.toDate.value = dateTime;
                                DateFormat dateFormat =
                                    DateFormat("yyyy-MM-dd");
                                logic.toDateString.value =
                                    DateFormat("dd/MM/yyyy").format(dateTime);
                              }
                            },
                            child: _endDate(),
                          ),
                          flex: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                          child: Obx(() {
                            return InkWell(
                              onTap: () async {
                                if (logic.fromDateString.value
                                        .contains("dd/mm/yyyy") ||
                                    logic.toDateString.value
                                        .contains("dd/mm/yyyy")) {
                                  Get.showSnackbar(const GetSnackBar(
                                    title: "Please select from and to dates",
                                    message:
                                        "Select from and to dates to download SOA.",
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                } else {
                                  await logic.getSoaFromDB(loanId);
                                }
                              },
                              child: _downloadButton(),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _downloadButton() {
    return Container(
        decoration: BoxDecoration(
            color: (logic.fromDateString.value.contains("dd/mm/yyyy") ||
                    logic.toDateString.value.contains("dd/mm/yyyy"))
                ? const Color.fromRGBO(198, 199, 199, 1)
                : activeButtonColor,
            borderRadius: BorderRadius.circular(4)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: ImageIcon(
            AssetImage(Res.download_icon),
            color: Colors.white,
          ),
        ));
  }

  Container _endDate() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "End date",
              style: TextStyle(
                  color: Color(0xFF707070), fontSize: 10, letterSpacing: 0.16),
            ),
            const SizedBox(
              height: 4,
            ),
            Obx(() {
              return Text(
                logic.toDateString.value,
                style: TextStyle(
                    color: logic.toDateString.value.contains("dd/mm/yyyy")
                        ? statementOfAccountDateColor
                        : activeButtonColor,
                    fontSize: 14,
                    letterSpacing: 0.4),
              );
            }),
          ],
        ),
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(color: shadowColor, offset: Offset(0, 3), blurRadius: 6)
          ]),
    );
  }

  Container _startDate() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Start date",
              style: TextStyle(
                  color: Color(0xFF707070), fontSize: 10, letterSpacing: 0.16),
            ),
            const SizedBox(
              height: 4,
            ),
            Obx(() {
              return Text(
                logic.fromDateString.value,
                style: TextStyle(
                    color: logic.fromDateString.value.contains("dd/mm/yyyy")
                        ? statementOfAccountDateColor
                        : activeButtonColor,
                    fontSize: 14,
                    letterSpacing: 0.4),
              );
            }),
          ],
        ),
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(color: shadowColor, offset: Offset(0, 3), blurRadius: 6)
          ]),
    );
  }
}
