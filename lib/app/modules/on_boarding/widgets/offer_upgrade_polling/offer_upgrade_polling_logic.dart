import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/data/repository/on_boarding_repository/offer_upgrade_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/user_state_maps.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/res.dart';

import '../../../../api/response_model.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/app_form_rejection_model.dart';
import '../../../../services/polling_service.dart';
import '../../../../utils/apps_flyer_constants.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/on_boarding_mixin.dart';
import 'offer_upgrade_polling_navigation.dart';

enum OfferUpgradeStatus {
  polling,
  failure,
  nameMatchFailure,
  limitExceeded,
  sameOffer,
  offerUpgraded,
  loading,
  noTransactions
}

class OfferUpgradePollingLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  final String FO_APPROVED_UPGRADE_SCREEN = "FO_APPROVED_UPGRADE_SCREEN";

  static const String OFFER_UPGRADE_POLLING_SCREEN = "offer_upgrade_polling";

  final String PAGE_ID = "PAGE_ID";

  final _aaRepository = OfferUpgradeRepository();

  final _pollingService = PollingService();

  OnBoardingOfferUpgradePollingNavigation?
      onBoardingOfferUpgradePollingNavigation;

  OfferUpgradeStatus _offerUpgradeStatus = OfferUpgradeStatus.polling;

  OfferUpgradeStatus get offerUpgradeStatus => _offerUpgradeStatus;

  set offerUpgradeStatus(OfferUpgradeStatus value) {
    _offerUpgradeStatus = value;
    update([PAGE_ID]);
  }

  late SequenceEngineModel sequenceEngineModel;

  late OfferSection initialOffer;
  late OfferSection finalOffer;

  void onAfterLayout() {
    offerUpgradeStatus = OfferUpgradeStatus.polling;
    _getSequenceEngineModel();
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aaPerfiosProcessingScreen,
        attributeName:
            sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
                ? {"upgrade_flow_aa_perfios": "true"}
                : {"rejection_flow_aa_perfios": "true"});
    _startPolling();
  }

  _startPolling() {
    _pollingService.initAndStartPolling(
      pollingInterval: sequenceEngineModel.onPolling?.callFrequency ?? 5,
      maxPollingLimit: sequenceEngineModel.onPolling?.maxCalls,
      pollingFunction: () {
        _getOfferUpgradeStatus();
      },
    );
  }

  _getSequenceEngineModel() {
    if (onBoardingOfferUpgradePollingNavigation != null) {
      onBoardingOfferUpgradePollingNavigation!.toggleAppBarVisibility(false);
      _onSequenceEngineDetailsFetched();
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _onSequenceEngineDetailsFetched() {
    sequenceEngineModel =
        onBoardingOfferUpgradePollingNavigation!.getSequenceEngineDetails();
  }

  void _toggleBackDisabled({required bool isBackDisabled}) {
    if (onBoardingOfferUpgradePollingNavigation != null) {
      onBoardingOfferUpgradePollingNavigation!
          .toggleBack(isBackDisabled: isBackDisabled);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _getOfferUpgradeStatus() async {
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: _fetchRequestPayload(),
    );
    switch (model.apiResponse.state) {
      case ResponseState.success:
        if (model.sequenceEngine != null) {
          sequenceEngineModel = model.sequenceEngine!;
        }
        _onOfferUpgradeStatusAPISuccess(model);
        break;
      default:
        handleAPIError(model.apiResponse,
            screenName: OFFER_UPGRADE_POLLING_SCREEN, retry: onAfterLayout);
    }
  }

  _fetchRequestPayload() {
    if (sequenceEngineModel.onPolling != null) {
      return sequenceEngineModel.onPolling!.requestPayload;
    }
  }

  void _onOfferUpgradeStatusAPISuccess(CheckAppFormModel model) async {
    if (model.appFormRejectionModel.isRejected) {
      _toggleBackDisabled(isBackDisabled: false);
      _pollingService.stopPolling();
      _onAppFormRejectionNavigation(model.appFormRejectionModel);
    } else {
      _checkOfferUpgradeStatus(model);
    }
  }

  void _onAppFormRejectionNavigation(
      AppFormRejectionModel appFormRejectionModel) {
    if (onBoardingOfferUpgradePollingNavigation != null) {
      AppAnalytics.logAppsFlyerEvent(
          eventName: AppsFlyerConstants.offerejected);
      onBoardingOfferUpgradePollingNavigation!
          .onAppFormRejected(model: appFormRejectionModel);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _checkOfferUpgradeStatus(CheckAppFormModel model) async {
    try {
      bool isOfferPassed = model.responseBody["polling_status"] == "COMPLETE";
      if (isOfferPassed) {
        _pollingService.stopPolling();
        _onOfferUpgradeComplete(model);
      }
    } on Exception catch (e) {
      _pollingService.stopPolling();
      handleAPIError(model.apiResponse..exception = e.toString(),
          screenName: OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _onOfferUpgradeComplete(CheckAppFormModel model) {
    try {
      String upgradeOfferStatus = model.responseBody['upgradeOfferStatus'];
      if (upgradeOfferStatus == "REJECTED_TO_APPROVED") {
        _moveToOfferScreen(model);
      } else {
        _checkForFailure(model, upgradeOfferStatus);
      }
    } catch (e) {
      handleAPIError(
          model.apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString(),
          screenName: OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _moveToOfferScreen(CheckAppFormModel model) {
    if (onBoardingOfferUpgradePollingNavigation != null) {
      onBoardingOfferUpgradePollingNavigation!
          .navigateUserToAppStage(sequenceEngineModel: model.sequenceEngine!);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  _checkForFailure(CheckAppFormModel model, String upgradeOfferStatus) {
    switch (upgradeOfferStatus) {
      case "NAME_MATCH_FAILURE":
        _logFailureScreenLoaded("name_match_failure");
        offerUpgradeStatus = OfferUpgradeStatus.nameMatchFailure;
        break;
      case "LIMIT_EXCEEDED":
        _logFailureScreenLoaded("limit_exceeded");
        offerUpgradeStatus = OfferUpgradeStatus.limitExceeded;
        break;
      case "FAILURE":
        _logFailureScreenLoaded("failure");
        offerUpgradeStatus = OfferUpgradeStatus.failure;
        break;
      case "NO_TRANSACTION":
        _logFailureScreenLoaded("no_transactions");
        offerUpgradeStatus = OfferUpgradeStatus.noTransactions;
        break;
      default:
        _computeUpgradeOfferStatus(model, upgradeOfferStatus);
    }
  }

  void _logFailureScreenLoaded(String failureReason) {
    try {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aaFailureScreenLoaded,
        attributeName: {
          sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
              ? "upgrade_flow_aa_perfios"
              : "rejection_flow_aa_perfios": "true",
          failureReason: true,
        },
      );
    } on Exception catch (e) {
      Get.log("web engage failure screen event error - $e");
    }
  }

  void _computeUpgradeOfferStatus(
      CheckAppFormModel model, String upgradeOfferStatus) {
    try {
      initialOffer = OfferSection.fromJson(
          model.responseBody['initialOffer']['offerSection']);
      finalOffer = OfferSection.fromJson(
          model.responseBody['finalOffer']['offerSection']);
      switch (upgradeOfferStatus) {
        case "OFFER_DOWNSAMEGRADED":
          offerUpgradeStatus = OfferUpgradeStatus.sameOffer;
          break;
        case "OFFER_UPGRADED":
          offerUpgradeStatus = OfferUpgradeStatus.offerUpgraded;
          break;
      }
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.aaUpgradedOfferScreenLoaded,
          attributeName: {"upgrade_flow_aa_perfios": "true"});
    } catch (e) {
      handleAPIError(
          model.apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString(),
          screenName: OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  onPollingFailedRetryClicked() {
    _logFailureScreenRetryClicked(offerUpgradeStatus);
    if (onBoardingOfferUpgradePollingNavigation != null) {
      onBoardingOfferUpgradePollingNavigation!
          .navigateUserToAppStage(sequenceEngineModel: sequenceEngineModel);
    } else {
      onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
    }
  }

  void _logFailureScreenRetryClicked(OfferUpgradeStatus offerUpgradeStatus) {
    String reason = "failure";
    switch (offerUpgradeStatus) {
      case OfferUpgradeStatus.failure:
        reason = "failure";
        break;
      case OfferUpgradeStatus.nameMatchFailure:
        reason = "name_match_failure";
        break;
      case OfferUpgradeStatus.limitExceeded:
        reason = "limit_exceeded";
        break;
      default:
        break;
    }
    try {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.aaFailureScreenRetryClicked,
        attributeName: {
          sequenceEngineModel.screenType == FO_APPROVED_UPGRADE_SCREEN
              ? "upgrade_flow_aa_perfios"
              : "rejection_flow_aa_perfios": "true",
          reason: true,
        },
      );
    } on Exception catch (e) {
      Get.log("web engage failure screen event error - $e");
    }
  }

  void onContinueToKycClicked() async {
    _toggleBackDisabled(isBackDisabled: true);
    offerUpgradeStatus = OfferUpgradeStatus.loading;
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {
        "actionType": "accept",
      },
    );
    _toggleBackDisabled(isBackDisabled: false);
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        if (onBoardingOfferUpgradePollingNavigation != null &&
            checkAppFormModel.sequenceEngine != null) {
          sequenceEngineModel = checkAppFormModel.sequenceEngine!;
          onBoardingOfferUpgradePollingNavigation!
              .navigateUserToAppStage(sequenceEngineModel: sequenceEngineModel);
        } else {
          onNavigationDetailsNull(OFFER_UPGRADE_POLLING_SCREEN);
        }
        break;
      default:
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: OFFER_UPGRADE_POLLING_SCREEN,
          retry: onContinueToKycClicked,
        );
    }
  }

  void onKnowledgeBaseClicked() {
    Get.toNamed(
      Routes.KNOWLEDGE_BASE,
      arguments: {
        "back_to_parent": true,
      },
      preventDuplicates: true,
    );
  }

  onClosePressed() {
    _pollingService.stopPolling();
    Get.back();
  }

  stopOfferUpgradePolling() {
    _pollingService.stopPolling();
  }

  startOfferUpgradePolling() {
    _startPolling();
  }

  String computeFailureButtonText() {
    return offerUpgradeStatus == OfferUpgradeStatus.limitExceeded
        ? "Continue"
        : "Try Again";
  }

  String computeFailureBodyText() {
    switch (offerUpgradeStatus) {
      case OfferUpgradeStatus.failure:
        return "Looks like there's an issue fetching your details.\nPlease try again.";
      case OfferUpgradeStatus.nameMatchFailure:
        return "Please try again with your bank account details";
      case OfferUpgradeStatus.limitExceeded:
        return "We apologise, but it seems that your attempts\nhave been exhausted. Please continue with your\nprevious offer";
      case OfferUpgradeStatus.noTransactions:
        return "It looks like this bank account has no transactions. Please try again with another account that has recorded transactions.";
      case OfferUpgradeStatus.polling:
      case OfferUpgradeStatus.sameOffer:
      case OfferUpgradeStatus.offerUpgraded:
      case OfferUpgradeStatus.loading:
        return "";
    }
  }

  String computeFailureIllustration() {
    switch (offerUpgradeStatus) {
      case OfferUpgradeStatus.failure:
        return Res.aaFailure;
      default:
        return Res.piggy_bank_failure_svg;
    }
  }

  String computeFailureTitle() {
    switch (offerUpgradeStatus) {
      case OfferUpgradeStatus.noTransactions:
        return "Account Doesn't Have Any Transactions";
      case OfferUpgradeStatus.failure:
        return "Something went wrong!";
      default:
        return "Account Doesn’t Match";
    }
  }

  @override
  void onClose() {
    _pollingService.stopPolling();
    super.onClose();
  }
}
