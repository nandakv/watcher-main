import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/modules/feedback/feedback_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_page_state_maps.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/withdrawal_pie_chart.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_widget/partner_pre_approved_home_page_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/widgets/offer_expiry_alert.dart';
import 'package:privo/app/modules/home_screen_module/widgets/block_home_page_card_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/disbursal_complete/top_widget/disbursal_complete_home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/offer_zone_section/offer_zone_card.dart';
import 'package:privo/app/modules/home_screen_module/widgets/withdrawal_home_page/withdrawal_limit_details_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/res.dart';
import 'package:privo/app/models/processing_fee_model.dart';
import '../firebase/analytics.dart';
import '../modules/home_screen_module/home_screen_card/withdrawal_home_screen_card.dart';
import '../modules/home_screen_module/home_screen_logic.dart';
import '../modules/home_screen_module/home_screen_widget/home_screen_widget.dart';
import '../modules/home_screen_module/widgets/alert/widgets/credit_line_expiry_alert.dart';
import '../modules/home_screen_module/widgets/alert/widgets/upgrade_offer_alert_widget.dart';
import '../modules/home_screen_module/widgets/expiry_home_page_card/expiry_home_page_card.dart';
import '../modules/home_screen_module/widgets/alert/home_page_alert_widget.dart';
import '../modules/home_screen_module/widgets/rejection_home_screen_widget.dart';
import '../modules/low_and_grow/widgets/low_and_grow_offer/model/low_and_grow_enhanced_offer_model.dart';
import '../modules/on_boarding/mixins/app_form_mixin.dart';

import '../utils/web_engage_constant.dart';
import 'home_card_rich_text_values.dart';

HomeScreenCardModel homePageFromJson(ApiResponse apiResponse, LpcCard lpcCard) {
  return HomeScreenCardModel.decodeResponse(apiResponse, lpcCard);
}

class HomeScreenCardModel {
  late final String responseCode;
  late final int timestamp;
  late final String appFormId;
  late final ApiResponse apiResponse;
  late final HomeScreenType homeScreenType;
  late String info;
  late int appState;
  late String screen;
  late String buttonText;
  late Widget homeScreenTypeWidget;
  late Widget bottomWidget;
  late String backGround;
  late bool isPartnerFlow;
  List<Widget> alertWidgets = [];

  // late HomeScreenStatus homeScreenStatus;
  late LoanProductCode loanProductCode;
  late String platformType;
  late bool isBrowserToAppFlow;
  SequenceEngineModel? sequenceEngineModel;
  late final bool showCreditReport;
  String creditReportUpdatedDate = "";
  late HomeScreenCardState homeScreenCardState;

  ///processing fee
  String offerText = "";
  String offerTitle = "";
  late final ProcessingFeeModel? processingFeeModel;

  final int _subTitleIndex = 2;
  final int _titleIndex = 1;
  final int _headerIndex = 0;

  // ///check for polling
  // bool isHomeScreenPolling = false;

  ///rejected/expired screen values
  String message = "";
  String title = "";
  bool showFeedBackScreen = false;
  bool showBenefits = false;
  late String lpcName;

  HomeScreenCardModel.decodeResponse(ApiResponse apiResponse, LpcCard lpcCard) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<String, dynamic> jsonMap = jsonDecode(apiResponse.apiResponse);
          _parseJson(jsonMap, lpcCard);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(Map<String, dynamic> json, LpcCard lpcCard) {
    responseCode = json['responseCode'];
    timestamp = json['timestamp'];
    appFormId = json['appFormId'] ?? "";
    info = json['responseBody']['info'] ?? "";
    appState = int.parse(json['responseBody']['app_state'] ?? "0");
    screen = json['responseBody']['screen'];
    loanProductCode = computeLoanProductCode(json['responseBody']['lpc']);
    buttonText = json['responseBody']['button_text'];
    offerText = json['responseBody']['offer_text'] ?? "";
    isPartnerFlow = json['responseBody']['is_partner_flow'] ?? false;
    platformType = json['responseBody']['platform_type'] ?? "";
    isBrowserToAppFlow = platformType == "web";
    sequenceEngineModel = json['sequenceEngine'] != null
        ? SequenceEngineModel.fromJson(json['sequenceEngine'])
        : null;
    if (json['responseBody']['offer_info'] != null) {
      offerTitle = json['responseBody']['offer_info']['title'] ?? "";
      _parseOfferText();
    }
    // isRejected = json['responseBody']['is_rejected'];
    _computeHomeScreenStatus(json['responseBody'], lpcCard);
    if (shouldComputeHomeScreenDetails(json)) {
      homeScreenType = computeHomeScreenInfo(json);
      homeScreenType.parseScreenTypeVariables(json, lpcCard);
      homeScreenTypeWidget =
          homeScreenType.computeHomeScreenTypeWidget(lpcCard);
      alertWidgets = homeScreenType.computeAlertWidget();
      backGround = homeScreenType.background;
      _parsePauseLoanDetails(json['responseBody']);
      showBenefits = _computeShowBenefits(json['responseBody']);
    }
    lpcName = lpcCard.loanProductName;
    showCreditReport = json['responseBody']['show_credit_report'] ?? false;
    if (showCreditReport) {
      DateTime creditReportDate =
          DateTime.parse(json['responseBody']['credit_report_date']);
      creditReportUpdatedDate =
          DateFormat("d MMMM, y").format(creditReportDate);
    }
  }

