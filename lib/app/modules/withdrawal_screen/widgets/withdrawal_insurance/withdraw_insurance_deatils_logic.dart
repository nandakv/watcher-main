import 'package:get/get.dart';
import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal_insurance/policy_benefit_bottom_sheet_widget.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_navigation.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../firebase/analytics.dart';
import '../../mixins/withdrawal_api_mixin.dart';

class WithdrawInsuranceDetailsLogic extends GetxController
    with WithdrawalApiMixin {
  static const WITHDRAW_INSURANCE_DETAILS_LOGIC =
      "withdraw_insurance_details_logic";
  WithdrawalNavigation? withdrawalNavigation;

  WithdrawInsuranceDetailsLogic({this.withdrawalNavigation});

  final withdrawalLogic = Get.find<WithdrawalLogic>();

  WithdrawalInsuranceDetails get insuranceDetails =>
      withdrawalLogic.withdrawalCalculationModel!.insuranceDetails!;

  openPolicyBenefitBottomSheet(PolicyBenefit policyBenefit) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.policyBenefitClicked,
        attributeName: {'benefit_name': policyBenefit.benefitTitle});
    Get.bottomSheet(
      PolicyBenefitBottomSheetWidget(policyBenefit: policyBenefit),
    );
  }

  onBackAndClosePressed() {
    Get.back();
    return false;
  }

  onPhoneTapped(String phoneNumber) {
    launchUrlString("tel:$phoneNumber");
  }

  onEmailTapped(String email) {
    launchUrlString("mailto:$email");
  }

  String onPressInsuranceProductGlossary() {
    final acceptanceClausesData = insuranceDetails.acceptanceClauses
        .where((element) => element.title == "Consent clause");
    if (acceptanceClausesData.isNotEmpty) {
      final infoLink = acceptanceClausesData.first.info
          .where((element) => element.text == 'here');
      return infoLink.first.link;
    }
    return '';
  }
}
