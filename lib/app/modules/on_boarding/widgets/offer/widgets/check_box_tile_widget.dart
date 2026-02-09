import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/offer_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';

class CheckBoxTileWidget extends StatelessWidget {
   CheckBoxTileWidget({super.key,required this.offerServiceType});
   OfferServiceType offerServiceType;
   final logic = Get.find<OfferLogic>();

  BorderSide borderSide = const BorderSide(color: borderSkyBlueColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: (offerServiceType == OfferServiceType.healthcare &&
                logic.responseModel.insuranceDetails != null &&
                logic.responseModel.vasDetailsList != null)
            ? Border(
                left: borderSide,
                right: borderSide,
                bottom: borderSide,
              )
            : Border.all(
                color: borderSkyBlueColor,
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            GetBuilder<OfferLogic>(
              id: offerServiceType == OfferServiceType.insurance
                  ? logic.INSURANCE_CHECKBOX
                  : logic.HEALTHCARE_CHECKBOX,
              builder: (logic) {
                return Checkbox(
                  visualDensity: const VisualDensity(
                    horizontal: -4.0,
                    vertical: -4.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  checkColor: const Color(0xffffffff),
                  side: const BorderSide(color: Color(0xff002F7D), width: 1),
                  value: offerServiceType == OfferServiceType.insurance
                      ? logic.toggleInsuranceChecked
                      : logic.toggleHealthcareChecked,
                  onChanged: logic.isButtonLoading
                      ? null
                      : (boolValue) {
                          offerServiceType == OfferServiceType.insurance
                              ? logic.onChangeInsuranceCheckBox(boolValue)
                              : logic.onChangeHealthcareCheckBox(boolValue);
                        },
                );
              },
            ),
            Text(
                offerServiceType == OfferServiceType.insurance
                    ? "Insurance Premium"
                    : "Healthcare Service Fee",
                style: _insuranceTitleTextStyle),
            InkWell(
              onTap: () {
                logic.onOfferKnowMorePress(offerServiceType);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: SvgPicture.asset(Res.infoIconSVG),
              ),
            ),
            const Spacer(),
            Text(
              AppFunctions.getIOFOAmount(
                offerServiceType == OfferServiceType.insurance
                    ? double.parse(
                        logic.responseModel.insuranceDetails!.premiumAmount)
                    : logic.responseModel.vasDetailsList![0].serviceFee,
              ),
              style: _insuranceValueTextStyle,
            ),
          ],
        ),
      ),
    );
  }

   TextStyle get _insuranceValueTextStyle {
     return const TextStyle(
       color: primaryDarkColor,
       fontSize: 14,
       fontWeight: FontWeight.w600,
     );
   }


   TextStyle get _insuranceTitleTextStyle {
     return const TextStyle(
       color: navyBlueColor,
       fontSize: 12,
       fontWeight: FontWeight.w400,
     );
   }

}