  bool shouldComputeHomeScreenDetails(Map<String, dynamic> json) {
    return json['responseBody']['screen'] != ACCOUNT_DELETED &&
        ![HomeScreenCardState.iosBeta, HomeScreenCardState.clpDisabled]
            .contains(homeScreenCardState);
  }

  HomeScreenType computeHomeScreenInfo(Map<String, dynamic> json) {
    return computeHomePageModelMap(json['responseBody']['screen']);
  }

  void _parseOfferText() {
    List<String> data = offerTitle.split('|');
    if (data.length == 3) {
      processingFeeModel = ProcessingFeeModel(
          offerFirstHeaderTitle: data[_headerIndex],
          offerSecondHeaderTitle: data[_titleIndex],
          offerHeaderSubTitle: data[_subTitleIndex]);
    } else {
      processingFeeModel = null;
    }
  }

  void _setTitleSubTitleForIosBetaScreen() {
    title = "Credit Saison India";
    message =
        "iOS app is currently available only for users with active Credit Saison India loan";
  }

  // bool _computePollingScreen(responseBody) {
  //   if (responseBody['screen'] == WITHDRAW_KEY) {
  //     return responseBody[WITHDRAW_KEY]['is_withdrawal_polling'] ?? false;
  //   }
  //
  //   ///commented below app states,
  //   ///for eMandate we need to poll in the home screen
  //   ///once eMandate is integrated will remove these comments
  //   var pollingStateList = [
  //     // BUREAU_POLLING_KEY,
  //     // OFFER_POLLING_KEY,
  //     // KYC_POLLING_KEY,
  //     // BANK_DETAILS_POLLING_KEY,
  //     // WITHDRAWAL_POLLING_KEY,
  //     // AA_POLLING_KEY,
  //     // ELIGIBILITY_POLLING_KEY,
  //     EMANDATE_POLLING_KEY,
  //   ];
  //   return pollingStateList.contains('${responseBody['screen']}');
  // }

  void _computeHomeScreenStatus(responseBody, LpcCard lpcCard) {
    if (lpcCard.lpcCardType == LPCCardType.topUp) {
      homeScreenCardState = HomeScreenCardState.success;
    } else if (responseBody['screen'] == ACCOUNT_DELETED) {
      title = responseBody[ACCOUNT_DELETED]['title'] ?? "";
      message = responseBody[ACCOUNT_DELETED]['message'] ?? "";
      homeScreenCardState = HomeScreenCardState.success;
    } else if (loanProductCode == LoanProductCode.clp &&
        // If appstate is 18, continue showing existing card. If appstate is 0 then we show SBD card
        (![18, 0, 999].contains(appState) ||
            [CREDIT_LINE_EXPIRY, OFFER_EXPIRY].contains(screen))) {
      homeScreenCardState = HomeScreenCardState.clpDisabled;
    } else if (responseBody['is_rejected'] && Platform.isIOS) {
      _setTitleSubTitleForIosBetaScreen();
      homeScreenCardState = HomeScreenCardState.iosBeta;
    } else if (Platform.isIOS && responseBody['app_state'] != "18") {
      _setTitleSubTitleForIosBetaScreen();
      homeScreenCardState = HomeScreenCardState.iosBeta;
    } else {
      homeScreenCardState = HomeScreenCardState.success;
    }
    // homeScreenStatus = HomeScreenStatus.typical;
  }

  void _parsePauseLoanDetails(responseBody) {
    Map<String, dynamic> screenInfo = responseBody['${responseBody['screen']}'];
    title = screenInfo["title"] ?? "";
    message = screenInfo["message"] ?? "";
  }

