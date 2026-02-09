import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/res.dart';

import '../../../../models/withdrawal_calculation_model.dart';
import '../../../../theme/app_colors.dart';

class PolicyBenefitBottomSheetWidget extends StatelessWidget {
  const PolicyBenefitBottomSheetWidget({
    Key? key,
    required this.policyBenefit,
  }) : super(key: key);
  final PolicyBenefit policyBenefit;

  @override
  Widget build(BuildContext context) {
    return BottomSheetWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: navyBlueColor,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SvgPicture.asset(
                policyBenefit.icon,
                height: 40,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            policyBenefit.benefitTitle,
            style: _titleTextStyle(),
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.separated(
            shrinkWrap: true,
            itemCount: policyBenefit.benefitDetails.length,
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 8,
              );
            },
            itemBuilder: (context, index) {
              String text = policyBenefit.benefitDetails[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: navyBlueColor,
                      shape: BoxShape.circle,
                    ),
                    height: 4,
                    width: 4,
                    margin: const EdgeInsets.only(top: 4),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      text,
                      style: _pointsTextStyle(),
                    ),
                  )
                ],
              );
            },
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  TextStyle _pointsTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w300,
      color: navyBlueColor,
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: darkBlueColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }
}
