import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_insurance/withdraw_insurance_details_page.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

import '../../../../../../firebase/analytics.dart';
import '../../../../../../models/withdrawal_calculation_model.dart';

class InsuranceContainerLogic extends GetxController {
  final withdrawalLogic = Get.find<WithdrawalLogic>();

  @override
  void onReady() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.insuranceScreenLoaded);
  }

  String get _premiumPerDay {
    return withdrawalLogic
            .withdrawalCalculationModel?.insuranceDetails?.premiumPerDay ??
        "";
  }

  String get computePremiumPerDay {
    num? premPerDay = num.tryParse(_premiumPerDay);
    if (premPerDay == null) {
      return "";
    } else if (premPerDay < 1) {
      return "<₹1";
    }
    return "₹$_premiumPerDay";
  }

  List<PolicyBenefit> get policyBenefitList {
    return withdrawalLogic
            .withdrawalCalculationModel?.insuranceDetails?.policyBenefits ??
        [];
  }

  ///Insurance Check Box
  final String CHECK_BOX_ID = 'check_box_id';
  final String LIST_ID = 'list_id';

  bool _isInsuranceChecked = true;

  bool get isInsuranceChecked => _isInsuranceChecked;

  set isInsuranceChecked(bool value) {
    _isInsuranceChecked = value;
    update([CHECK_BOX_ID]);
  }

  void toggleInsuranceCheckBox(bool? value) {
    if (value != null) {
      isInsuranceChecked = value;
      _computeInsuranceOptInEvent();
      withdrawalLogic.computeNetDisbursalAmount(value);
    }
  }

  void _computeInsuranceOptInEvent() {
    if (isInsuranceChecked) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.optInTicked);
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.optOutTicked);
    }
  }

  ///Benefits carousel slider
  final String BENEFITS_SLIDER_ID = 'benefits_slider_id';

  final benefitsPageViewController = PageController(
    initialPage: 0,
  );

  int _currentSliderIndex = 0;

  int get currentSliderIndex => _currentSliderIndex;

  set currentSliderIndex(int value) {
    _currentSliderIndex = value;
    update([BENEFITS_SLIDER_ID]);
  }

  double _currentSliderChildWidgetHeight = 0;

  double get currentSliderChildWidgetHeight => _currentSliderChildWidgetHeight;

  set currentSliderChildWidgetHeight(double value) {
    _currentSliderChildWidgetHeight = value;
    update([BENEFITS_SLIDER_ID]);
  }

  void onCarouselSliderPageChanged(int value) {
    currentSliderIndex = value;
  }

  void onInsuranceContainerTapped() {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.insuranceDetailsClicked);
    Get.bottomSheet(
      WithdrawInsuranceDetailsPage(),
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: Colors.white,
    );
  }
}