  bool _computeShowBenefits(Map<String, dynamic> json) {
    if (loanProductCode == LoanProductCode.clp) {
      switch (screen) {
        case REJECTION:
        case OFFER_EXPIRY:
        case CREDIT_LINE_EXPIRY:
          return false;
      }
      if (screen == WITHDRAW_KEY) {
        Map<String, dynamic> screenInfo = json['${json['screen']}'];
        return screenInfo['is_first_withdrawal'] ?? false;
      }
      return true;
    }
    return false;
  }

  LoanProductCode computeLoanProductCode(lpc) {
    switch (lpc) {
      case "CLP":
        return LoanProductCode.clp;
      case "UPL":
        return LoanProductCode.upl;
      case "SBL":
        return LoanProductCode.sbl;
      case "SBD":
      case "SBA":
        return LoanProductCode.sbd;
      default:
        return LoanProductCode.unknown;
    }
  }
}

abstract class HomeScreenType {
  final String background;
  late Widget? alert;
  late final HomeCardTexts homeCardTexts = HomeCardTexts();

  HomeScreenType({this.background = ""});

  Widget computeHomeScreenTypeWidget(LpcCard lpcCard);

  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {}

  List<Widget> computeAlertWidget();
}

class PersonalDetailsHomeScreenType extends HomeScreenType {
  PersonalDetailsHomeScreenType();

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        bodyTextValues: homeCardTexts.preOfferSblbodyInfoList,
        bodyVerticalSpace: 0,
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {}

  @override
  computeAlertWidget() {
    return [];
  }
}

class PartnerPreApprovedOfferDetailsScreenType extends HomeScreenType {
  PartnerPreApprovedOfferDetailsScreenType();

