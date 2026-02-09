import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/mixin/e_mandate_polling_mixin.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/e_mandate_polling_navigation.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../../flavors.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../common_widgets/web_view_close_alert_dialog.dart';
import '../../../../models/e_mandate_polling_model.dart';
import '../../analytics/e_mandate_analytics_mixin.dart';
import '../../mixins/app_form_mixin.dart';
import '../../mixins/on_boarding_mixin.dart';
import '../../user_state_maps.dart';
import '../e_mandate/e_mandate_failure_model.dart';
import '../e_mandate/emandate_error_messages.dart';

enum EMandatePollingState {
  polling,
  success,
  error,
}

class EMandatePollingLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin, AppFormMixin, EMandateAnalyticsMixin {
  final String EMANDATE_POLLING_LOGIC = "EMANDATE_POLLING_LOGIC";

  OnBoardingEMandatePollingNavigation? navigation;

  EMandatePollingLogic({this.navigation});

  EMandatePollingState _eMandatePollingState = EMandatePollingState.polling;

  EMandatePollingState get eMandatePollingState => _eMandatePollingState;

  late String UPI = "UPI";

  set eMandatePollingState(EMandatePollingState value) {
    _eMandatePollingState = value;
    update();
  }

  EmandateFailureModel failureMessage = EmandateFailureModel(
    title: "Uh-oh!",
    subTitle:
        "It seems like a temporary technical issue is preventing\nAuto-pay registration. Please try again later.",
  );

  String accountNumber = "";
  String bankName = "";
  String selectedMandateType = "";

  final _eMandatePolling = EMandatePolling();

  SequenceEngineModel? failedSequenceEngineModel;

  ///if user enters a upi id which is not linked to users penny tested
  ///bank account
  bool isTPVFailure = false;

  void _toggleAppBarVisibility({required bool isVisible}) {
    if (navigation != null) {
      navigation!.toggleAppBarVisibility(isVisible);
    } else {
      onNavigationDetailsNull(EMANDATE_POLLING_LOGIC);
    }
  }

  void onAfterLayout() {
    _toggleAppBarVisibility(
      isVisible: false,
    );
    eMandatePollingState = EMandatePollingState.polling;
    if (navigation != null) {
      _startPolling(navigation!.getSequenceEngineDetails());
    } else {
      onNavigationDetailsNull(EMANDATE_POLLING_LOGIC);
    }
  }

  void _startPolling(SequenceEngineModel sequenceEngineModel) {
    navigation?.toggleAppBarVisibility(false);
    _eMandatePolling.initAndStart(
      onSuccess: _onSuccess,
      onFailure: _onFailure,
      onPending: _onPending,
      onApiError: _onPollingApiError,
      sequenceEngineModel: sequenceEngineModel,
    );
  }

  _onSuccess(EMandatePollingModel model) async {
    logMandateSuccessful(model.mandateMethod);
    eMandatePollingState = EMandatePollingState.success;

    ///to show eMandate success screen to the user
    await Future.delayed(const Duration(seconds: 3));
    if (model.sequenceEngine != null) {
      if (model.sequenceEngine!.appState == "$DISBURSAL_PROGRESS") {
        Get.back();
      } else if (navigation != null) {
        navigation!
            .navigateUserToAppStage(sequenceEngineModel: model.sequenceEngine!);
      } else {
        onNavigationDetailsNull(EMANDATE_POLLING_LOGIC);
      }
    } else {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "Sequence engine is null in EMandate Success",
        ),
        screenName: EMANDATE_POLLING_LOGIC,
      );
    }
  }

  _onFailure(EMandatePollingModel model) {
    accountNumber = model.accountNumber;
    bankName = model.bankName;
    failedSequenceEngineModel = model.sequenceEngine;
    isTPVFailure = model.isTPVFailure;
    if (model.isTPVFailure) {
      failureMessage = EmandateFailureModel(
        title: "Hey there!",
        subTitle:
            "It appears you've used a different UPI ID for Auto-Pay\nsetup. Please ensure you use the correct UPI ID that\nmatches your primary account listed below:",
      );
    }
    logMandateFailed(model.mandateMethod, isTPVFailure);
    navigation?.toggleAppBarVisibility(true);
    eMandatePollingState = EMandatePollingState.error;
  }

  _onPending(EMandatePollingModel model) {
    selectedMandateType = model.mandateMethod;
    eMandatePollingState = EMandatePollingState.polling;
  }

  _onPollingApiError(ApiResponse apiResponse) {
    handleAPIError(
      apiResponse,
      screenName: EMANDATE_POLLING_LOGIC,
    );
  }

  void onMinimizePressed() {
    logAutopayMinimised(selectedMandateType);
    Get.back();
  }

  void onTryAgainPressed() {
    if (navigation != null) {
      _navigationOnFailure(navigation!);
    } else {
      onNavigationDetailsNull(EMANDATE_POLLING_LOGIC);
    }
  }

  void _navigationOnFailure(OnBoardingEMandatePollingNavigation navigation) {
    navigation.changeAppBarTitle(
      "Set up Auto-Pay",
      "Link your bank account",
    );
    if (failedSequenceEngineModel != null) {
      navigation.navigateUserToAppStage(
          sequenceEngineModel: failedSequenceEngineModel!);
      eMandatePollingState = EMandatePollingState.polling;
    } else {
      handleAPIError(
        ApiResponse(
          state: ResponseState.failure,
          apiResponse: "",
          exception: "Issue in Sequence Engine in EMandate Failure",
        ),
        screenName: EMANDATE_POLLING_LOGIC,
      );
    }
  }

  List<String> computeBodyTexts() {
    if (selectedMandateType.isEmpty || selectedMandateType != UPI) {
      return ["We are setting up auto-pay with your bank"];
    }
    return ["Please approve the request in your UPI app"];
  }

  onClosePressed() {
    _eMandatePolling.stop();
    Get.back();
  }

  @override
  void onClose() {
    Get.log("emandate polling closed");
    _eMandatePolling.stop();
    super.onClose();
  }

  stopEMandatePolling() {
    _eMandatePolling.stop();
  }

  startEmandatePolling() {
    if (navigation != null) {
      _startPolling(navigation!.getSequenceEngineDetails());
    } else {
      onNavigationDetailsNull(EMANDATE_POLLING_LOGIC);
    }
  }

  computeShowHelpMessage() {
    String? loanProductCode = LPCService.instance.activeCard?.loanProductCode;
    if (loanProductCode != null &&
        !(AppFunctions().computeLoanProductCode(loanProductCode) ==
            LoanProductCode.clp)) {
      return true;
    }
    return false;
  }
}
