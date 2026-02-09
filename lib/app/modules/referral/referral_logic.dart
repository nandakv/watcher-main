import 'dart:convert';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/referral_repository.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/referral_data_model.dart';
import 'package:privo/app/modules/faq/faq_page.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/modules/referral/widgets/my_referral_info_bottomsheet.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/carousel_widget/carousel_item_model.dart';
import '../../../components/timeline_widget/timeline_model.dart';
import '../../../res.dart';
import '../../api/api_error_mixin.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/referral_updates_bottom_sheet.dart';

enum ReferralPageState { loading, success, tnc }

class ReferralLogic extends GetxController with ApiErrorMixin {
  final String BUTTON_ID = "referral_button";
  final String REFERRAL_SCREEN = "REFERRAL_SCREEN";

  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID]);
  }

  ReferralPageState _referralPageState = ReferralPageState.loading;

  ReferralPageState get referralPageState => _referralPageState;

  set referralPageState(ReferralPageState value) {
    _referralPageState = value;
    update([TOP_NAVIGATION_BAR_ID, REFERRAL_SCREEN]);
  }

  late ReferralDataModel referralDataModel;

  String TOP_NAVIGATION_BAR_ID = "TOP_NAVIGATION_BAR_ID";

  bool fromHomePage = false;

  final String LEADERBOARD_BUTTON_ID = "leaderboard_button";

  bool _isLeaderBoardNotified = false;

  bool get isLeaderBoardNotified => _isLeaderBoardNotified;

  set isLeaderBoardNotified(bool value) {
    _isLeaderBoardNotified = value;
    update([LEADERBOARD_BUTTON_ID]);
  }

  final List<String> termsAndConditions = [
    "Eligibility: Participation in the referral program is open to individuals who meet the criteria set forth by Kisetsu Saison Finance (India) Private Limited",
    "Referral code usage: Referral codes are for personal and non-commercial use only. They cannot be transferred, sold, or exchanged for cash",
    "Valid referrals: A referral is considered valid only when the referred user successfully completes the specified action (e.g., credit score onboarding, as defined in the program details)",
    "Invalid code entry: Kisetsu Saison Finance (India) Private Limited reserves the right to deem any referral code invalid if it is found to be fraudulent, manipulated, or not associated with a legitimate referrer",
    "Program changes: Kisetsu Saison Finance (India) Private Limited reserves the right to modify, suspend, or terminate the referral program, or any part thereof, at any time and without prior notice",
    "Data privacy: By participating in the referral program, users agree to the collection and use of their data in accordance with Kisetsu Saison Finance (India) Private Limited's Privacy Policy"
  ];

  List<CarouselItemModel> carouselItems = [
    CarouselItemModel(
      title: "They can access free credit score every month",
      subTitle: "",
      image: Res.referralIntroOne,
    ),
    CarouselItemModel(
      title: "They can apply instantly to business loans",
      subTitle: "",
      image: Res.referralIntroTwo,
    ),
    CarouselItemModel(
      title: "They can estimate their EMIs and plan loans better",
      subTitle: "",
      image: Res.referralIntroThree,
    ),
  ];

  late List<TimelineModel> timelineSteps = [
    const TimelineModel(
      title: "Share your unique link",
      icon: Res.referralWorkflowOne,
      subtitle: 'Invite a friend or copy code to share anywhere',
    ),
    const TimelineModel(
      title: "Ask your friend to sign up ",
      icon: Res.referralWorkflowTwo,
      subtitle: 'They can unlock access to exclusive features',
    ),
    TimelineModel(
      title: "Track your referrals",
      icon: Res.referralWorkflowThree,
      subtitle: "See how many people you've helped",
      onInfoTapped: () => onTapTrackYourReferral(),
    ),
  ];

  onTapTrackYourReferral() {
    Get.bottomSheet(const ReferralUpdatesBottomSheet());
  }

  void onTapTAC() {
    referralPageState = ReferralPageState.tnc;
  }

  setAppInviteTemplate() async {
    isButtonLoading = true;
    try {
      AppAnalytics.setAppInviteTemplate(
        referralCode: referralDataModel.referralCode,
        onAppInviteSet: _onAppInviteSet,
      );
    } catch (e) {
      _onErrorWhileCreatingReferralLink(e.toString());
    }
  }

  _onAppInviteSet(AppsflyerSdk appsflyerSdk, dynamic result) {
    try {
      var response = json.decode(result);
      if (response['status'] == "success") {
        _generateReferralLink(appsflyerSdk);
      } else {
        _onErrorWhileCreatingReferralLink("$response");
      }
    } catch (e) {
      _onErrorWhileCreatingReferralLink(e.toString());
    }
  }

  void _generateReferralLink(AppsflyerSdk appsflyerSdk) {
    AppsFlyerInviteLinkParams parameters = AppsFlyerInviteLinkParams(
      customParams: {
        "referral_code": referralDataModel.referralCode,
        "deep_link_value": "user_referral",
      },
    );
    try {
      appsflyerSdk.generateInviteLink(
        parameters,
            (result) {
          _onReferralLinkCreated("${result['payload']['userInviteURL']}");
        },
            (error) {
          _onErrorWhileCreatingReferralLink("$error");
        },
      );
    } catch (e) {
      _onErrorWhileCreatingReferralLink(e.toString());
    }
  }

  void _onReferralLinkCreated(String result) {
    Get.log("referral link - $result");
    isButtonLoading = false;

    // This will open the native share dialog with the link
    final String shareText = "Hey! Join me using my referral link: $result";
    Share.share(shareText, subject: "My Referral Link");
  }

  _onErrorWhileCreatingReferralLink(String error) {
    Get.log("error while creating referral link - $error");
    isButtonLoading = false;
    handleAPIError(
      ApiResponse(
        state: ResponseState.failure,
        apiResponse: "Failed to create referral link",
        exception: error,
      ),
      screenName: "referral",
    );
  }

  void onAfterFirstLayout() async {
    referralPageState = ReferralPageState.loading;
    var arguments = Get.arguments;
    _parseFromHomePage(arguments);
    _parseReferralData(arguments);
    isLeaderBoardNotified = await AppAuthProvider.isReferralLeaderBoardNotified;
  }

  void _parseReferralData(arguments) {
    if (arguments != null && arguments['referralData'] != null) {
      referralDataModel = arguments['referralData'];
      referralPageState = ReferralPageState.success;
    } else {
      _fetchReferralData();
    }
  }

  void _parseFromHomePage(arguments) {
    if (arguments != null) {
      fromHomePage = arguments['fromHomePage'] ?? false;
    }
  }

  void _fetchReferralData() async {
    ReferralDataModel _referralDataModel =
    await ReferralRepository().getUserReferralData();
    switch (_referralDataModel.apiResponse?.state) {
      case ResponseState.success:
        referralPageState = ReferralPageState.success;
        referralDataModel = _referralDataModel;
        break;
      default:
        handleAPIError(_referralDataModel.apiResponse!,
            screenName: REFERRAL_SCREEN);
    }
  }

  onBackPressed() {
    _computeBackNavigation();
  }

  void _computeBackNavigation() {
    switch (referralPageState) {
      case ReferralPageState.loading:
        break;
      case ReferralPageState.success:
        if(fromHomePage){
          Get.offNamed(Routes.HOME_SCREEN, preventDuplicates: true);
        }else{
          Get.back();
        }
        break;
      case ReferralPageState.tnc:
        referralPageState = ReferralPageState.success;
        break;
    }
  }

  void onMyReferralsInfoTapped() {
    Get.bottomSheet(MyReferralInfoBottomSheet(),
        isDismissible: false, isScrollControlled: true);
  }

  onNotifyMePressed() async {
    await AppAuthProvider.setReferralLeaderBoardNotified();
    isLeaderBoardNotified = true;
  }

  void onFAQPressed() async {
    await Get.to(
          () =>
          FAQPage(
            faqModel: FAQUtility().referralFaqs,
          ),
    );
  }

  computeTitle() {
    switch (referralPageState) {
      case ReferralPageState.loading:
      case ReferralPageState.success:
        return "Referral";
      case ReferralPageState.tnc:
        return "Terms and Conditions";
    }
  }

  void onPrivacyPolicyTapped() {
    launchUrlString(
        "https://regulatory.creditsaison.in/privacy-policy-of-privo");
  }

  void onCopyTapped() {
    Clipboard.setData(ClipboardData(text: "Hi, use my code ${referralDataModel.referralCode} to unlock exclusive features on Credit Saison India app"));
  }
}