  late String screenInfo;
  late String limitAmount;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return PartnerPreApprovedHomePageCard(
      limitAmount: limitAmount,
      lpcCard: lpcCard,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    screenInfo = _screenInfo["message"];
    limitAmount = _screenInfo['limitAmount'];
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class WorkDetailsHomeScreenType extends HomeScreenType {
  WorkDetailsHomeScreenType();

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        bodyTextValues: homeCardTexts.workDetailsTitleList,
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {}

  @override
  computeAlertWidget() {
    return [];
  }
}

class AABankDetailsHomeScreenType extends HomeScreenType {
  AABankDetailsHomeScreenType();

  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        bodyText: info,
        bodyVerticalSpace: 20,
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    info = json['responseBody']['info'];
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class OfferPollingDetailsHomeScreenType extends HomeScreenType {
  OfferPollingDetailsHomeScreenType();

  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        bodyText: info,
        bodyVerticalSpace: 20,
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    info = json['responseBody']['info'];
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class EligibilityOfferDetailsHomeScreenType extends HomeScreenType {
  late String title;
  late String subtitle;
  late String roi;
  late String limitAmount;
  late String buttonText;
  late String offerText;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        titleTextValues: homeCardTexts.eligibilityOfferTitleList,
        bodyTextValues: homeCardTexts.offerDetailsBodyTextValues(
            limitAmount: limitAmount, offerText: offerText),
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    title = _screenInfo['title'];
    subtitle = _screenInfo['subtitle'];
    roi = _screenInfo['roi'];
    limitAmount = _screenInfo['limit'];

    offerText = "at ${double.parse(roi)}% Rate Of Interest";

    buttonText = _responseBody['button_text'];
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

///Same model will be used for aadhaar selfie and offer details
///as no content and screen changes
class OfferDetailsHomeScreenType extends HomeScreenType {
  late String limitAmount;
  late String roi;
  late int minTenure;
  late int maxTenure;
  late String offerText;
  Widget? alertWidget;
  String? nudgeText;
  late String message;
  late String info;
  List<Widget> alertWidgets = [];

  OfferDetailsHomeScreenType() : super();

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        nudgeText: nudgeText,
        cardBadgeType: CardBadgeType.progress,
        lpcCard: lpcCard,
        bodyText: message,
        bodyTextValues: homeCardTexts.offerDetailsBodyTextValues(
            limitAmount: limitAmount, offerText: offerText),
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    // super.initJson(json);
    Get.log("Init from offer");
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    limitAmount = _screenInfo['limit'];
    roi = _screenInfo['roi'];
    minTenure = int.parse("${_screenInfo['min_tenure']}".isEmpty
        ? "0"
        : _screenInfo['min_tenure']);
    maxTenure = int.parse(_screenInfo['max_tenure']);

    offerText =
        "at ${double.parse(roi)}% ROI with a tenure of $minTenure-$maxTenure months";

    if (_responseBody['days_to_cl_expiry'] != null) {
      alertWidgets.add(CreditLineExpiryAlert(
        lpcCard: lpcCard,
      ));
      int clExpiryDays = _responseBody['days_to_cl_expiry'];
      if (clExpiryDays == 0) {
        nudgeText = "Credit line expires today";
      } else {
        nudgeText = "Credit Line expires in $clExpiryDays days";
      }
    }
    //ToDo: test and remove else if
    else if (_screenInfo['days_to_expiry'] != null) {
      alertWidgets.add(OfferExpiryAlert(
        lpcCard: lpcCard,
      ));
      int offerExpiryDays = _screenInfo['days_to_expiry'];
      if (offerExpiryDays == 0) {
        nudgeText = "Offer expires today";
      } else {
        nudgeText = "Offer expires in $offerExpiryDays days";
      }
    }
    message = json['responseBody']['info'];
  }

  @override
  computeAlertWidget() {
    return alertWidgets;
  }
}

class LineAgreementDetailsHomeScreenType extends HomeScreenType {
  late String limitAmount;
  late String roi;
  late int minTenure;
  late int maxTenure;
  late String offerText;
  Widget? alertWidget;
  String? nudgeText;

  List<Widget> alertWidgets = [];

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        nudgeText: nudgeText,
        titleTextValues: homeCardTexts.lineAgreementTitleList,
        bodyTextValues: homeCardTexts.offerDetailsBodyTextValues(
            limitAmount: limitAmount, offerText: offerText),
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    limitAmount = _screenInfo['limit'];
    roi = _screenInfo['roi'];
    minTenure = int.parse("${_screenInfo['min_tenure']}".isEmpty
        ? "0"
        : _screenInfo['min_tenure']);
    maxTenure = int.parse(_screenInfo['max_tenure']);
    offerText =
        "at ${double.parse(roi)}% ROI with a tenure of $minTenure-$maxTenure months";

    if (_screenInfo['days_to_expiry'] != null) {
      alertWidget = OfferExpiryAlert(
        lpcCard: lpcCard,
      );
      alertWidgets.add(OfferExpiryAlert(
        lpcCard: lpcCard,
      ));
      int offerExpiryDays = _screenInfo['days_to_expiry'];
      if (offerExpiryDays == 0) {
        nudgeText = "Offer expires today";
      } else {
        nudgeText = "Offer expires in $offerExpiryDays days";
      }
    }
  }

  @override
  computeAlertWidget() {
    return alertWidgets;
  }
}

class UpgradeOfferDetailsHomeScreenType extends OfferDetailsHomeScreenType {
  late bool isUpgradeEligible;
  late bool isOfferUpgraded;
  late bool isROIDecreased;
  late String pastROI;
  late String pastLimit;
  late String pastMinTenure;
  late String pastMaxTenure;
  late String oldOfferText = "";
  Widget? alertWidget;
  String? nudgeText;
  late String info;

  UpgradeOfferDetailsHomeScreenType() : super();

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        nudgeText: nudgeText,
        image: Res.offerBaloons,
        bodyVerticalSpace: 17,
        cardBadgeType: CardBadgeType.progress,
        bodyTextValues: homeCardTexts.offerDetailsBodyTextValues(
            limitAmount: limitAmount,
            infoText: info + "\n",
            offerText: offerText,
            oldLimitAmout: isOfferUpgraded ? pastLimit : null,
            oldOfferText: isOfferUpgraded ? oldOfferText : null),
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Get.log("Init from offer");
    Map<String, dynamic> responseBody = json['responseBody'];
    info = responseBody['info'] ?? "";
    Map<String, dynamic> screenInfo = responseBody['${responseBody['screen']}'];
    isUpgradeEligible = screenInfo['is_upgrade_eligible'] ?? false;
    isOfferUpgraded = _computeOfferUpgraded(screenInfo);
    limitAmount = screenInfo['limit'];
    roi = screenInfo['roi'];
    minTenure = int.parse(
        "${screenInfo['min_tenure']}".isEmpty ? "0" : screenInfo['min_tenure']);
    maxTenure = int.parse(screenInfo['max_tenure']);

    offerText =
        "at ${double.parse(roi)}% ROI with a tenure of $maxTenure months";
    Map<String, dynamic> pastOffers = screenInfo['past_offer'] ?? {};
    if (pastOffers.isNotEmpty) {
      pastLimit = pastOffers['limit'];
      pastROI = pastOffers['roi'];
      pastMinTenure = pastOffers['min_tenure'];
      pastMaxTenure = pastOffers['max_tenure'];
      oldOfferText =
          "at ${double.parse(pastROI)}% ROI with a tenure of $pastMinTenure-$pastMaxTenure months";
      isROIDecreased = _computeROIDecreased();
    } else {
      isROIDecreased = false;
    }
    if (isUpgradeEligible) {
      alertWidget = UpgradeOfferAlertWidget(
        lpcCard: lpcCard,
      );
    } else if (screenInfo['days_to_expiry'] != null) {
      alertWidget = OfferExpiryAlert(
        lpcCard: lpcCard,
      );
      int offerExpiryDays = screenInfo['days_to_expiry'];
      if (offerExpiryDays == 0) {
        nudgeText = "Offer expires today";
      } else {
        nudgeText = "Offer expires in $offerExpiryDays days";
      }
    }
  }

  bool _computeOfferUpgraded(Map<String, dynamic> screenInfo) {
    return screenInfo['upgrade_offer_status'] != null &&
        screenInfo['upgrade_offer_status'] == "OFFER_UPGRADED";
  }

  bool _computeROIDecreased() {
    return double.parse(roi) < double.parse(pastROI);
  }
}

class WithdrawalDetailsHomeScreenType extends HomeScreenType {
  WithdrawalDetailsHomeScreenType() : super(background: Res.withdrawal_pattern);

  late double totalLimit;
  late double utilizedLimit;
  late double availableLimit;

  // late double reservedLimit;
  late String roi;
  late int minTenure;
  late int maxTenure;
  late double
      availableMinLimit; // Avaialble min limit is made as null since other lpc's (FCL) doesn't have a available min limit. In this case it comes as null
  late double utilizedLimitPercentage;
  late bool isFirstWithdrawal;
  late String cif;
  late bool collectAddress;
  late bool isOfferUpgraded;
  EnhancedOffer? enhancedOffer;
  late String lastRawSmsDateTime;
  late String processingFee;
  late bool isWithdrawalPolling = false;
  late String pollingMessage;
  late CurrentWithdrawModel? currentWithdrawModel;
  late bool isWithdrawFailed = false;
  late Widget alertWidget;
  List<Widget> alertWidgets = [];
  String? nudgeText;
  int? clExpiryDays;
  late String withdrawalCardTitle;
  List<WithdrawalLimitType> withdrawalDataPoints =
      []; //Initially empty as if no data points are required it can be shown as empty
  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: WithdrawalHomeScreenCard(
        withdrawalHomePageType: this,
        lpcCard: lpcCard,
        pieChart: Container(
          height: 110.h,
          margin: EdgeInsets.symmetric(vertical: 12.h),
          child: WithdrawalPieChart(
            withdrawalDetailsHomePageType: this,
          ),
        ),
      ),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    isOfferUpgraded = _responseBody['is_upgraded'] ?? false;
    totalLimit = double.parse(_screenInfo['total_limit']);
    utilizedLimit = double.parse(_screenInfo['utilized_limit']);
    availableLimit = double.parse(_screenInfo['available_limit']);
    roi = _screenInfo['roi'];
    minTenure = int.parse(_screenInfo['min_tenure']);
    maxTenure = int.parse(_screenInfo['max_tenure'].toString());
    availableMinLimit =
        double.parse(_screenInfo['available_min_limit'].toString());
    // reservedLimit = _screenInfo['reserved_limit'];
    utilizedLimitPercentage =
        double.parse(_screenInfo['utilized_limit_percentage']);
    isFirstWithdrawal = _screenInfo['is_first_withdrawal'];
    cif = _screenInfo['cif'];
    collectAddress = _screenInfo['collect_address'];
    enhancedOffer = computeEnhancedOffer(_screenInfo);
    lastRawSmsDateTime = _screenInfo['last_raw_sms_timestamp'] ?? "";
    processingFee = _screenInfo['processing_fee'] ?? "";
    isWithdrawalPolling = _screenInfo['is_withdrawal_polling'] ?? false;
    pollingMessage = _screenInfo['polling_msg'] ?? "";
    currentWithdrawModel = _responseBody['currentWithdrawal'] == null
        ? null
        : CurrentWithdrawModel.fromJson(_responseBody['currentWithdrawal']);
    isWithdrawFailed =
        currentWithdrawModel != null && currentWithdrawModel!.isFailed;
    LoanProductCode lpc = computeLoanProductCode(_responseBody['lpc']);
    withdrawalCardTitle = computeWithdrawalCardTitle(lpc);
    addWithdrawalDataPoints(lpc);

    if (_responseBody['days_to_cl_expiry'] != null) {
      clExpiryDays = _responseBody['days_to_cl_expiry'];
      if (clExpiryDays == 0) {
        nudgeText = "Credit line expires today";
      } else {
        nudgeText = "Credit Line expires in $clExpiryDays days";
      }
    }
    alertWidgets.add(HomePageWithdrawalAlert(
      withdrawalDetailsHomeScreenType: this,
      lpcCard: lpcCard,
    ));
    _setLastSMSTime();
  }

  Future<void> _setLastSMSTime() async {
    await AppAuthProvider.setLastSMSDateTime(lastRawSmsDateTime);
  }

  LoanProductCode computeLoanProductCode(lpc) {
    switch (lpc) {
      case "CLP":
        return LoanProductCode.clp;
      case "UPL":
        return LoanProductCode.upl;
      case "SBL":
        return LoanProductCode.sbl;
      case "SBD":
      case "SBA":
        return LoanProductCode.sbd;
      case "FCL":
        return LoanProductCode.fcl;
      default:
        return LoanProductCode.clp;
    }
  }

  ///Will have to discuss with simon regarding storing of lpc names coming from magnus response
  ///once done will remove this static text too.
  computeWithdrawalCardTitle(LoanProductCode lpc) {
    switch (lpc) {
      case LoanProductCode.clp:
        return "Privo Instant Loan";
      case LoanProductCode.fcl:
        return "Flexi Credit Line";
      default:
        return "";
    }
  }

  ///This function is added so that we can compute all the data points and add it to a list
  ///here in model and in ui we just render this.
  addWithdrawalDataPoints(LoanProductCode lpc) {
    switch (lpc) {
      case LoanProductCode.clp:
        _addClpDataPoints();
        break;
      case LoanProductCode.fcl:
        _addFclDataPoints();
        break;
      default:
        break;
    }
  }

  void _addFclDataPoints() {
    withdrawalDataPoints.addAll([
      WithdrawalLimitType(
          title: "Utilised Amount",
          value:
              "₹${AppFunctions().parseIntoCommaFormat(utilizedLimit.toString())}",
          icon: Res.avaialable_wallet,
          titleColor: secondaryDarkColor,
          valueColor: greenColor),
      WithdrawalLimitType(
          title: "Tenure",
          value: "${maxTenure} months",
          titleColor: secondaryDarkColor,
          icon: Res.tenure_calendar,
          valueColor: const Color(0xFF3F7ECB))
    ]);
  }

  void _addClpDataPoints() {
    withdrawalDataPoints.addAll([
      WithdrawalLimitType(
        title: "Used Limit",
        value: AppFunctions().parseIntoCommaFormat(
          utilizedLimit.toString(),
        ),
        titleColor: secondaryDarkColor,
        icon: Res.avaialable_wallet,
        valueColor: green500,
      ),
      WithdrawalLimitType(
          title: "Available Limit",
          value: AppFunctions().parseIntoCommaFormat(
            availableLimit.toString(),
          ),
          titleColor: secondaryDarkColor,
          icon: Res.used_limit_wallet,
          valueColor: blue900),
    ]);
  }

  EnhancedOffer? computeEnhancedOffer(Map<String, dynamic> _screenInfo) {
    if (_screenInfo['enhanced_offer'] != null &&
        !(_screenInfo['enhanced_offer'].isEmpty)) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgOfferGenerated);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.lgOfferCardLoadedOnHome);
      return EnhancedOffer.fromJson(_screenInfo['enhanced_offer']);
    } else {
      return null;
    }
  }

  @override
  computeAlertWidget() {
    return alertWidgets;
  }
}

