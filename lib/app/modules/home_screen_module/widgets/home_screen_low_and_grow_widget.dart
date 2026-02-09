import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../../res.dart';
import '../../../firebase/analytics.dart';
import '../../../models/home_screen_card_model.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/web_engage_constant.dart';
import '../../low_and_grow/widgets/low_and_grow_offer/model/low_and_grow_enhanced_offer_model.dart';
import '../home_screen_logic.dart';

class HomeScreenLowAndGrowWidget extends StatelessWidget {
  final WithdrawalDetailsHomeScreenType homeScreenModel;

  HomeScreenLowAndGrowWidget({
    Key? key,
    required this.homeScreenModel,
  }) : super(key: key);

  final logic = Get.find<HomeScreenLogic>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.lgOfferCardClicked);
        logic.goToLowAndGrowModule();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          color: const Color(0xff1161742).withOpacity(1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(Res.rightArrow),
            ),
            Flexible(
              child: Text(
                "Special Upgrade!",
                style: _titleTextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 30),
                child: Text(
                  "Rewarding your timely EMI payments claim\nyour exclusive offer now!",
                  style: _titleTextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            _offerAmountWidget(),
            _offerExpireTextWidget()
          ],
        ),
      ),
    );
  }

  Widget _offerAmountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (homeScreenModel.enhancedOffer!.upgradedFeatures != null)
          _computeUpgradeFeaturesWidget(),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: SvgPicture.asset(Res.coinImg),
        ),
      ],
    );
  }

  Widget _offerExpireTextWidget() {
    return Row(
      children: [
        SvgPicture.asset(Res.offerTimer),
        const SizedBox(
          width: 5,
        ),
        Text(
            "Offer expires in ${logic.computeLowAndGrowOfferExpiryDays(homeScreenModel.enhancedOffer!.expiryDate)} days",
            style: offerExpireTextStyle()),
      ],
    );
  }

  Widget _computeUpgradeFeaturesWidget() {
    UpgradedFeatureType? type =
        homeScreenModel.enhancedOffer!.upgradedFeatures!.upgradedFeatureType;
    Get.log("type - $type");
    switch (type) {
      case UpgradedFeatureType.roi:
        return _enhancedROIWidget();
      case UpgradedFeatureType.tenure:
        return _enhancedTenureWidget();
      case UpgradedFeatureType.limit:
        return _enhancedLimitWidget();
      case UpgradedFeatureType.pf:
        return _enhancedPfWidget();
      case UpgradedFeatureType.roiAndLimit:
        return _enhancedROILimitWidget();
      case UpgradedFeatureType.limitAndTenure:
        return _enhancedTenureLimitWidget();
      case UpgradedFeatureType.roiAndTenure:
        return _enhancedROITenureWidget();
      case UpgradedFeatureType.roiAndPf:
        return _enhancedRoiPfWidget();
      case UpgradedFeatureType.limitAndPf:
        return _enhancedLimitPFWidget();
      case UpgradedFeatureType.tenureAndPf:
        return _enhancedTenurePFWidget();
      case UpgradedFeatureType.roiLimitTenure:
        return _enhancedROILimitWidget();
      case UpgradedFeatureType.roiTenurePf:
        return _enhancedRoiPfWidget();
      case UpgradedFeatureType.limitTenurePf:
        return _enhancedLimitPFWidget();
      case UpgradedFeatureType.roiLimitPf:
        return _allEnhancedWidget();
      case UpgradedFeatureType.all:
        return _allEnhancedWidget();
      default:
        return _enhancedLimitWidget();
    }
  }

  Widget _enhancedLimitWidget() {
    return _titleStrikeThroughWidget(
      data:
          "₹ ${AppFunctions().parseIntoCommaFormat(homeScreenModel.totalLimit.toString())}",
      enhancedData:
          "₹ ${AppFunctions().parseIntoCommaFormat(homeScreenModel.enhancedOffer!.totalLimit!.toString())}",
    );
  }

  Column _enhancedTenureWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tenure",
          style: _titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
        ),
        _titleStrikeThroughWidget(
          data: "${homeScreenModel.maxTenure} Months",
          enhancedData: "${homeScreenModel.enhancedOffer!.maxTenure!} Months",
        )
      ],
    );
  }

  Column _enhancedROIWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rate Of Interest",
          style: _titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
        ),
        _titleStrikeThroughWidget(
          data: "${homeScreenModel.roi}%",
          enhancedData: "${homeScreenModel.enhancedOffer!.roi!}%",
        ),
      ],
    );
  }

  Column _enhancedPfWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Processing fee",
          style:_titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
        ),
        _titleStrikeThroughWidget(
          data: "${homeScreenModel.processingFee} %",
          enhancedData: "${homeScreenModel.enhancedOffer!.processingFee!} %",
        )
      ],
    );
  }

  Column _enhancedROITenureWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleStrikeThroughWidget(
          data: "${homeScreenModel.roi}%",
          enhancedData: "${homeScreenModel.enhancedOffer!.roi!}%",
        ),
        Text(
          "Rate Of Interest",
          style: _titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        _tenureRichText(),
      ],
    );
  }

  Column _enhancedRoiPfWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleStrikeThroughWidget(
          data: "${homeScreenModel.roi}%",
          enhancedData: "${homeScreenModel.enhancedOffer!.roi!}%",
        ),
        const SizedBox(
          height: 5,
        ),
        _PFRichText()
      ],
    );
  }

  Column _enhancedTenureLimitWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enhancedLimitWidget(),
        _tenureRichText(),
      ],
    );
  }

  Column _enhancedLimitPFWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enhancedLimitWidget(),
        _PFRichText()
      ],
    );
  }

  Column _enhancedTenurePFWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tenureRichText(),
        _PFRichText()
      ],
    );
  }

  Column _enhancedROILimitWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enhancedLimitWidget(),
        _roiRichText(),
      ],
    );
  }

  Column _allEnhancedWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _enhancedLimitWidget(),
        _roiPfRichText(),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _titleStrikeThroughWidget({
    required String data,
    required String enhancedData,
  }) {
    return Row(
      children: [
        Text(
          enhancedData,
          style: _titleTextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          data,
          style: _strikeThroughTextStyle(),
        ),
      ],
    );
  }

  RichText _roiPfRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "At ROI ${homeScreenModel.enhancedOffer!.roi!.toString()}% ",
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree'),
          ),
          TextSpan(
            text: " ${homeScreenModel.roi.toString()}%",
            style: _strikeThroughTextStyle(fontSize: 8),
          ),
          TextSpan(
            text: " + ",
            style: _titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
          ),
          TextSpan(
            text:
                "Processing fee upto ${homeScreenModel.enhancedOffer!.processingFee!.toString()}% ",
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree'),
          ),
          TextSpan(
            text: " ${homeScreenModel.processingFee.toString()}%",
            style: _strikeThroughTextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  RichText _roiRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "At ROI ${homeScreenModel.enhancedOffer!.roi!.toString()}% ",
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                fontFamily: 'Figtree'),
          ),
          TextSpan(
            text: " ${homeScreenModel.roi.toString()}%",
            style: _strikeThroughTextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  RichText _tenureRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "${homeScreenModel.enhancedOffer!.maxTenure!} Months ",
            style: _titleTextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: "${homeScreenModel.maxTenure} Months",
            style: _strikeThroughTextStyle(fontSize: 8),
          ),
          TextSpan(
            text: " Tenure",
            style: _titleTextStyle(fontSize: 11,fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  RichText _PFRichText() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Processing fee upto ${homeScreenModel.enhancedOffer!.processingFee!}% ",
            style: _titleTextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: "${homeScreenModel.processingFee} %",
            style: _strikeThroughTextStyle(fontSize: 8),
          )
        ],
      ),
    );
  }

  ///text styles

  TextStyle offerExpireTextStyle() {
    return const TextStyle(
        fontSize: 10, color: Color(0xffFD707B), fontWeight: FontWeight.w500);
  }

  TextStyle _titleTextStyle(
      {required double fontSize, required FontWeight fontWeight}) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      letterSpacing: 0.18,
      fontWeight: fontWeight,
      color: const Color(0xffFFF3EB),
    );
  }

  TextStyle _strikeThroughTextStyle({double fontSize = 12}) {
    return TextStyle(
        fontSize: fontSize,
        letterSpacing: .16,
        fontWeight: FontWeight.w400,
        color: const Color(0xffFFF3EB),
        decoration: TextDecoration.lineThrough);
  }
}
