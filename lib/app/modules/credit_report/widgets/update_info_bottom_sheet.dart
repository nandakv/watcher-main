import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

class UpdateInfoBottomSheet extends StatelessWidget {
  UpdateInfoBottomSheet({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
        childPadding: const EdgeInsets.all(16),
        enableCloseIconButton: false,
        child: Column(
          children: [
            _closeButton(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SvgPicture.asset(Res.creditScoreBottomSheetSvg),
            ),
            const Text(
              "Credit Score refreshes\nevery 30 days",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkBlueColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const VerticalSpacer(16),
            Text.rich(TextSpan(children: [
              const TextSpan(
                text: "Next update available: ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: secondaryDarkColor,
                ),
              ),
              TextSpan(
                text: logic.creditScoreModel.applicationDetails
                    .nextUpdateAvailableFormat,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: primaryDarkColor,
                ),
              ),
            ]))
          ],
        ));
  }

  Widget _closeButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: Get.back,
          child: const Icon(
            Icons.clear_rounded,
            color: appBarTitleColor,
          ),
        )
      ],
    );
  }
}
