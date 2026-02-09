import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/home_page_button.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class RefreshCreditScore extends StatelessWidget {
  RefreshCreditScore({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: primarySubtleColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Res.refreshBulb),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _newScoreAvailable(),
                const VerticalSpacer(4),
                _bodyText(),
                const VerticalSpacer(12),
                HomePageButton(
                  title: "Refresh now",
                  onPressed: ()=>logic.onRefreshCreditScorePressed(),
                  backgroundColor: navyBlueColor,
                  fontSize: 12,
                  padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  foregroundColor: Colors.white,
                ),
                const VerticalSpacer(8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyText() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Text(
        "Refresh your credit score, it's safe, and won't impact your score ",
        maxLines: 3,
        style: TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Row _newScoreAvailable() {
    return const Row(
      children: [
        SizedBox(
          width: 7,
        ),
        Text(
          "New Score Available!",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 12, color: darkBlueColor),
        )
      ],
    );
  }
}