class CurrentWithdrawModel {
  late WithdrawalPollingStatus pollingStatus;
  late String disbursalAmount;
  late bool isFailed;

  CurrentWithdrawModel.fromJson(Map<String, dynamic> responseBody) {
    disbursalAmount = responseBody['disbursalAmount'];
    _computeWithdrawalStatus(responseBody['withdrawalStatusCode']);
    isFailed = pollingStatus == WithdrawalPollingStatus.withdrawCancelled;
  }

  void _computeWithdrawalStatus(String status) {
    late String CODE_INITIATED = "101";
    late String CODE_PROCESSING = "111";
    late String CODE_WITHDRAWAL_CANCELED = "90";
    late String CODE_LOAN_CREATED = "140";
    late String CODE_WITHDRAWAL_FAILED = "-90";

    var statusMap = {
      CODE_INITIATED: WithdrawalPollingStatus.initiated,
      CODE_PROCESSING: WithdrawalPollingStatus.processed,
      CODE_WITHDRAWAL_CANCELED: WithdrawalPollingStatus.withdrawCancelled,
      CODE_LOAN_CREATED: WithdrawalPollingStatus.loanCreated,
      CODE_WITHDRAWAL_FAILED: WithdrawalPollingStatus.withdrawalFailed,
    };

    pollingStatus = statusMap[status] ?? WithdrawalPollingStatus.initiated;
  }
}

