import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../firebase/analytics.dart';
import '../../../../../utils/web_engage_constant.dart';
import 'package:privo/app/theme/app_colors.dart';


class LowAndGrowTermsAndConditionWidget extends StatelessWidget {
  final String title;
  final List<String> policyList;
  bool policyStatus;
  bool bulletStatus;

  LowAndGrowTermsAndConditionWidget(
      {Key? key,
      this.title = "",
      required this.policyList,
      this.policyStatus = false,
      this.bulletStatus = true})
      : super(key: key);

  final String bullets = '\u2022';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                AppAnalytics.trackWebEngageEventWithAttribute(
                    eventName: WebEngageConstants.lgTncBottomUpClosed);
                Get.back();
              },
              icon: const Icon(
                Icons.clear_rounded,
                color: Color(0xFF161742),
                size: 15,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _termAndConditionTextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, title: title),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: policyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          bulletStatus
                              ? Text(
                                  bullets,
                                  style: _bottomSheetTextStyle(
                                      policyStatus: policyStatus),
                                  textAlign: TextAlign.start,
                                )
                              : const SizedBox(),
                          Text(
                            policyList[index],
                            style: _titleTextStyle(policyStatus: policyStatus),
                            //  maxLines: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

TextStyle _titleTextStyle({bool policyStatus = false}) {
  return TextStyle(
    fontSize: 10,
    fontFamily: 'Figtree',
    color: policyStatus ? const Color(0xff1D478E) :  skyBlueColor,
  );
}

TextStyle _termAndConditionTextStyle(
    {required double fontSize,
    required FontWeight fontWeight,
    bool policyStatus = false,
    String title = ""}) {
  return GoogleFonts.poppins(
    fontSize: fontSize,
    letterSpacing: 0.18,
    fontWeight: fontWeight,
    color: title == "Terms and Conditions"
        ? const Color(0xff161742)
        : policyStatus
            ? const Color(0xff1D478E)
            :  skyBlueColor,
  );
}

TextStyle _bottomSheetTextStyle({bool policyStatus = false}) {
  return TextStyle(
      color: policyStatus ? const Color(0xff1D478E) :  skyBlueColor,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      fontFamily: 'Figtree');
}
