import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/e_sign_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/e_sign_download_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_analytics.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_sign/e_sign_navigation.dart';
import 'package:privo/app/services/platform_services/platform_services.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/native_channels.dart';

import '../../../../../flavors.dart';
import '../../../../api/api_error_mixin.dart';
import '../../../../models/generate_doc_sign_model.dart';
import '../../../../models/request_doc_sign_model.dart';

///digio esign
// import 'package:esign_plugin/digio_config.dart' as eSignConfig;
// import 'package:esign_plugin/environment.dart' as eSignEnv;
// import 'package:esign_plugin/esign_plugin.dart' as eSignPlugin;
// import 'package:esign_plugin/service_mode.dart' as eSignMode;

import 'package:kyc_workflow/digio_config.dart' as eSignConfig;
import 'package:kyc_workflow/environment.dart' as eSignEnv;
import 'package:kyc_workflow/service_mode.dart' as eSignMode;
import 'package:kyc_workflow/kyc_workflow.dart' as eSignPlugin;

import '../../../../utils/strings.dart';

class ESignLogic extends GetxController
    with
        OnBoardingMixin,
        ApiErrorMixin,
        AppFormMixin,
        AppAnalyticsMixin,
        ESignAnalytics {
  OnBoardingESignNavigation? onBoardingESignNavigation;

  ESignLogic({this.onBoardingESignNavigation});

  ESignRepository eSignRepository = ESignRepository();

  late SequenceEngineModel sequenceEngineModel;

  late LoanProductCode loanProductCode;

  static const String ESIGN_SCREEN = 'esign';

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update(['page']);
    if (onBoardingESignNavigation != null) {
      onBoardingESignNavigation!
          .toggleBack(isBackDisabled: isButtonLoading || isPageLoading);
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
  }

  ///loading variable
  bool _isButtonLoading = false;

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update(['button']);
    if (onBoardingESignNavigation != null) {
      onBoardingESignNavigation!
          .toggleBack(isBackDisabled: isButtonLoading || isPageLoading);
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
  }

  late String lpcString;

  bool _startDigioSDK = true;

  ///Email = identifier for Digio SDK
  String personalEMail = "";

  void onAfterLayout() {
    logESignLoaded();
    if (onBoardingESignNavigation != null) {
      onBoardingESignNavigation!.toggleAppBarVisibility(true);
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
    _getAppForm();
  }

  _getAppForm() async {
    isPageLoading = true;

    getAppForm(
      onSuccess: _onAppFormApiSuccess,
      onApiError: _onAppFormApiError,
      onRejected: _onAppFormRejectionNavigation,
    );
  }

  _onAppFormApiSuccess(AppForm appForm) {
    lpcString = appForm.lpcString;
    loanProductCode = appForm.loanProductCode;
    _getAppFormDetails(appForm.loanProductCode, appForm.responseBody);
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    isPageLoading = false;
    handleAPIError(apiResponse, screenName: ESIGN_SCREEN, retry: _getAppForm);
  }

  _getAppFormDetails(
      LoanProductCode appFormType, Map<String, dynamic> responseBody) {
    try {
      personalEMail = responseBody['applicant']['personalEmail'];
      isPageLoading = false;
    } catch (e) {
      isPageLoading = false;
      handleAPIError(
          ApiResponse(
            state: ResponseState.jsonParsingError,
            apiResponse: "",
            exception: e.toString(),
          ),
          screenName: ESIGN_SCREEN,
          retry: _getAppForm);
    }
  }

  ///logics for esign screen to  proceed to next page
  onESignContinueTapped() async {
    logESignReviewAcceptClicked();
    isButtonLoading = true;

    GenerateDocSignModel generateDocSignModel =
        await eSignRepository.generateDocSign(
      lpc: lpcString,
    );

    switch (generateDocSignModel.apiResponse.state) {
      case ResponseState.success:
        _requestDocSign();
        break;
      default:
        isButtonLoading = false;
        handleAPIError(generateDocSignModel.apiResponse,
            screenName: ESIGN_SCREEN, retry: onESignContinueTapped);
    }
  }

  _requestDocSign() async {
    isButtonLoading = true;
    RequestDocSignModel requestDocSignModel =
        await eSignRepository.requestDocSign(
      lpc: lpcString,
    );

    switch (requestDocSignModel.apiResponse.state) {
      case ResponseState.success:
        if (_startDigioSDK) {
          _getESignDetails(requestDocSignModel);
        }
        break;
      default:
        isButtonLoading = false;
        handleAPIError(requestDocSignModel.apiResponse,
            screenName: ESIGN_SCREEN, retry: _requestDocSign);
    }
  }

  void _onAppFormRejectionNavigation(CheckAppFormModel checkAppFormModel) {
    isPageLoading = false;
    if (onBoardingESignNavigation != null) {
      onBoardingESignNavigation!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
  }

  void _getESignDetails(RequestDocSignModel requestDocSignModel) async {
    if (await _startDigioEsignSDK(requestDocSignModel)) {
      ///download the signed document from
      ///digio and upload it to S3
      ///using the below api and send the document id response from posedion to the backend api for sending signed loan agreement
      await uploadSignedDocToBackend(requestDocSignModel);
    } else {
      isButtonLoading = false;
      onESignFailure();
    }
  }

  Future<bool> _startDigioEsignSDK(
      RequestDocSignModel requestDocSignModel) async {
    var digioConfig = eSignConfig.DigioConfig();
    digioConfig.theme.primaryColor = appColor;
    digioConfig.logo = appLogo;
    digioConfig.environment = F.appFlavor == Flavor.prod
        ? eSignEnv.Environment.PRODUCTION
        : eSignEnv.Environment.SANDBOX;
    digioConfig.serviceMode = eSignMode.ServiceMode.OTP;

    final esignPlugin = eSignPlugin.KycWorkflow(digioConfig);

    var esignResult = await esignPlugin.start(
      requestDocSignModel.docId,
      personalEMail,
      requestDocSignModel.accessToken,
      null,
    );
    return esignResult.code != null && esignResult.code == 1001;
  }

  uploadSignedDocToBackend(RequestDocSignModel requestDocSignModel) async {
    ESignDownloadModel eSignDownloadModel = await eSignRepository.getESignLink(
      docId: requestDocSignModel.docId,
    );

    switch (eSignDownloadModel.apiResponse.state) {
      case ResponseState.success:
        _onGetS3Url(eSignDownloadModel);
        break;
      default:
        handleAPIError(
            ApiResponse(
                state: eSignDownloadModel.apiResponse.state,
                apiResponse: eSignDownloadModel.apiResponse.apiResponse),
            screenName: ESIGN_SCREEN,
            retry: uploadSignedDocToBackend);
    }
  }

  _fetchSequenceEngine() {
    if (onBoardingESignNavigation != null) {
      sequenceEngineModel =
          onBoardingESignNavigation!.getSequenceEngineDetails();
    }
  }

  _onGetS3Url(ESignDownloadModel eSignDownloadModel) async {
    String s3Url = eSignDownloadModel.s3URL;
    String s3DocId = s3Url.split('/').last;
    _fetchSequenceEngine();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel)
            .makeHttpRequest(body: {"docId": s3DocId});
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        logESignSuccessLoaded();
        _onESignSuccess(checkAppFormModel);
        break;
      default:
        handleAPIError(
            ApiResponse(
                state: checkAppFormModel.apiResponse.state,
                apiResponse: checkAppFormModel.apiResponse.apiResponse),
            screenName: ESIGN_SCREEN,
            retry: _onGetS3Url);
    }
  }

  void _onESignSuccess(CheckAppFormModel checkAppFormModel) {
    if (onBoardingESignNavigation != null &&
        checkAppFormModel.sequenceEngine != null) {
      onBoardingESignNavigation!.navigateUserToAppStage(
          sequenceEngineModel: checkAppFormModel.sequenceEngine!);
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
  }

  void onESignFailure() {
    if (onBoardingESignNavigation != null) {
      onBoardingESignNavigation!.onESignFailure();
    } else {
      onNavigationDetailsNull(ESIGN_SCREEN);
    }
  }

  Map<LoanProductCode, String> eSignAgreementLineMapData() {
    return {
      LoanProductCode.sbl: "Sign E-agreement to fast track your loan disbursal",
      LoanProductCode.upl: "Sign E-agreement to fast track your loan disbursal",
      LoanProductCode.clp: "Sign E-agreement to avail the Credit Line",
    };
  }

  eSignAgreementLine() {
    return eSignAgreementLineMapData()[loanProductCode];
  }

  @override
  void onClose() {
    _startDigioSDK = false;
    super.onClose();
  }
}
