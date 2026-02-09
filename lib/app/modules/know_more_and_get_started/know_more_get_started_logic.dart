import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:get/get.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/know_more_and_get_started/helper/document_info_helper_mixin.dart';
import 'package:privo/app/modules/faq/faq_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/helper/know_more_helper_mixin.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_analytics_mixin.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/document_info_bottom_sheet_model.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/lead_details.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/document_info_bottom_sheet.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';

import '../../models/rich_text_model.dart';

enum KnowMoreGetStartedState { knowMore, getStarted }

class KnowMoreGetStartedLogic extends GetxController
    with
        ApiErrorMixin,
        KnowMoreHelperMixin,
        DocumentInfoHelperMixin,
        AppAnalyticsMixin,
        KnowMoreGetStartedAnalyticsMixin {
  final TextEditingController desiredAmountController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();

  late final List<String> tenureList = [
    "12 months",
    "18 months",
    "24 months",
    "30 months",
    "36 months",
  ];

  late final List<String> sbdPurposeList = [
    "Business expansion",
    "Equipment purchase",
    "Cash flow purposes",
    "Inventory purchase",
    "Working capital",
    "Other",
  ];

  late final List<String> clpPurposeList = [
    'Personal Need',
    'Medical Emergency',
    'Home Renovation',
    'Travel',
    'Education',
    'Wedding',
    'Shopping',
    'Other',
  ];

  late final String CONTINUE_BUTTON_ID = "continue_button";

  bool _isButtonEnabled = false;

  bool get isButtonEnabled => _isButtonEnabled;

  set isButtonEnabled(bool value) {
    _isButtonEnabled = value;
    update([CONTINUE_BUTTON_ID]);
  }

  final SwiperController swiperController = SwiperController();

  late final String desiredAmountId = "desired_amount";
  late final String purposeId = "purpose";
  late final String tenureId = "tenure";

  final voiceOfTrustViewController = PageController(
    initialPage: 0,
  );

  late final String title;
  late final String message;
  late final String knowMoreillustration;
  late final String knowMoreBackground;
  late final String getStartedillustration;
  late final Map<String, List<RichTextModel>> keyFeatures;
  late final bool isGetStartedCTAEnabled;

  KnowMoreGetStartedState _knowMoreGetStartedState =
      KnowMoreGetStartedState.knowMore;

  KnowMoreGetStartedState get knowMoreGetStartedState =>
      _knowMoreGetStartedState;

  late final String voiceOfTrustId = "voice_of_trust";

  set knowMoreGetStartedState(KnowMoreGetStartedState value) {
    _knowMoreGetStartedState = value;
    update();
  }

  late final LoanProductCode lpc;

  double _voiceOfTrustCarouselIndex = 0;

  double get voiceOfTrustCarouselIndex => _voiceOfTrustCarouselIndex;

  set voiceOfTrustCarouselIndex(double value) {
    _voiceOfTrustCarouselIndex = value;
    logKnowMoreVocMoved(lpc);
    update([voiceOfTrustId]);
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    _knowMoreGetStartedState =
        arguments['state'] ?? KnowMoreGetStartedState.knowMore;
    lpc = arguments['lpc'] ?? LoanProductCode.clp;
    isGetStartedCTAEnabled = arguments['getStartedCTAEnabled'] ?? false;
    logEventsOnInit(lpc, _knowMoreGetStartedState);
    _computeScreenInfo();
    super.onInit();
  }

  _computeScreenInfo() {
    switch (lpc) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        title = "Small Loans, Big\nDreams";
        message = "Grow your business with our Small\nBusiness Loan today!";
        knowMoreillustration = Res.sblKnowMore;
        knowMoreBackground = Res.sblKnowMoreBg;
        getStartedillustration = Res.getStartedSbl;
        keyFeatures = {
          Res.knowMoreLoan: [
            RichTextModel(
              text: "Loan Upto\n",
              textStyle: featureTextStyle(),
            ),
            RichTextModel(
              text: "15 lakhs",
              textStyle: featureBoldTextStyle(),
            ),
          ],
          Res.knowMorePercentage: [
            RichTextModel(
              text: "Affordable",
              textStyle: featureTextStyle(),
            ),
            RichTextModel(
              text: "\nInterest Rate",
              textStyle: featureBoldTextStyle(),
            ),
          ],
          Res.knowMoreFast: [
            RichTextModel(
              text: "Fast\n",
              textStyle: featureBoldTextStyle(),
            ),
            RichTextModel(
              text: "Approval",
              textStyle: featureTextStyle(),
            ),
          ],
          Res.knowMoreCollateral: [
            RichTextModel(
              text: "No\n",
              textStyle: featureBoldTextStyle(),
            ),
            RichTextModel(
              text: "Collateral",
              textStyle: featureTextStyle(),
            ),
          ],
        };
        break;
      // case LoanProductCode.topup:
      //   title = "Top Up Loan Amount";
      //   message = "You are eligible for a top-up amount upto";
      //   knowMoreillustration = Res.knowMoreTopUp;
      //   break;
      default:
        title = "Your Lifeline for\nInstant Loan";
        message =
            "Get upto 5 Lakhs credit to fulfil your\ndreams and aspirations";
        knowMoreillustration = Res.clpKnowMore;
        getStartedillustration = Res.getStartedClp;
        knowMoreBackground = Res.clpKnowMoreBg;
        keyFeatures = {
          Res.knowMoreLoan: [
            RichTextModel(
              text: "Loan Upto\n",
              textStyle: featureTextStyle(),
            ),
            RichTextModel(
              text: "5 Lakhs",
              textStyle: featureBoldTextStyle(),
            ),
          ],
          Res.knowMorePercentage: [
            RichTextModel(
              text: "Affordable",
              textStyle: featureTextStyle(),
            ),
            RichTextModel(
              text: "\nInterest Rate",
              textStyle: featureBoldTextStyle(),
            ),
          ],
          Res.knowMoreFast: [
            RichTextModel(
              text: "Revolving\n",
              textStyle: featureBoldTextStyle(),
            ),
            RichTextModel(
              text: "Credit",
              textStyle: featureTextStyle(),
            ),
          ],
          Res.knowMoreCollateral: [
            RichTextModel(
              text: "No\n",
              textStyle: featureBoldTextStyle(),
            ),
            RichTextModel(
              text: "Documents",
              textStyle: featureTextStyle(),
            ),
          ],
        };

        break;
    }
  }

  TextStyle featureTextStyle() {
    return const TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      color: darkBlueColor,
      fontFamily: 'Figtree',
    );
  }

  TextStyle featureBoldTextStyle() {
    return const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: darkBlueColor,
        fontFamily: 'Figtree');
  }

  bool get isSBD => lpc == LoanProductCode.sbd;

  onDocumentsInfoTap(DocumentInfoModel documentInfoModel) {
    logDocumentIClicked(lpc, knowMoreGetStartedState);
    Get.bottomSheet(
      DocumentInfoBottomSheet(
        documentInfoBottomSheetModel: documentInfoModel,
      ),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
    );
  }

  List<String> get purposeList {
    switch (lpc) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        return sbdPurposeList;
      default:
        return clpPurposeList;
    }
  }

  String? desiredAmountValidation(String? val) {
    switch (lpc) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        return sbdDesiredAmountValidation(val);
      default:
        return clpDesiredAmountValidation(val);
    }
  }

  String? sbdDesiredAmountValidation(String? val) {
    if (val == null || val.isEmpty) {
      return "Enter an amount between ₹20,000 - ₹10,00,000";
    }
    double enteredValue = parseIntoDoubleFormat(val);
    if (enteredValue < 20000 || enteredValue > 1000000) {
      return "Enter an amount between ₹20,000 - ₹10,00,000";
    }
    return null;
  }

  String? clpDesiredAmountValidation(String? val) {
    if (val == null || val.isEmpty) {
      return "Enter an amount between ₹1,000 - ₹5,00,000";
    }
    double enteredValue = parseIntoDoubleFormat(val);
    if (enteredValue < 1000 || enteredValue > 500000) {
      return "Enter an amount between ₹1,000 - ₹5,00,000";
    }
    return null;
  }

  isFormValid() {
    isButtonEnabled = isDesiredAmountValid &&
        purposeController.text.isNotEmpty &&
        tenureController.text.isNotEmpty;
  }

  bool get isDesiredAmountValid =>
      desiredAmountValidation(desiredAmountController.text) == null;

  ///Parse comma seperated money value to normal double format for calculations
  double parseIntoDoubleFormat(String value) {
    Get.log("value for parsing - $value");
    try {
      return double.parse(value.replaceAll(',', ''));
    } catch (e) {
      Get.log("can't parse money - $e");
      return 0;
    }
  }

  onGetStartedTap() {
    if (knowMoreGetStartedState == KnowMoreGetStartedState.knowMore) {
      knowMoreGetStartedState = KnowMoreGetStartedState.getStarted;
      logKnowMoreGetStartedClicked(lpc);
      logGetStartedLoaded(lpc);
    }
  }

  onContinueTap() {
    logGetStartedRequirementSubmitted(lpc, desiredAmountController.text,
        purposeController.text, tenureController.text);
    Get.back(
      result: LeadDetails(
        desiredAmount: parseIntoIntFormat(desiredAmountController.text),
        purpose: purposeController.text,
        tenure: parseIntoIntFormat(tenureController.text.split(" ").first),
      ),
    );
  }

  FAQModel computeFAQModel() {
    switch (lpc) {
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        return sblKnowMoreFAQs;
      default:
        return clpKnowMoreFAQs;
    }
  }

  int parseIntoIntFormat(String value) {
    Get.log("value for parsing - $value");
    try {
      return int.parse(value.replaceAll(',', ''));
    } catch (e) {
      Get.log("can't parse money - $e");
      return 0;
    }
  }
}
