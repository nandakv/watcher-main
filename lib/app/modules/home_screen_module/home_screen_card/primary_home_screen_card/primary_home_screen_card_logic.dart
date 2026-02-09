import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/app_parameter_repository.dart';
import 'package:privo/app/data/repository/home_page_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/mixin/location_service_mixin.dart';
import 'package:privo/app/mixin/withdrawal_inference_mixin.dart';
import 'package:privo/app/models/app_parameter_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/e_mandate_polling_model.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/models/withdrawal_status_model.dart';
import 'package:privo/app/modules/app_rating/app_rating_view.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_analytics.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_interface.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/home_screen_module/model/withdrawal_blocking_details.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/home_page_alert_widget_logic.dart';
import 'package:privo/app/modules/home_screen_module/widgets/withdrawal_blocking_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/withdrawal_paused_bottom_sheet.dart';
import 'package:privo/app/modules/know_more_and_get_started/know_more_get_started_logic.dart';
import 'package:privo/app/modules/know_more_and_get_started/model/lead_details.dart';
import 'package:privo/app/modules/on_boarding/analytics/e_mandate_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/modules/topup_know_more/topup_know_more_arguments.dart';
import 'package:privo/app/modules/withdrawal_screen/withdrawal_screen_maps.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/deep_link_service/deep_link_service.dart';
import 'package:privo/app/services/deep_link_service/deep_link_state.dart';
import 'package:privo/app/services/location_service/location_service.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/services/preprocessor_service/preprocessor_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:sfmc/sfmc.dart';

import '../../../../services/preprocessor_service/customer_device_details_service.dart';

