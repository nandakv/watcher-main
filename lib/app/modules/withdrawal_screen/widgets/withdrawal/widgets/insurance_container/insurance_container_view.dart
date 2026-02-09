import 'package:card_swiper/card_swiper.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import 'insurance_container_logic.dart';

class InsuranceContainer extends StatelessWidget {
  final logic = Get.find<InsuranceContainerLogic>();

  InsuranceContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: navyBlueColor,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: logic.onInsuranceContainerTapped,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _insuranceCheckBox(),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: GetBuilder<InsuranceContainerLogic>(
                      id: logic.LIST_ID,
                      builder: (logic) {
                        return RichText(
                          text: TextSpan(
                            text: "Secure your withdrawal at ",
                            style: const TextStyle(
                              fontFamily: 'Figtree',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: navyBlueColor,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "approx ${logic.computePremiumPerDay} per day",
                                style: const TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: navyBlueColor,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: SvgPicture.asset(
                      Res.chevron_down_svg,
                    ),
                  ),
                ],
              ),
              const Divider(
                color: navyBlueColor,
                thickness: 0.2,
              ),
              const SizedBox(
                height: 5,
              ),
              _benefitsCarouselSlider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _insuranceCheckBox() {
    return SizedBox(
      width: 16,
      height: 16,
      child: Transform.scale(
        scale: 0.7,
        child: GetBuilder<InsuranceContainerLogic>(
          id: logic.CHECK_BOX_ID,
          builder: (logic) {
            return Checkbox(
              value: logic.isInsuranceChecked,
              onChanged: logic.toggleInsuranceCheckBox,
              activeColor: navyBlueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
              materialTapTargetSize: MaterialTapTargetSize.padded,
            );
          },
        ),
      ),
    );
  }

  Widget _benefitsCarouselSlider() {
    return GetBuilder<InsuranceContainerLogic>(
      id: logic.LIST_ID,
      builder: (logic) {
        if (logic.policyBenefitList.isEmpty) return const SizedBox();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExpandablePageView.builder(
              itemCount: logic.policyBenefitList.length,
              controller: logic.benefitsPageViewController,
              onPageChanged: logic.onCarouselSliderPageChanged,
              itemBuilder: (context, index) {
                PolicyBenefit policyBenefit = logic.policyBenefitList[index];
                return _benefitCarouselItem(policyBenefit);
              },
            ),
            const SizedBox(
              height: 8,
            ),
            PageIndicator(
              count: logic.policyBenefitList.length,
              controller: logic.benefitsPageViewController,
              color: Colors.grey.withOpacity(0.3),
              activeColor: const Color(0xffAF8E2F),
              size: 4,
              activeSize: 4,
              scale: 6,
              space: 5,
              layout: PageIndicatorLayout.WARM,
            ),
          ],
        );
      },
    );
  }

  Row _benefitCarouselItem(PolicyBenefit policyBenefit) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(policyBenefit.icon),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                policyBenefit.benefitTitle,
                style: const TextStyle(
                  color: navyBlueColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                policyBenefit.carouselText,
                maxLines: 2,
                style: const TextStyle(
                  color: navyBlueColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
