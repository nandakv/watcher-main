import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';

import '../../../../../common_widgets/nudge_badge_widget.dart';
import '../../../../../theme/app_colors.dart';
import '../kyc_verification_logic.dart';

class AadhaarSelectionTile extends StatelessWidget {
  final List<String> infoList;
  final String bottomInfo;
  final bool isRecommended;
  final String title;
  final Widget logoWidget;
  final Function()? onSelect;
  final AadhaarVerificationType verificationType;
  AadhaarSelectionTile(
      {Key? key,
      required this.infoList,
      required this.bottomInfo,
      this.isRecommended = false,
      required this.title,
      required this.logoWidget,
      this.onSelect,
      required this.verificationType})
      : super(key: key);
  final logic = Get.find<KycVerificationLogic>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => logic.onVerificationTypeChanged(verificationType),
      child: NudgeBadgeWidget(
        nudgeText: isRecommended ? "Recommended" : null,
        bgColor: goldColor,
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: darkBlueColor,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      _radioWidget(),
                      _titleWidget(),
                      const Spacer(),
                      logoWidget,
                    ],
                  ),
                ),
                _infoListWidget(),
                verticalSpacer(16),
                _bottomWidget()
              ],
            )),
      ),
    );
  }

  Widget _titleWidget() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: darkBlueColor,
      ),
    );
  }

  Widget _radioWidget() {
    return Radio<AadhaarVerificationType>(
      value: verificationType,
      groupValue: logic.verificationType,
      activeColor: darkBlueColor,
      visualDensity: const VisualDensity(vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onChanged: logic.onVerificationTypeChanged,
    );
  }

  Widget _infoListWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 42.0, right: 24),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: infoList.length,
          itemBuilder: (item, index) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "• ${infoList[index]}",
                style: const TextStyle(
                    color: primaryDarkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 10),
              ),
            );
          }),
    );
  }

  Widget _bottomWidget() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: navyBlueColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(11),
          bottomRight: Radius.circular(11),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            bottomInfo,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: whiteTextColor,
                fontSize: 10),
          ),
        ),
      ),
    );
  }
}