class PrimaryHomeScreenCardLogic extends GetxController
    with
        HomeScreenAnalytics,
        ErrorLoggerMixin,
        LocationServiceMixin,
        ApiErrorMixin,
        WithdrawalInferenceMixin,
        EMandateAnalyticsMixin {
  HomeScreenCardState _homeScreenCardState = HomeScreenCardState.loading;

  HomeScreenCardState get homeScreenCardState => _homeScreenCardState;

  bool initiallyExpanded = false;

  bool expandable = true;

  set homeScreenCardState(HomeScreenCardState value) {
    _homeScreenCardState = value;
    update();
  }

  late HomeScreenCardModel homeScreenModel;

  int currentUserState = 0;

  String ACCOUNT_DELETED = "accountdeleted";

  String cardBadgeId = "CARD_BADGE_ID";

  late HomeScreenInterface homeScreenInterface;

  late String HOME_PAGE_SCREEN = "home_page";

  String errorTitle = '';

  bool showHelpIcon = false;

  LocationService? locationService;

  late LoanProductCode loanProductCode;

  LeadDetails? leadDetails;

  String title = "";
  String message = "";

  CardBadgeType _cardBadgeType = CardBadgeType.none;

  CardBadgeType get cardBadgeType => _cardBadgeType;

  set cardBadgeType(CardBadgeType value) {
    _cardBadgeType = value;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      update([cardBadgeId]);
    });
  }

  late LpcCard lpcCard;

  bool didLoad = false;

  double disbursedAmount = 0;

  // var homeScreenLogic = Get.find<HomeScreenLogic>();

  bool isPrimaryCardHasLoan = false;

  String EXPANSION_CARD_ID = "EXPANSION_CARD_ID";

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  set isExpanded(bool value) {
    _isExpanded = value;
    update([EXPANSION_CARD_ID]);
  }

  bool isGetStartedInKnowMoreEnabled = true;

  GlobalKey<ScaffoldState> homePageScaffoldKey = GlobalKey<ScaffoldState>();

  final WITHDRAW_BUTTON_ID = 'withdraw_button_id';
  bool isWithdrawInferencePolling = false;
  bool _isWithdrawButtonLoading = false;

  bool get isWithdrawButtonLoading => _isWithdrawButtonLoading;

  set isWithdrawButtonLoading(bool value) {
    _isWithdrawButtonLoading = value;
    update([WITHDRAW_BUTTON_ID]);
  }

  EMandatePollingStatus _eMandatePollingStatus = EMandatePollingStatus.pending;

  EMandatePollingStatus get eMandatePollingStatus => _eMandatePollingStatus;

  set eMandatePollingStatus(EMandatePollingStatus value) {
    _eMandatePollingStatus = value;
    update([BOTTOM_STICKY_POLLING_WIDGET_KEY]);
  }

  String selectedEMandateType = "";

  final String BOTTOM_STICKY_POLLING_WIDGET_KEY =
      'bottom_sticky_polling_widget_key';

  WithdrawalPollingStatus _withdrawalPollingStatus =
      WithdrawalPollingStatus.initiated;

  WithdrawalPollingStatus get withdrawalPollingStatus =>
      _withdrawalPollingStatus;

  set withdrawalPollingStatus(WithdrawalPollingStatus value) {
    _withdrawalPollingStatus = value;
    update([BOTTOM_STICKY_POLLING_WIDGET_KEY]);
  }

  onAfterFirstLayout({
    required LpcCard lpcCard,
    required bool initiallyExpanded,
    required bool expandable,
    required BuildContext context,
  }) async {
    this.lpcCard = lpcCard;
    this.initiallyExpanded = initiallyExpanded;
    this.expandable = expandable;

    logOfferZoneLoaded(lpcCard.lpcCardType);

    if (lpcCard.isAccountDeleted) {
      homeScreenCardState = HomeScreenCardState.accountDeleted;
    } else {
      await _fetchHomePage(context: context);
    }
    homeScreenInterface.onAccountDeleted(lpcCard.isAccountDeleted);
    // else {
    //   homeScreenInterface.toggleBenefits(homeScreenModel.showBenefits);
    //   homeScreenInterface.toggleLabel(isPrimaryCardHasLoan);
    //   homeScreenInterface.toggleCreditReport(
    //     homeScreenModel.showCreditReport,
    //     homeScreenModel.creditReportUpdatedDate,
    //     lpcCard,
    //   );
    // }
  }

  Future<void> _fetchHomePage({BuildContext? context}) async {
    homeScreenInterface.onAccountDeleted(lpcCard.isAccountDeleted);
    if (!didLoad) {
      await fetchHomePageCardFromAppForm(context: context);
    }
  }

  onDrawerPressed() {
    homePageScaffoldKey.currentState!.openDrawer();
  }

  goToServicingScreen(int tabIndex) async {
    await Get.toNamed(
      Routes.SERVICING_SCREEN,
      arguments: {
        "tab_index": tabIndex,
      },
    );
    await homeScreenInterface.fetchHomePageV2();
  }

  Future<void> fetchHomePageCardFromAppForm({
    bool fromHomeScreen = true,
    BuildContext? context,
  }) async {
    homeScreenCardState = HomeScreenCardState.loading;
    HomeScreenCardModel model =
        await HomePageRepository().fetchV2HomePage(lpcCard);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        loanProductCode = model.loanProductCode;
        showHelpIcon = loanProductCode == LoanProductCode.clp;
        title = model.title;
        message = model.message.isNotEmpty ? model.message : message;
        await AppAuthProvider.setAppFormID(model.appFormId);
        currentUserState = model.appState;
        logEventsOnCardLoaded(model.screen);
        _computeStatesForPreprocessorDataPush(model.appState);
        homeScreenModel = model;

        if (lpcCard.lpcCardType == LPCCardType.lowngrow) {
          _prepareLowGrowCard();
          return;
        }

        _computeHomePageTitle();
        if (model.homeScreenCardState == HomeScreenCardState.clpDisabled &&
            LPCService.instance.lpcCards.length == 1) {
          homeScreenInterface.togglePrimaryCard(false);
        }

        isPrimaryCardHasLoan = homeScreenModel.appState == DISBURSAL_PROGRESS;

        if (isPrimaryCardHasLoan) {
          if (context != null && context.mounted) {
            await promptAppRating(context);
          }
          HomePageWithdrawalAlertLogic logic = Get.put(
            HomePageWithdrawalAlertLogic(),
            tag: lpcCard.appFormId,
          );
          logic.homeScreenInterface = homeScreenInterface;
          // _initBranchLedDisbursalLogic();
          _computeLowAndGrow();
        }

        await _computeAppStates(model);
        homeScreenInterface.toggleLabel(isPrimaryCardHasLoan);
        if (lpcCard.lpcCardType == LPCCardType.loan) {
          homeScreenInterface.showHomePageAlert(homeScreenModel.alertWidgets);
        }
        if (fromHomeScreen) navigateOnDeepLink();
        didLoad = true;
        homeScreenCardState = homeScreenModel.homeScreenCardState;
        break;
      // case ResponseState.notAuthorized:
      //   _logHomePageError(model);
      //   _logOut();
      //   break;
      default:
        showHelpIcon = (await AppAuthProvider.getLpc) == 'CLP';
        _logHomePageError(model);
        message =
            "Encountering a glitch while loading details.\nRefresh to retry";
        homeScreenCardState = HomeScreenCardState.error;
        break;
    }
  }

  promptAppRating(BuildContext context) async {
    if (await AppAuthProvider.appRatingPrompted) {
      if (context.mounted) {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: AppRatingView(),
            );
          },
          enableDrag: false,
          backgroundColor: Colors.transparent,
        );
      }
      AppAuthProvider.setAppRatingPrompted();
    }
  }

  void _computeHomePageTitle() {
    if (lpcCard.lpcCardType == LPCCardType.loan) {
      switch (homeScreenModel.appState) {
        case PERSONAL_DETAILS:
          homeScreenInterface.toggleHomePageTitle("Our Offerings");
          break;
        case DISBURSAL_PROGRESS:
          homeScreenInterface.toggleHomePageTitle("Your Loan Dashboard");
          break;
        default:
          homeScreenInterface.toggleHomePageTitle("Complete Your Application");
      }
    }
  }

  void _prepareLowGrowCard() {
    WithdrawalDetailsHomeScreenType lowGrowModel =
        homeScreenModel.homeScreenType as WithdrawalDetailsHomeScreenType;

    homeScreenModel.info =
        "Claim your exclusive reward of up to\n<h1>${AppFunctions.getIOFOAmount(lowGrowModel.enhancedOffer?.totalLimit ?? 0)}</h1>\nfor timely EMI payments!";
    homeScreenModel.buttonText = "Get Now";
    didLoad = true;
    homeScreenCardState = HomeScreenCardState.success;
  }

  Future<void> _computeAppStates(HomeScreenCardModel model) async {
    switch (homeScreenModel.appState) {
      case PERSONAL_DETAILS:
        _initLocation();
        break;
      default:
        break;
    }
  }

  void _logHomePageError(HomeScreenCardModel model) {
    logError(
      url: model.apiResponse.url,
      requestBody: model.apiResponse.requestBody,
      exception: model.apiResponse.exception,
      responseBody: model.apiResponse.apiResponse,
      statusCode: "${model.apiResponse.statusCode}",
    );
    _trackHomePageFailure();
  }

  void _logOut() {
    Fluttertoast.showToast(msg: "Session Expired");
    AppAuthProvider.logout();
  }

  void _trackHomePageFailure() {
    homeScreenCardState = HomeScreenCardState.error;

    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.homepageApiFailureCardLoaded,
    );
  }

  void _computeStatesForPreprocessorDataPush(int appState) {
    List<String> preprocessorCheckStates = [
      "$WORK_DETAILS",
      "$BUREAU_POLLING",
      "$OFFER_POLLING"
    ];
    if (preprocessorCheckStates.contains("$appState")) {
      PreprocessorService(triggerCustomerDeviceDetails: true)
          .checkPreprocessorData();
    }
  }

  void navigateOnDeepLink() async {
    if (checkIfDeepLinkIsValid(DeepLinkService.deepLinkValue)) {
      await _computeDeepLinkNavigation();
    }
  }

  _computeDeepLinkNavigation() async {
    switch (deepLinkMaps[DeepLinkService.deepLinkValue]) {
      case Routes.CREDIT_REPORT:
        await homeScreenInterface.redirectToCreditReport();
        DeepLinkService.clearDeepLink();
        break;
      case Routes.FIN_SIGHTS:
        await homeScreenInterface.navigateToFinSights();
        DeepLinkService.clearDeepLink();
        break;
      case Routes.TOPUP_KNOW_MORE:
        _onTopUpDeepLink();
        break;
      case SERVICING_SCREENS:
        await goToServicingScreen(
            LPCService.instance.lpcCards.indexOf(lpcCard));
        DeepLinkService.clearDeepLink();
        break;
      case Routes.KNOW_MORE_GET_STARTED:

        ///Only for sbd know more
        _onSbdKnowMoreDeepLinkReceived();
        break;
      case Routes.BLOG_DETAILS:
        if (DeepLinkService.blogId.isNotEmpty) {
          Get.toNamed(Routes.KNOWLEDGE_BASE,
              arguments: {'blog_id': DeepLinkService.blogId});
        }
        DeepLinkService.clearDeepLink();
        break;
      default:
        //Anything other than the above are onboarding deep links
        _onOnboardingDeepLinkReceived();
        DeepLinkService.clearDeepLink();
        break;
    }
  }

  void _onSbdKnowMoreDeepLinkReceived() {
    ///Only for sbd know more
    if (homeScreenModel.appState == PERSONAL_DETAILS) {
      goToKnowMore(KnowMoreGetStartedState.knowMore, LoanProductCode.sbd);
    }
    DeepLinkService.clearDeepLink();
  }

  _onTopUpDeepLink() {
    if (lpcCard.lpcCardType == LPCCardType.topUp) {
      topUpCTAPressed(
          isKnowMore: homeScreenModel.homeScreenType is TopUpKnowMoreCardType);
      DeepLinkService.clearDeepLink();
    }
  }

  void _onOnboardingDeepLinkReceived() {
    if (homeScreenModel.appState ==
        deepLinkMaps[DeepLinkService.deepLinkValue]) {
      currentUserState = deepLinkMaps[DeepLinkService.deepLinkValue]!;
      goToOnBoardingPage();
    }
  }

  bool checkIfDeepLinkIsValid(String deepLinkValue) =>
      deepLinkValue.isNotEmpty && deepLinkMaps[deepLinkValue] != null;

  goToOnBoardingPage({
    bool rejected = false,
    String rejectionMessage = "",
    bool isSurrogate = false,
    bool isFeedBackSubmitted = false,
  }) async {
    try {
      await SFMCSdk.logSdkState();
    } catch (e) {
      Get.log("Failed while logging sfmc sdk state - $e");
    }

    LPCService.instance.activeCard = lpcCard;
    // if (Platform.isAndroid ||
    //     (Platform.isIOS &&
    //         LPCService.instance.activeCard?.lpcCardType == LPCCardType.topUp)) {
    AppAnalytics.logLevelStart();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: "Routing to OnBoarding Screen from Home Screen",
        attributeName: {
          "app_state": currentUserState,
        });
    await Get.toNamed(
      Routes.ON_BOARDING_SCREEN,
      arguments: {
        'appFormId': homeScreenModel.appFormId,
        'state': currentUserState,
        'isRejected': rejected,
        'is_surrogate': isSurrogate,
        'errorTitle': errorTitle,
        'errorBody': rejectionMessage,
        'isFeedBackSubmitted': isFeedBackSubmitted,
        'loanProductCodeType': loanProductCode,
        'sequenceEngineModel': homeScreenModel.sequenceEngineModel,
        'isPartnerFlow': homeScreenModel.isPartnerFlow,
        'leadDetails': leadDetails
      },
    );
    locationService?.disposeLocationService();

    homeScreenInterface.fetchHomePageV2();
    // }
  }

  bool _computeGetStartedCTAInKnowMoreEnabled() {
    return (Platform.isIOS ||
            homeScreenCardState == HomeScreenCardState.accountDeleted)
        ? false
        : isGetStartedInKnowMoreEnabled;
  }

  goToKnowMore(KnowMoreGetStartedState knowMoreGetStartedState,
      LoanProductCode lpc) async {
    var result = await Get.toNamed(Routes.KNOW_MORE_GET_STARTED, arguments: {
      'state': knowMoreGetStartedState,
      'lpc': lpc,
      'getStartedCTAEnabled': _computeGetStartedCTAInKnowMoreEnabled(),
    });
    loanProductCode = lpc;
    if (result != null && (result is LeadDetails)) {
      leadDetails = result;
      _startFetchingLocation();
    } else {
      homeScreenInterface.fetchHomePageV2();
    }
  }

  void computeUserStateAndNavigate(LoanProductCode loanProductCode) async {
    _logUpgradeOfferEvent();
    switch (currentUserState) {
      case PERSONAL_DETAILS:
        homeScreenCardState = HomeScreenCardState.loading;
        if (homeScreenModel.isPartnerFlow) {
          _startFetchingLocation();
        } else {
          goToKnowMore(KnowMoreGetStartedState.getStarted, loanProductCode);
        }
        break;
      case EMANDATE_POLLING:
        logAutopayMaximised(
          eMandatePollingStatus,
          selectedEMandateType,
        );
        goToOnBoardingPage();
        break;
      default:
        goToOnBoardingPage();
    }
  }

  _onNonCreditLineLocationSuccess() async {
    await CustomerDeviceDetailsService().postCustomerDeviceDetails();
    goToOnBoardingPage();
  }

  _onNonCreditLineLocationStatus(LocationStatusType status) async {
    Get.log("LocationStatusType - $status");
    if (status != LocationStatusType.permissionAndLocationEnabled) {
      await CustomerDeviceDetailsService().postCustomerDeviceDetails();
    }
    goToOnBoardingPage();
  }

  void _logUpgradeOfferEvent() {
    if (homeScreenModel.buttonText == "Get Offer" ||
        homeScreenModel.buttonText == "Upgrade your offer") {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.aaCTAUpgradeClicked,
          attributeName: {"upgrade_flow_aa_perfios": "true"});
    }
  }

  _startFetchingLocation() async {
    await _initLocation();
    locationService?.fetchLocation();
  }

  _initLocation() async {
    if (locationService == null) {
      AppParameterModel appParameterModel =
          await AppParameterRepository().getAppParameters();
      switch (appParameterModel.apiResponse.state) {
        case ResponseState.success:
          _onAppParamFetchSuccess(appParameterModel);
          break;
        default:
          handleAPIError(appParameterModel.apiResponse,
              screenName: HOME_PAGE_SCREEN, retry: _initLocation);
      }
    }
  }

  void _onAppParamFetchSuccess(AppParameterModel appParameterModel) {
    int locationRetryTime = appParameterModel.locationRetryTimer;
    int locationRetryCount = appParameterModel.locationRetryCount;
    locationService = LocationService(
        onLocationFetchSuccessful: _onLocationFetchSuccessful,
        defaultLocationTimer: locationRetryTime,
        locationRetryCount: locationRetryCount,
        onLocationStatus: _onLocationStatus);
  }

  _onLocationStatus(
    LocationStatusType statusType,
  ) {
    switch (statusType) {
      case LocationStatusType.locationNotFound:
        locationService?.disposeLocationService();
        locationService!.fetchLocation();
        break;
      case LocationStatusType.locationDisabled:
        goToOnBoardingPage();
        break;

      case LocationStatusType.retry:
        locationService?.disposeLocationService();
        locationService!.fetchLocation();
        break;

      case LocationStatusType.noPermission:
        homeScreenCardState = HomeScreenCardState.loading;
        onPermissionNotGranted();
        break;
      case LocationStatusType.permissionAndLocationEnabled:
        homeScreenCardState = HomeScreenCardState.success;
        goToOnBoardingPage();
        break;
      default:
    }
  }

  void _onLocationDisabled() {
    homeScreenCardState = HomeScreenCardState.success;
    if (!Get.isSnackbarOpen) {
      Get.back();
      Get.snackbar("Please enable location services from quick settings",
          "to help us serve you better",
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.white,
          colorText: Colors.black);
    }
  }

  _onLocationFetchSuccessful() async {
    String data = await AppAuthProvider.getUserLocationData;
    Get.log("Fetched location ${data}");
  }

  onCreditLineExpiryAlert(
    WithdrawalDetailsHomeScreenType? withdrawalDetailsHomeScreenType,
    LpcCard lpcCard,
  ) {
    if (withdrawalDetailsHomeScreenType != null) {
      onWithdrawButtonClicked(withdrawalDetailsHomeScreenType, lpcCard);
    } else {
      computeUserStateAndNavigate(
          AppFunctions().computeLoanProductCode(lpcCard.loanProductCode));
    }
  }

  void onWithdrawButtonClicked(
      WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel,
      LpcCard lpcCard,
      {bool isCLP = false}) async {
    if (isCLP) {
      showWithdrawalPausedBottomSheet();
    } else {
      checkWithdrawalStatus(withdrawalDetailsHomePageModel, lpcCard);
    }
  }

  void checkWithdrawalStatus(
      WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel,
      LpcCard lpcCard) async {
    LPCService.instance.activeCard = lpcCard;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.homepageMainCTAClicked,
    );
    if (withdrawalDetailsHomePageModel.isWithdrawalPolling) {
      await Get.toNamed(
        Routes.WITHDRAWAL_SCREEN,
        arguments: {
          'withdrawal_state': WithdrawalScreen.polling,
        },
      );
      await fetchHomePageCardFromAppForm();
      return;
    }

    if (withdrawalDetailsHomePageModel.isWithdrawFailed) {
      logWithdrawalRetryClicked();
    }
    isWithdrawInferencePolling = true;
    isWithdrawButtonLoading = true;
    startWithdrawalInferencePolling(
      onApiError: (ApiResponse apiResponse) {
        _onWithdrawalInferenceApiError(
          apiResponse,
          withdrawalDetailsHomePageModel,
          lpcCard,
        );
      },
      onFailure: _onWithdrawalInferenceFailure,
      onSuccess: (CheckAppFormModel checkAppFormModel) {
        _onWithdrawalInferenceSuccess(withdrawalDetailsHomePageModel);
      },
    );
  }

  void showWithdrawalPausedBottomSheet() {
    Get.bottomSheet(const WithdrawalPausedBottomSheet());
  }

  void _onWithdrawalInferenceApiError(
    ApiResponse apiResponse,
    WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel,
    LpcCard lpcCard,
  ) {
    isWithdrawInferencePolling = false;
    isWithdrawButtonLoading = false;
    handleAPIError(
      apiResponse,
      screenName: HOME_PAGE_SCREEN,
      retry: () => onWithdrawButtonClicked(
        withdrawalDetailsHomePageModel,
        lpcCard,
      ),
    );
  }

  void _onWithdrawalInferenceSuccess(
      WithdrawalDetailsHomeScreenType withdrawalDetailsHomePageModel) {
    isWithdrawInferencePolling = false;
    isWithdrawButtonLoading = false;
    goToWithdrawalScreen(withdrawalDetailsHomePageModel);
  }

  goToWithdrawalScreen(WithdrawalDetailsHomeScreenType model) async {
    await Get.toNamed(Routes.WITHDRAWAL_SCREEN,
        arguments: {'withdrawal_details_model': model});
    homeScreenCardState = HomeScreenCardState.success;
    await fetchHomePageCardFromAppForm();
  }

  _onWithdrawalInferenceFailure(
      WithdrawalBlockingDetails withdrawalBlockingDetails) {
    isWithdrawInferencePolling = false;
    isWithdrawButtonLoading = false;
    withdrawalErrorModalSheet(
        title: withdrawalBlockingDetails.title,
        message: withdrawalBlockingDetails.message);

    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.withdrawalBlocked,
        attributeName: {withdrawalBlockingDetails.type: true});
  }

  withdrawalErrorModalSheet(
      {required String title, required String message}) async {
    Get.bottomSheet(WithdrawalBlockingWidget(
      title: title,
      message: message,
    ));
  }

  onHomeScreenOfferUpgradeCTAPressed({required String actionType}) async {
    LPCService.instance.activeCard = lpcCard;
    homeScreenCardState = HomeScreenCardState.loading;
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.homepageOfferUpgradeClicked);
    _getSequenceEngineModel();
    if (homeScreenModel.sequenceEngineModel != null) {
      CheckAppFormModel checkAppFormModel =
          await SequenceEngineRepository(homeScreenModel.sequenceEngineModel!)
              .makeHttpRequest(
        body: {"actionType": actionType},
      );
      switch (checkAppFormModel.apiResponse.state) {
        case ResponseState.success:
          _computeAppState(checkAppFormModel, actionType);
          break;
        default:
          handleAPIError(
            checkAppFormModel.apiResponse,
            screenName: HOME_PAGE_SCREEN,
            retry: () =>
                onHomeScreenOfferUpgradeCTAPressed(actionType: actionType),
          );
      }
    }
  }

  //USeed for alerts
  void _computeAppState(
      CheckAppFormModel checkAppFormModel, String actionType) {
    try {
      homeScreenModel.sequenceEngineModel = checkAppFormModel.sequenceEngine;
      currentUserState =
          int.parse("${checkAppFormModel.responseBody["app_state"]}");
      goToOnBoardingPage();
    } catch (e) {
      handleAPIError(
        checkAppFormModel.apiResponse
          ..state = ResponseState.jsonParsingError
          ..exception = e.toString(),
        screenName: HOME_PAGE_SCREEN,
        retry: () => onHomeScreenOfferUpgradeCTAPressed(actionType: actionType),
      );
    }
  }

  _getSequenceEngineModel() {
    if (homeScreenModel.sequenceEngineModel != null) {
      return homeScreenModel.sequenceEngineModel!;
    }
  }

  _getEMandateStatus(SequenceEngineModel sequenceEngineModel) async {
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: sequenceEngineModel.onPolling!.requestPayload,
    );
    EMandatePollingModel model =
        EMandatePollingModel.decodeResponse(checkAppFormModel.apiResponse);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        selectedEMandateType = model.mandateMethod;
        break;
      default:
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: HOME_PAGE_SCREEN,
          retry: () => _getEMandateStatus(sequenceEngineModel),
        );
    }
  }

  void onExpansionCardChanged(bool value, CardBadgeType cardBadgeType) {
    if (expandable) {
      isExpanded = value;
    }
  }

  topUpCTAPressed({required bool isKnowMore}) async {
    LPCService.instance.activeCard = lpcCard;
    if (lpcCard.lpcCardType == LPCCardType.lowngrow) {
      await Get.toNamed(Routes.LOW_AND_GROW);
      homeScreenInterface.fetchHomePageV2();
      return;
    }

    if (isKnowMore) {
      logOfferZoneGetNowClicked();
      var isConsentGiven = await Get.toNamed(Routes.TOPUP_KNOW_MORE,
          arguments: TopUpKnowMoreArguments(isEligible: true));
      if (isConsentGiven != null && isConsentGiven) {
        goToOnBoardingPage();
      }
    } else {
      goToOnBoardingPage();
    }
  }

  void _computeLowAndGrow() {
    try {
      ///since app_state is 18, homeScreenModel will be always
      ///WithdrawalDetailsHomeScreenType
      WithdrawalDetailsHomeScreenType model =
          homeScreenModel.homeScreenType as WithdrawalDetailsHomeScreenType;
      if (model.enhancedOffer != null) {
        homeScreenInterface.createLowAndGrowOfferCard(
            lpcCard, model.enhancedOffer!);
      }
    } catch (e) {
      Get.log("Exception while computing low and grow, $e");
    }
  }
}
