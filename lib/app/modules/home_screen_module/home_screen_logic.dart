import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart' as carouselSlider;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/home_page_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/mixin/location_service_mixin.dart';
import 'package:privo/app/mixin/withdrawal_inference_mixin.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/overdue_loan_list.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/modules/ab_user/ab_testing_mixin.dart';
import 'package:privo/app/modules/authentication/sign_in_screen/sign_in_screen_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_report_refresh_bottom_sheet/credit_report_refresh_bottom_sheet.dart';
import 'package:privo/app/modules/customer_feedback_widget/customer_feedback_view.dart';
import 'package:privo/app/modules/fin_sights/finsights_argument.dart';
import 'package:privo/app/modules/fin_sights/finsights_carousel_slider.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_analytics.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_interface.dart';
import 'package:privo/app/modules/home_screen_module/widgets/home_page_error_bottom_sheet.dart';
import 'package:privo/app/modules/home_screen_module/widgets/partner_home_screen/mixin/partner_home_screen_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';
import 'package:privo/app/services/location_service/location_service.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/preprocessor_service/customer_device_details_service.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/modules/fin_sights/finsights_carousel_mixin.dart';
import 'package:privo/app/utils/snack_bar.dart';
import 'package:privo/res.dart';
import 'package:sfmc/sfmc.dart';

import '../../api/response_model.dart';
import '../../models/loans_model.dart';
import '../../utils/web_engage_constant.dart';
import '../credit_report/credit_report_analytics_mixin.dart';
import '../credit_report/widgets/credit_report_refresh_bottom_sheet/credit_report_refresh_bottom_sheet_logic.dart';
import '../feedback/feedback_logic.dart';
import '../fin_sights/finsights_analytics.dart';
import '../non_eligible_finsights/non_eligible_finsights_analytics_mixin.dart';
import '../non_eligible_finsights/non_eligible_finsights_logic.dart';
import '../on_boarding/analytics/e_mandate_analytics_mixin.dart';
import '../on_boarding/mixins/app_form_mixin.dart';
import '../stateless_credit_score/stateless_credit_Score_analytics_mixin.dart';

enum HomeScreenPageState {
  loading,
  userFlow,
  polling,
  fetchingLocation,
  loggingOut,
  iosBeta,
  apiError,
  maintenance,
}

enum HomeScreenCardState {
  loading,
  success,
  error,
  iosBeta,
  accountDeleted,
  clpDisabled,
}

class HomeScreenLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        PartnerHomeScreenMixin,
        WithdrawalInferenceMixin,
        LocationServiceMixin,
        HomeScreenAnalytics,
        EMandateAnalyticsMixin,
        CreditReportAnalyticsMixin,
        AppAnalyticsMixin,
        FinsightsAnalytics,
        AppFormMixin,
        FinSightsCarouselMixin,
        NonEligibleFinSightsAnalyticsMixin,
        StatelessCreditScoreAnalyticsMixin
    implements HomeScreenInterface {
  DateTime preBackPress = DateTime.now();

  static const String OFFER_APPROVED = 'approved';
  static const String OFFER_REJECTED = 'rejected';
  static const String UPL_WAIT_SCREEN_KEY = "UplWaitScreen";

  late final String HOME_SCREEN_ID = 'home_screen';
  late final String UPL_DETAILS_KEY = 'upl_details';
  late final String CARDS_KEY = 'cards';
  late final String MY_ACCOUNT_PAGE_KEY = 'my_account_page';
  late final String BOTTOM_BAR_KEY = 'bottom_bar';
  late final String BOTTOM_STICKY_POLLING_WIDGET_KEY =
      'bottom_sticky_polling_widget_key';
  String HOME_SCREEN_CARD_ID = "HOME_SCREEN_CARD";
  late final String PRIMARY_CARDS_ID = "PRIMARY_CARDS";

  final String NON_CREDITLINE_CONTINUE_BUTTON =
      'non_creditline_continue_button';

  late final String EMI_CALCULATOR = "emi_calculator";
  late final String ALERT_WIDGET = "alert_widget";
  late final String ALERT_WIDGET_INDICATOR = "alert_widget_indicator";

  final FINSIGHTS_PAGE_INDICATOR = "FINSIGHTS_PAGE_INDICATOR";

  bool _nonCreditLineContinueCTALoading = false;

  LoanProductCode loanProductCode = LoanProductCode.clp;
  String HOME_PAGE_TITLE_ID = "HOME_PAGE_TITLE_ID";

  bool get nonCreditLineContinueCTALoading => _nonCreditLineContinueCTALoading;

  set nonCreditLineContinueCTALoading(bool value) {
    _nonCreditLineContinueCTALoading = value;
    update([NON_CREDITLINE_CONTINUE_BUTTON]);
  }

  bool _showPrimaryCards = true;

  bool get showPrimaryCards => _showPrimaryCards;

  set showPrimaryCards(bool value) {
    _showPrimaryCards = value;
    update([PRIMARY_CARDS_ID]);
  }

  String title = "";
  String message = "";

  String _homePageTitle = "";
  final String AB_FINSIGHT_EXP_KEY = "finsights_intro1";

  String get homePageTitle => _homePageTitle;

  set homePageTitle(String value) {
    _homePageTitle = value;
    update([HOME_PAGE_TITLE_ID]);
  }

  bool _isAccountDeleted = true;

  bool get isAccountDeleted => _isAccountDeleted;

  set isAccountDeleted(bool value) {
    _isAccountDeleted = value;
    update([EMI_CALCULATOR]);
  }

  int _updatesCurrentIndex = 0;

  int get updatesCurrentIndex => _updatesCurrentIndex;

  set updatesCurrentIndex(int value) {
    _updatesCurrentIndex = value;
    update([ALERT_WIDGET, ALERT_WIDGET_INDICATOR]);
  }

  bool _exploreMoreVisible = true;

  bool get exploreMoreVisible => _exploreMoreVisible;

  set exploreMoreVisible(bool value) {
    _exploreMoreVisible = value;
    update([HOME_PAGE_TITLE_ID, HOME_SCREEN_ID]);
  }

  bool showHelpIcon = false;

  bool _showAlertWidget = false;

  bool get showAlertWidget => _showAlertWidget;

  set showAlertWidget(bool value) {
    _showAlertWidget = value;
    update([ALERT_WIDGET, ALERT_WIDGET_INDICATOR]);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update(['waiting_button']);
  }

  List<Widget> alertWidgets = [];

  PageController updatesController = PageController(initialPage: 0);
  final finSightsPageController = carouselSlider.CarouselSliderController();

  LoansModel? loansModel;

  late Color creditRatingTextColor;
  late String creditRatingText;

  List<LegacyInfo> legacyData = [
    LegacyInfo(title: "RBI", value: "Regulated NBFC"),
    LegacyInfo(title: "1M+", value: "Happy Customers"),
    LegacyInfo(title: "AAA", value: "CRISIL Rating"),
  ];

  List<String> partnerIcons = [
    Res.cred,
    Res.paisaBazaar,
    Res.lendingKart,
    Res.airtel,
    Res.moneyView
  ];

  GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

  ///this is only used for navigation. Nothing to do with user state
  static const int _GO_TO_WITHDRAWL_STATE = 100;

  HomeScreenPageState _homeScreenState = HomeScreenPageState.loading;

  HomeScreenPageState get homeScreenState => _homeScreenState;

  set homeScreenState(HomeScreenPageState homeScreenState) {
    _homeScreenState = homeScreenState;
    update([HOME_SCREEN_ID]);
  }

  late String HOME_PAGE_SCREEN = "home_page";
  late String YOUR_LOANS_TEXT = "your_loan_text";

  WithdrawalPollingStatus _withdrawalPollingStatus =
      WithdrawalPollingStatus.initiated;

  WithdrawalPollingStatus get withdrawalPollingStatus =>
      _withdrawalPollingStatus;

  set withdrawalPollingStatus(WithdrawalPollingStatus value) {
    _withdrawalPollingStatus = value;
    update([BOTTOM_STICKY_POLLING_WIDGET_KEY]);
  }

  bool settingsDialogShown = false;

  bool? _isPrimaryCardHasLoan;

  bool? get isPrimaryCardHasLoan => _isPrimaryCardHasLoan;

  set isPrimaryCardHasLoan(bool? value) {
    _isPrimaryCardHasLoan = value;
    update([YOUR_LOANS_TEXT]);
  }

  late HomeScreenCardModel homeScreenModel;
  late HomeScreenModel multiLPCCardsModel;

  final PageController primaryPageController =
      PageController(viewportFraction: 1.0, initialPage: 0);

  final PageController secondaryPageController =
      PageController(viewportFraction: 1.0, initialPage: 0);

  var dialogKey = GlobalKey<NavigatorState>();

  String appFormId = '';

  OverDueLoansModel? overDueLoanList;

  LocationService? locationService;

  static DeepLinkService deepLinkService = DeepLinkService();

  bool _bottomNavVisibility = false;

  bool get bottomNavVisibility => _bottomNavVisibility;

  set bottomNavVisibility(bool value) {
    _bottomNavVisibility = value;
    update([BOTTOM_BAR_KEY]);
  }

  @override
  void onInit() async {
    super.onInit();
    await AppAnalytics.logSetUserId();
  }

  void onAfterFirstLayout(BuildContext context) async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: 'Entered Home Screen');
    homeScreenState = HomeScreenPageState.loading;
    fetchHomePageV2(fromHomeScreen: true, context: context);
  }

  @override
  fetchHomePageV2({bool fromHomeScreen = false, BuildContext? context}) async {
    bottomNavVisibility = false;
    withdrawalPollingStatus = WithdrawalPollingStatus.initiated;
    homeScreenState = HomeScreenPageState.loading;
    HomeScreenModel _multiLPCCardsModel =
        await HomePageRepository().getCardsList();
    switch (_multiLPCCardsModel.apiResponse.state) {
      case ResponseState.success:
        _incrementalCustomerDeviceDetailsPush(_multiLPCCardsModel);
        multiLPCCardsModel = _multiLPCCardsModel;
        _initPrimaryCardLogic();
        showHelpIcon = true;
        bottomNavVisibility = true;
        logEnteredHomeScreen(_multiLPCCardsModel.allCards);
        if (_multiLPCCardsModel.financialTools.finSights != null) {
          logFinsightsHomeScreenLoaded();
          /// removal of finSights story mode
          /*   if (await AppAuthProvider.showFinSightsStoryMode) {
            logStoryModeLoadedHome();
            if (context != null && context.mounted) {
              showDialog(
                context: context,
                builder: (context) => FinSightsCarouselSlider(
                  finSightsModel: _multiLPCCardsModel.financialTools.finSights!,
                ),
              );
            }
            AppAuthProvider.setShowFinSightsStoryMode();
          }*/
        }
        homeScreenState = HomeScreenPageState.userFlow;
        if (_multiLPCCardsModel.financialTools.creditScore != null) {
          logCreditScoreD2CLoadedHome(
              _multiLPCCardsModel.financialTools.creditScore!);
          logCreditScoreRefreshAvailable(
              isHome: true,
              isRefreshAvailable: _multiLPCCardsModel
                  .financialTools.creditScore!.refreshAvailable);
          if (_multiLPCCardsModel
                  .financialTools.creditScore!.refreshAvailable &&
              !(await AppAuthProvider.isCreditScoreHomeRefreshShown)) {
            var result = await Get.bottomSheet(
              CreditReportRefreshBottomSheet(
                creditScoreModel:
                    _multiLPCCardsModel.financialTools.creditScore!,
                isReferralEnabled: _multiLPCCardsModel.referralData != null &&
                    _multiLPCCardsModel.referralData!.enableReferral,
              ),
            );
            await AppAuthProvider.setCreditScoreHomeRefreshShown();
            Get.delete<CreditReportRefreshBottomSheetLogic>();
            if (result != null && result) {
              fetchHomePageV2();
            }
          }
        }
        break;
      case ResponseState.notAuthorized:
        _logHomePageError(_multiLPCCardsModel);
        _logOut();
        break;
      default:
        _logHomePageError(_multiLPCCardsModel);
        Get.bottomSheet(
          HomePageErrorBottomSheetWidget(),
          isDismissible: false,
        );
    }
  }

  void _incrementalCustomerDeviceDetailsPush(
      HomeScreenModel multiLPCCardsModel) {
    if (multiLPCCardsModel.userData != null &&
        multiLPCCardsModel.userData!.pushCustomerDeviceDetails) {
      locationService = LocationService(
        onLocationFetchSuccessful: () async {
          String locationData = await AppAuthProvider.getUserLocationData;
          CustomerDeviceDetailsService().postCustomerDeviceDetails(
            isIncremental: true,
            locationData: locationData,
          );
        },
        onLocationStatus: (locationStatus) {
          switch (locationStatus) {
            case LocationStatusType.noPermission:
            case LocationStatusType.locationDisabled:
            case LocationStatusType.locationNotFound:
            case LocationStatusType.retry:
            case LocationStatusType.technicalError:
              CustomerDeviceDetailsService().postCustomerDeviceDetails(
                isIncremental: true,
              );
              break;
            case LocationStatusType.permissionAndLocationEnabled:
              break;
          }
        },
      );
      locationService?.fetchLocation();
    }
  }

  void _logHomePageError(HomeScreenModel _multiLPCCardsModel) {
    _trackHomePageFailure();
    logError(
      url: _multiLPCCardsModel.apiResponse.url,
      requestBody: _multiLPCCardsModel.apiResponse.requestBody,
      exception: _multiLPCCardsModel.apiResponse.exception,
      responseBody: _multiLPCCardsModel.apiResponse.apiResponse,
      statusCode: "${_multiLPCCardsModel.apiResponse.statusCode}",
    );
  }

  void _initPrimaryCardLogic() {
    for (var element in multiLPCCardsModel.allCards) {
      Get.put(PrimaryHomeScreenCardLogic(), tag: element.appFormId)
        ..didLoad = false
        ..homeScreenInterface = this;
    }

    bool isGetStartedInKnowMoreEnabled =
        _computeGetStartedCTAInKnowMoreEnabled();

    for (var element in multiLPCCardsModel.exploreMore) {
      Get.put(PrimaryHomeScreenCardLogic(), tag: element.appFormId)
        ..didLoad = false
        ..isGetStartedInKnowMoreEnabled = isGetStartedInKnowMoreEnabled
        ..homeScreenInterface = this;
    }

    for (var element in multiLPCCardsModel.upgradeCards) {
      Get.put(PrimaryHomeScreenCardLogic(), tag: element.appFormId)
        ..didLoad = false
        ..homeScreenInterface = this;
    }
  }

  bool _computeGetStartedCTAInKnowMoreEnabled() {
    // if any of the appforms under multiLPCCardsModel.allCards is non empty(That means user has an active loan)
    // then return false(dont show get started CTA in knowmore screen)
    return !multiLPCCardsModel.allCards
        .any((element) => element.appFormId.isNotEmpty);
  }

  void _trackHomePageFailure() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.homepageApiFailureCardLoaded,
    );
  }

  void _logOut() {
    Fluttertoast.showToast(msg: "Session Expired");
    AppAuthProvider.logout();
  }

  onClickChangePassword() async {
    Get.toNamed(Routes.CHANGE_PASSWORD);
  }

  goToLowAndGrowModule() async {
    await Get.toNamed(Routes.LOW_AND_GROW);
    fetchHomePageV2();
  }

  goToKnowledgeBase() {
    Get.toNamed(Routes.KNOWLEDGE_BASE);
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.homepageKnowledgeBaseClicked,
    );
  }

  goToCreditReport() async {
    if (multiLPCCardsModel
        .financialTools.creditScore!.applicationDetails.appFormId.isEmpty) {
      logCreditScoreD2CWhitelistHomeClicked();
    }
    logCreditScoreD2CClickedHome(
        multiLPCCardsModel.financialTools.creditScore!);
    await Get.toNamed(
      Routes.CREDIT_REPORT,
      arguments: {
        'creditScoreModel': multiLPCCardsModel.financialTools.creditScore,
        'isReferralEnabled': multiLPCCardsModel.referralData != null &&
            multiLPCCardsModel.referralData!.enableReferral
      },
    );
    fetchHomePageV2();
  }

  goToServicingScreen(int tabIndex) async {
    await Get.toNamed(
      Routes.SERVICING_SCREEN,
      arguments: {'tab_index': tabIndex},
    );
    if (primaryPageController.hasClients) {
      primaryPageController.jumpToPage(0);
    }
    if (secondaryPageController.hasClients) {
      secondaryPageController.jumpToPage(0);
    }
    fetchHomePageV2();
  }

  void showFeedBackScreen(bool isFeedBackEmpty) {
    if (isFeedBackEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await Future.delayed(const Duration(milliseconds: 500));
        await showModalBottomSheet(
            context: Get.context!,
            isDismissible: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) {
              return CustomerFeedbackView(
                onSuccess: () {
                  // _getHomePage();
                },
              );
            });
      });
    }
  }

  Future<bool> onBackPressed() async {
    final timegap = DateTime.now().difference(preBackPress);
    final cantExit = timegap >= const Duration(seconds: 2);
    preBackPress = DateTime.now();
    if (cantExit) {
      AppSnackBar.successBar(title: "Press Again", message: "to Exit");
      return false; // false will do nothing when back press
    } else {
      return true; // true will exit the app
    }
  }

  onDrawerPressed() {
    homePageScaffoldKey.currentState!.openDrawer();
    //ToDo: ask why this is going
    // if (isWithdrawInferencePolling) {
    //   processingRequestToast();
    // } else {
    //   homePageScaffoldKey.currentState!.openDrawer();
    // }
  }

  void processingRequestToast() {
    Fluttertoast.showToast(msg: "Processing request.. Please wait");
  }

  checkIfLimitReached(double utilizedLimitPercent) {
    if (utilizedLimitPercent == 100.00) {
      return false;

      ///Disables button
    } else {
      return true;

      /// Enables button
    }
  }

  void partnerFlowGetStarted() {
    partnerFlowGetStartedEvent();
    // computeUserStateAndNavigate();
  }

  String computeLowAndGrowOfferExpiryDays(String? expiryDate) {
    String lowAndGrowExpiryDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(expiryDate!));
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    int difference = DateTime.parse(lowAndGrowExpiryDate)
        .difference(DateTime.parse(currentDate))
        .inDays;

    return difference.toString();
  }

  bool enableNonCreditLineCTA() {
    return loanProductCode != LoanProductCode.clp &&
        homeScreenModel.appState != 18 &&
        homeScreenModel.buttonText.isNotEmpty;
  }

  void onShareFeedbackClicked(
      FeedbackType feedbackType, LpcCard lpcCard) async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.feedbackPopped);
    LPCService.instance.activeCard = lpcCard;

    await Get.toNamed(
      Routes.FEEDBACK,
      arguments: {
        'feedback_type': feedbackType,
      },
    );
    fetchHomePageV2();
  }

  @override
  toggleLabel(bool isPrimaryCardHasLoan) {
    this.isPrimaryCardHasLoan = isPrimaryCardHasLoan;
  }

  @override
  onAccountDeleted(bool value) {
    isAccountDeleted = value;
  }

  @override
  showHomePageAlert(List<Widget> alertWidgets) {
    this.alertWidgets = alertWidgets;
    showAlertWidget = true;
    update([ALERT_WIDGET, ALERT_WIDGET_INDICATOR, HOME_SCREEN_ID]);
  }

  void onUpdatePageChanged(int value) {
    updatesCurrentIndex = value;
  }

  @override
  toggleHomePageTitle(String value) {
    if (homePageTitle.isEmpty) {
      homePageTitle = value;
    }
  }

  @override
  toggleExploreMore(bool value) {
    exploreMoreVisible = value;
  }

  @override
  createLowAndGrowOfferCard(LpcCard lpcCard, EnhancedOffer enhancedOffer) {
    Map<String, dynamic> lowAndGrowCardData = {
      "customer_cif": "",
      "loan_product_code": "CLP",
      "loan_product_name": "Special Upgrade",
      "appform_created_at":
          DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
      "app_form_id": lpcCard.appFormId,
      "applicant_type": "LinkedIndividual",
      "applicant_party_type": "",
      "applicant_id": "0",
      "appform_status": "",
      "appform_status_numeric": "",
      "visible": true,
      "priority": "0",
      "loan_type": "LOW_AND_GROW"
    };

    multiLPCCardsModel.upgradeCards.add(
      LpcCard.decodeResponse(lowAndGrowCardData),
    );

    for (var element in multiLPCCardsModel.upgradeCards) {
      Get.put(PrimaryHomeScreenCardLogic(),
          tag: "${element.appFormId}_low_grow")
        ..didLoad = false
        ..homeScreenInterface = this;
    }

    homeScreenState = HomeScreenPageState.userFlow;
  }

  onTapFinSights(FinSightsModel finsightsModel) async {
    try {
      if (finsightsModel.applicationDetails.appFormId.isNotEmpty) {
        LPCService.instance.activeCard = LPCService.instance.lpcCards
            .singleWhere((element) =>
                element.appFormId ==
                finsightsModel.applicationDetails.appFormId);
      }
      String userType = "first_time";
      if (finsightsModel.applicationDetails.dataPageViewed) {
        userType = "recurring_user";
      }
      logFinsightsIconClicked(userType);
      await FinSightsNavigationService().navigate(
        routeArguments: FinsightsArgument(
          finSightsModel: finsightsModel,
        ),
      );
      fetchHomePageV2();
    } catch (e) {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: e.toString(),
        ),
        screenName: HOME_PAGE_SCREEN,
      );
    }
  }

