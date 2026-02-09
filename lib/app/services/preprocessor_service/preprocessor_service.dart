import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/services/preprocessor_service/sms_service.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import '../../data/provider/auth_provider.dart';
import '../../data/repository/on_boarding_repository/device_detail_repository.dart';
import '../../firebase/analytics.dart';
import '../../utils/device_details_mixin.dart';
import '../platform_services/platform_services.dart';
import 'customer_device_details_service.dart';

class PreprocessorService
    with
        AppFormMixin,
        ApiErrorMixin,
        ErrorLoggerMixin,
        AdditionalDeviceDetailsMixin {
  bool _shouldSendCustomerDeviceDetails = false;
  bool _shouldSendRawSMS = false;

  bool triggerCustomerDeviceDetails;

  PreprocessorService({
    required this.triggerCustomerDeviceDetails,
  });

  checkPreprocessorData({CheckAppFormModel? checkAppFormModel}) async {
    if (checkAppFormModel == null) {
      getAppForm(
          onApiError: _onAppFormApiError,
          onRejected: _onAppFormRejected,
          onSuccess: _onAppFormSuccess);
    } else {
      _getAppFormFromCheckAppFormModel(checkAppFormModel);
    }
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    logError(
      requestBody: apiResponse.requestBody,
      exception: apiResponse.exception,
      url: apiResponse.url,
      responseBody: apiResponse.apiResponse,
      statusCode: apiResponse.statusCode.toString(),
    );
  }

  _onAppFormRejected(CheckAppFormModel checkAppFormModel) {
    _getAppFormFromCheckAppFormModel(checkAppFormModel);
  }

  void _getAppFormFromCheckAppFormModel(
      CheckAppFormModel checkAppFormModel) async {
    AppForm appForm = AppForm(
        lpcString: checkAppFormModel.responseBody['loanProduct'],
        platformType: computePlatformType(checkAppFormModel),
        loanProductCode: getLoanProductCode(checkAppFormModel),
        responseBody: checkAppFormModel.responseBody);
    _computeData(appForm.responseBody);
  }

  _onAppFormSuccess(AppForm appForm) async {
    _computeData(appForm.responseBody);
  }

  _computeRawSMSData() async {
    if (_shouldSendRawSMS) {
      PrivoPlatform.platformService.triggerSMS();
    }
  }

  _computeDeviceDetailsData() async {
    if (_shouldSendCustomerDeviceDetails) {
      await CustomerDeviceDetailsService().postCustomerDeviceDetails();
    }
  }

  _computeData(Map responseBody) async {
    if (responseBody['preprocessor'] != null) {
      var preProcessor = responseBody['preprocessor'];
      _shouldSendCustomerDeviceDetails =
          preProcessor['customer_device_details'] != null &&
              preProcessor['customer_device_details'] == "PENDING";
      _shouldSendRawSMS = preProcessor['raw_sms'] != null &&
          preProcessor['raw_sms'] == "FILE_NOT_FOUND";
      if (triggerCustomerDeviceDetails) {
        await _computeDeviceDetailsData();
      } else {
        await _computeRawSMSData();
      }
    }
  }

  pushOnEligibilityOfferAcceptance(CheckAppFormModel checkAppFormModel) async {
    Map responseBody = checkAppFormModel.responseBody;
    if (responseBody['preprocessor'] != null) {
      var preProcessor = responseBody['preprocessor'];
      _shouldSendCustomerDeviceDetails =
          preProcessor['customer_device_details'] != null &&
              preProcessor['customer_device_details'] == "PENDING";
      _shouldSendRawSMS = preProcessor['raw_sms'] != null &&
          preProcessor['raw_sms'] == "PENDING";
      if (_shouldSendCustomerDeviceDetails) {
        await _computeDeviceDetailsData();
      }
      if (_shouldSendRawSMS) {
        await _computeRawSMSData();
      }
    }
  }

// _readSMSFlag() async {
//   AppParameterModel rawSMSModel =
//       await AppParameterRepository().getAppParameters();
//   switch (rawSMSModel.apiResponse.state) {
//     case ResponseState.success:
//       if (rawSMSModel.newMethod) {
//         await SmsService().postSmsToBackendV2();
//       } else {
//         await SmsService().postSmsToBackend();
//       }
//       break;
//     default:
//       await SmsService().postSmsToBackend();
//       logError(
//         statusCode: rawSMSModel.apiResponse.statusCode.toString(),
//         responseBody: rawSMSModel.apiResponse.requestBody,
//         requestBody: rawSMSModel.apiResponse.requestBody,
//         exception: rawSMSModel.apiResponse.exception,
//         url: rawSMSModel.apiResponse.url,
//       );
//   }
// }
}