class EnhancedOffer {
  String? roi;
  double? totalLimit;
  String? minTenure;
  String? maxTenure;
  String? expiryDate;
  String? processingFee;
  UpgradedFeatures? upgradedFeatures;

  EnhancedOffer(
      {this.roi,
      this.totalLimit,
      this.minTenure,
      this.maxTenure,
      this.upgradedFeatures});

  EnhancedOffer.fromJson(Map<String, dynamic> json) {
    roi = json['roi'] ?? "";
    totalLimit =
        json["total_limit"] == null ? 0 : double.parse(json["total_limit"]);
    expiryDate = json['expiry_date'] ?? "";
    minTenure = json['min_tenure'] ?? "";
    maxTenure = json['max_tenure'] ?? "";
    processingFee = json['processing_fee'] ?? "";
    upgradedFeatures = json['upgraded_features'] == null
        ? null
        : UpgradedFeatures.fromJson(json['upgraded_features']);
  }
}

class GenericHomeScreenCard extends HomeScreenType {
  GenericHomeScreenCard(
      {this.cardBadgeType = CardBadgeType.progress, this.image})
      : super();
  CardBadgeType cardBadgeType;
  String? image;
  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenCard(
      lpcCard: lpcCard,
      bodyText: info,
      image: image,
      cardBadgeType: cardBadgeType,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    // super.initJson(json);
    Map<String, dynamic> _responseBody = json['responseBody'];
    info = _responseBody['info'] ?? "";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class BankDetailsHomeScreenCard extends HomeScreenType {
  BankDetailsHomeScreenCard(
      {this.cardBadgeType = CardBadgeType.progress, this.image})
      : super();
  CardBadgeType cardBadgeType;
  String? image;
  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenCard(
      lpcCard: lpcCard,
      bodyText: info,
      image: lpcCard.loanProductCode == "CLP" ? Res.offerBaloons : null,
      cardBadgeType: cardBadgeType,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    // super.initJson(json);
    Map<String, dynamic> _responseBody = json['responseBody'];
    info = _responseBody['info'] ?? "";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class UplDisbursalHomeScreenType extends HomeScreenType {
  UplDisbursalHomeScreenType() : super();

  late String cif;
  List<Widget> alertWidgets = [];

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return DisbursalCompleteHomeScreenCard(
      uplDisbursalCompleteHomePageModel: this,
      lpcCard: lpcCard,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    // super.initJson(json);
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];

    cif = _screenInfo["cif"];

    alertWidgets.add(HomePageWithdrawalAlert(
      lpcCard: lpcCard,
    ));
  }

  @override
  computeAlertWidget() {
    return alertWidgets;
  }
}

class UPLWaitScreenModel extends HomeScreenType {
  UPLWaitScreenModel() : super();

  late String title;
  late String message;

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        _responseBody['${_responseBody['screen']}'];
    title = _screenInfo["title"];
    message = _screenInfo["message"];
  }

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenWidget(
      lpcCard: lpcCard,
      homePageCard: HomeScreenCard(
        lpcCard: lpcCard,
        bodyTextValues: homeCardTexts.uplApplicationReviewBodyList(message),
        bodyText: message,
        bodyVerticalSpace: 0,
        image: Res.sblDisbursalWait,
        bottomWidget: const SizedBox(),
        cardBadgeType: CardBadgeType.progress,
      ),
    );
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class OfferExpiryHomeScreenType extends HomeScreenType {
  late String limitAmount;
  late String roi;
  late String offerText;
  late bool showFeedback;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return ExpiryHomePageCard(
      feedbackType: showFeedback ? FeedbackType.offerExpiry : null,
      nudgeText: "Offer Expired",
      lpcCard: lpcCard,
      titleValues: homeCardTexts.offerExpiredTitleList,
      bodyValues: homeCardTexts.offerDetailsBodyTextValues(
          limitAmount: limitAmount,
          offerText: offerText,
          infoText: "Your Instant loan is no longer active\n"),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        responseBody['${responseBody['screen']}'];
    showFeedback = _screenInfo["show_feedback"] ?? false;

    limitAmount = _screenInfo['limit'];
    String roi = _screenInfo['roi'];
    int minTenure = int.parse("${_screenInfo['min_tenure']}".isEmpty
        ? "0"
        : _screenInfo['min_tenure']);
    int maxTenure = int.parse(_screenInfo['max_tenure']);
    offerText =
        "at ${double.parse(roi)}% ROI with a tenure of $minTenure-$maxTenure months";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class CreditLineExpiryHomeScreenType extends HomeScreenType {
  late String limitAmount;
  late String roi;
  late String offerText;
  late bool showFeedback;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return ExpiryHomePageCard(
      feedbackType: showFeedback ? FeedbackType.creditLineExpiry : null,
      nudgeText: "",
      lpcCard: lpcCard,
      titleValues: homeCardTexts.creditLineExpiredTitleList,
      bodyValues: homeCardTexts.offerDetailsBodyTextValues(
          limitAmount: limitAmount,
          offerText: offerText,
          infoText: "Your personalised offer is no longer active\n"),
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> responseBody = json['responseBody'];
    Map<String, dynamic> _screenInfo =
        responseBody['${responseBody['screen']}'];
    showFeedback = _screenInfo["show_feedback"] ?? false;

    limitAmount = _screenInfo['limit'];
    String roi = _screenInfo['roi'];
    int minTenure = int.parse("${_screenInfo['min_tenure']}".isEmpty
        ? "0"
        : _screenInfo['min_tenure']);
    int maxTenure = int.parse(_screenInfo['max_tenure']);
    offerText =
        "at ${double.parse(roi)}% ROI with a tenure of $minTenure-$maxTenure months";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class RejectionHomeScreenType extends HomeScreenType {
  late String title;
  late String message;
  late bool showFeedback;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return RejectionHomeScreenWidget(
      title: title,
      rejectionHomeScreenType: this,
      lpcCard: lpcCard,
      message: message,
      showFeedback: showFeedback,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> responseBody = json['responseBody'];
    Map<String, dynamic> screenInfo = responseBody['${responseBody['screen']}'];
    title = screenInfo["title"];
    message = screenInfo["message"];
    showFeedback = screenInfo["show_feedback"] ?? false;
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class BlockHomeScreenCardType extends HomeScreenType {
  late String title;
  late String message;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return BlockHomeScreenCardWidget(
      title: title,
      lpcCard: lpcCard,
      message: message,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> responseBody = json['responseBody'];
    Map<String, dynamic> screenInfo = responseBody['${responseBody['screen']}'];
    title = screenInfo["title"];
    message = screenInfo["message"];
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class UdyamHomeScreenCard extends HomeScreenType {
  UdyamHomeScreenCard({this.cardBadgeType = CardBadgeType.progress, this.image})
      : super();
  CardBadgeType cardBadgeType;
  String? image;
  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenCard(
      lpcCard: lpcCard,
      bodyText: info,
      image: Res.udyamHome,
      cardBadgeType: cardBadgeType,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    info = _responseBody['info'] ?? "";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class HomeAABankCard extends HomeScreenType {
  HomeAABankCard({this.cardBadgeType = CardBadgeType.progress, this.image})
      : super();
  CardBadgeType cardBadgeType;
  String? image;
  late String info;

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return HomeScreenCard(
      lpcCard: lpcCard,
      bodyText: info,
      cardBadgeType: cardBadgeType,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> _responseBody = json['responseBody'];
    info = _responseBody['info'] ?? "";
  }

  @override
  computeAlertWidget() {
    return [];
  }
}

class TopUpKnowMoreCardType extends HomeScreenType {
  String daysToExpiry = "";
  late bool isOfferExpired;

  @override
  List<Widget> computeAlertWidget() {
    return [];
  }

  @override
  Widget computeHomeScreenTypeWidget(LpcCard lpcCard) {
    return OfferZoneCard(
      lpcCard: lpcCard,
      isKnowMore: true,
      daysToExpiry: daysToExpiry,
      inProgress: false,
    );
  }

  @override
  parseScreenTypeVariables(Map<String, dynamic> json, LpcCard lpcCard) {
    Map<String, dynamic> responseBody = json['responseBody'];
    Map<String, dynamic> screenInfo = responseBody['${responseBody['screen']}'];

    int? expiryDays = screenInfo['days_to_expiry'];
    if (expiryDays != null) {
      daysToExpiry = expiryDays == 0
          ? "Expires Today"
          : "Expiring in $expiryDays day${expiryDays == 1 ? "" : "s"}";
    }

    isOfferExpired = screenInfo['is_offer_expired'] ?? false;
    if (isOfferExpired) daysToExpiry = "Expired";
  }
}