/*  late final List<FinSightsPopUpModel> finSightsScrollList = [
    FinSightsPopUpModel(
        img: Res.finsightsBlue,
        title: 'Introducing FinSights',
        subTitle:
            'Track, analyse, and manage all your accounts in one secure place'),
    FinSightsPopUpModel(
        img: Res.finsights3Steps,
        title: 'A Simple 3-Step Process',
        subTitle:
            "Connect, authorise, and manage your financial accounts with transparency and security"),
    FinSightsPopUpModel(
        img: Res.finsightsFinancial,
        title: 'Unlock Smart Financial Benefits',
        subTitle:
            "Gain holistic insights, enhance credit access, and enjoy quicker loan approval, all in one place"),
  ];*/

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update([FINSIGHTS_PAGE_INDICATOR]);
  }

  void onPageSwiped(int index) {
    Get.log("onIndexChanged -> index = $index");
    currentIndex = index;
    update();
  }

  @override
  Future<void> redirectToCreditReport() async {
    if (multiLPCCardsModel.financialTools.creditScore != null) {
      goToCreditReport();
    }
  }

  @override
  navigateToFinSights() {
    if (multiLPCCardsModel.financialTools.finSights != null) {
      onTapFinSights(multiLPCCardsModel.financialTools.finSights!);
    }
  }

  showNonEligibleFinSights() {
    Get.toNamed(Routes.NON_ELIGIBLE_FINSIGHTS_SCREEN,
        arguments: {"experiment_name": AB_FINSIGHT_EXP_KEY});
  }

  void homeFinsightsWaitListViewClicked() {
    logfinsightsHomeScreenClickedNEFAldJ();
    Get.toNamed(Routes.FINSIGHT_WAIT_LIST_SCREEN,
        arguments: {"waitlist": FinSightWaitListType.waitListView});
  }

  Future<void> onWaitListButtonTap(String buttonTitle) async {
    isLoading = true;
    homeScreenState = HomeScreenPageState.loading;
    await fetchHomePageV2(fromHomeScreen: true);
    Get.back();
    Get.back();
    isLoading = false;
    logfinsightsHomeScreenLoadedNEFAldJ();
  }

  Future<bool> get isUserOnFinsightsWaitList async =>
      await AppAuthProvider.finsightsWaitList;

  Future<void> onNonFinSightHomeClick() async {
    logfinsightsHomeScreenClickedNEFNE();
    final isOnWaitList = await isUserOnFinsightsWaitList;

    if (!isOnWaitList) {
      homeFinsightsWaitListViewClicked();
    } else {
      showNonEligibleFinSights();
    }
  }

  @override
  togglePrimaryCard(bool value) {
    showPrimaryCards = value;
  }

  void creditscoreCardLoadedEvent() {
    logCreditScoreD2CWhitelistHomeLoaded();
  }

  void onTapReferralCard() {
    Get.toNamed(Routes.REFERRAL,
        arguments: {'referralData': multiLPCCardsModel.referralData});
  }
}
