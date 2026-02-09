import 'dart:convert';

import 'package:get/get.dart';
import 'package:kyc_workflow/digio_config.dart';
import 'package:kyc_workflow/environment.dart';
import 'package:kyc_workflow/gateway_event.dart';
import 'package:kyc_workflow/kyc_workflow.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/digio_digilocker_aadhaar/digio_digilocker_aadhaar_navigation.dart';
import 'package:privo/app/modules/on_boarding/widgets/kyc_aadhaar_selfie_status_view/kyc_verification_logic.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';

import '../../../../../flavors.dart';
import '../../../../firebase/analytics.dart';
import '../../../../models/digio_aadhaar_response_model.dart';
import '../../../../models/digio_get_aadhaar_xml_model.dart';
import '../../../../models/digio_id_model.dart';
import '../../../../utils/native_channels.dart';
import '../../../../utils/snack_bar.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../mixins/on_boarding_mixin.dart';

///digio kyc
import 'package:kyc_workflow/digio_config.dart' as kycConfig;
import 'package:kyc_workflow/environment.dart' as kycEnv;
import 'package:kyc_workflow/kyc_workflow.dart' as kycWorkflow;

class DigioDigilockerAadhaarLogic extends GetxController
    with ApiErrorMixin, AppFormMixin, OnBoardingMixin {
  DigioDigilockerAadhaarNavigation? digilockerAadhaarNavigation;

  DigioDigilockerAadhaarLogic();

  late SequenceEngineModel sequenceEngineModel;

  final _kycVerificationLogic = Get.find<KycVerificationLogic>();

  final _kycRepository = KYCRepository();

  static const String DIGIO_DIGILOCKER_SCREEN = 'digio_digilocker';

  final int AADHAAR_TYPE_DIGIO = 2;

  final String PAGE_ID = 'page_id';
  final String BUTTON_ID = 'button_id';
  final String CONSENT_CHECK_BOX = 'consent_check_box';

  bool _isPageLoading = true;

  bool _isButtonLoading = false;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update([PAGE_ID]);
  }

  bool _checkBoxValue = false;

  bool get checkBoxValue => _checkBoxValue;

  set checkBoxValue(bool value) {
    _checkBoxValue = value;
    update([BUTTON_ID, CONSENT_CHECK_BOX]);
  }

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update([BUTTON_ID, CONSENT_CHECK_BOX]);
  }

  String firstName = "";

  void onDigioDigilockerAfterLayout() async {
    isButtonLoading = false;
    getAppForm(
        onApiError: _onGetAppFormError,
        onRejected: _onGetAppFormRejected,
        onSuccess: _onGetAppFormSuccess);
  }

  _onGetAppFormError(ApiResponse apiResponse) {
    handleAPIError(apiResponse, screenName: DIGIO_DIGILOCKER_SCREEN);
  }

  _onGetAppFormRejected(CheckAppFormModel checkAppFormModel) {}

  _onGetAppFormSuccess(AppForm appForm) {
    try {
      firstName = appForm.responseBody['applicant']['firstName'];
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.digiLockerScreenLoaded);
    } catch (e) {
      handleAPIError(
          ApiResponse(
            state: ResponseState.jsonParsingError,
            apiResponse: "",
            exception: e.toString(),
          ),
          screenName: DIGIO_DIGILOCKER_SCREEN);
    }
    isPageLoading = false;
  }

  _getSequenceEngineModel() {
    if (digilockerAadhaarNavigation != null) {
      sequenceEngineModel =
          digilockerAadhaarNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(DIGIO_DIGILOCKER_SCREEN);
    }
  }

  startDigioSDK() async {
    isButtonLoading = true;
    DigioIDModel digioIDModel =
        await _kycRepository.getDigioId(await AppAuthProvider.phoneNumber);
    switch (digioIDModel.apiResponse.state) {
      case ResponseState.success:
        AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.digiLockerContinueCTA);
        _startSDK(digioIDModel);
        break;
      default:
        handleAPIError(digioIDModel.apiResponse,
            screenName: DIGIO_DIGILOCKER_SCREEN, retry: startDigioSDK);
    }
  }

  void _startSDK(DigioIDModel digioIDModel) async {
    if ((await _startDigioSDK(digioIDModel))) {
      _getExecutionId(digioIDModel.kID);
    } else {
      AppSnackBar.errorBar(title: "Sorry", message: "Please Try Again");
      isButtonLoading = false;
    }
  }

  Future<bool> _startDigioSDK(DigioIDModel digioIDModel) async {
    var digioConfig = kycConfig.DigioConfig();
    digioConfig.theme.primaryColor = appColor;
    digioConfig.logo = appLogo;
    digioConfig.environment = F.appFlavor == Flavor.prod
        ? kycEnv.Environment.PRODUCTION
        : kycEnv.Environment.SANDBOX; // SANDBOX, PRODUCTION

    final kycWorkflowPlugin = kycWorkflow.KycWorkflow(digioConfig);

    kycWorkflowPlugin.setGatewayEventListener((event) {
      Get.log("digio kyc events - $event");
    });

    var workflowResult = await kycWorkflowPlugin.start(
      digioIDModel.kID,
      "+91${await AppAuthProvider.phoneNumber}",
      digioIDModel.token,
      null,
    );

    Get.log("kyc result = $workflowResult");

    return workflowResult.code != null && workflowResult.code == 1001;
  }

  _getExecutionId(String kId) async {
    DigioAadhaarResponseModel digioAadhaarResponseModel =
        await _kycRepository.getAadhaarResponse(kId);
    switch (digioAadhaarResponseModel.apiResponse.state) {
      case ResponseState.success:
        _getAadhaarXMLFile(digioAadhaarResponseModel);
        break;
      default:
        handleAPIError(digioAadhaarResponseModel.apiResponse,
            screenName: DIGIO_DIGILOCKER_SCREEN);
    }
  }

  void _getAadhaarXMLFile(
      DigioAadhaarResponseModel digioAadhaarResponseModel) async {
    DigioAadhaarXMLModel digioAadhaarXMLModel = await _kycRepository
        .getAadhaarXML(digioAadhaarResponseModel.executionRequestID);
    switch (digioAadhaarXMLModel.apiResponse.state) {
      case ResponseState.success:
        _appendXMLIntoDigioResponse(
            digioAadhaarResponseModel, digioAadhaarXMLModel);
        break;
      default:
        handleAPIError(digioAadhaarXMLModel.apiResponse,
            screenName: DIGIO_DIGILOCKER_SCREEN);
    }
  }

  void _appendXMLIntoDigioResponse(
      DigioAadhaarResponseModel digioAadhaarResponseModel,
      DigioAadhaarXMLModel digioAadhaarXMLModel) {
    ///after getting the xml string, append it to the digio Aadhaar data
    ///in the following path, actions(array)->fist item->details->aadhaar
    ///the below code will create xml key and add the xml string value
    digioAadhaarResponseModel.digioResponse['actions'][0]['details']['aadhaar']
        ['xml'] = digioAadhaarXMLModel.apiResponse.apiResponse;
    digioAadhaarResponseModel.digioResponse['type'] = AADHAAR_TYPE_DIGIO;
    _putKYC(digioAadhaarResponseModel);
  }

  void _putKYC(DigioAadhaarResponseModel digioAadhaarResponseModel) async {
    _getSequenceEngineModel();
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: digioAadhaarResponseModel.digioResponse);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        if (digilockerAadhaarNavigation != null) {
          digilockerAadhaarNavigation!.navigateUserToAppStage(
              sequenceEngineModel: model.sequenceEngine!);
        }
        _kycVerificationLogic.onAadhaarSuccess();
        break;
      default:
        handleAPIError(model.apiResponse,
            retry: () => _putKYC(digioAadhaarResponseModel),
            screenName: DIGIO_DIGILOCKER_SCREEN);
    }
  }
}
