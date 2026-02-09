import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/utils/app_functions.dart';

enum LoanProductCode { upl, clp, sbl, sbd, fcl, unknown }

enum PlatformType { android, ios, web }

class AppForm {
  final LoanProductCode loanProductCode;
  final String lpcString;
  final String offerUpgradeType;
  final bool offerUpgradeHistoryAvailable;
  final bool isVKYCFlow;
  final Map<String, dynamic> responseBody;
  final PlatformType platformType;
  final String pennyTestingVariant;
  final String applicantId;
  final String applicantPan;
  final String applicantNumber;

  AppForm({
    required this.loanProductCode,
    required this.lpcString,
    required this.responseBody,
    required this.platformType,
    this.isVKYCFlow = false,
    this.offerUpgradeHistoryAvailable = false,
    this.pennyTestingVariant = "",
    this.offerUpgradeType = "",
    this.applicantId = "",
    this.applicantPan = "",
    this.applicantNumber = "",
  });
}

class AppFormMixin {
  static const _LOAN_PRODUCT_KEY = 'loanProduct';
  static const _UPL_LOAN_PRODUCT = 'UPL';
  static const _SBL_LOAN_PRODUCT = 'SBL';

  late Function(ApiResponse) onApiError;

  getAppForm(
      {required Function(ApiResponse) onApiError,
      required Function(CheckAppFormModel) onRejected,
      required Function(AppForm) onSuccess}) async {
    this.onApiError = onApiError;
    CheckAppFormModel model = await OnBoardingRepository().getAppFormStatus();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        return _verifyIfRejected(model, onRejected, onSuccess);
      default:
        onApiError(model.apiResponse);
    }
  }

  _verifyIfRejected(CheckAppFormModel checkAppFormModel, Function onRejected,
      Function onSuccess) {
    if (checkAppFormModel.appFormRejectionModel.isRejected) {
      onRejected(checkAppFormModel);
    } else {
      _computeAppFormSuccess(checkAppFormModel, onSuccess);
    }
  }

  _computeAppFormSuccess(
      CheckAppFormModel checkAppFormModel, Function onSuccess) {
    try {
      final appForm = AppForm(
        lpcString: checkAppFormModel.responseBody[_LOAN_PRODUCT_KEY],
        platformType: computePlatformType(checkAppFormModel),
        loanProductCode: getLoanProductCode(checkAppFormModel),
        offerUpgradeType: _checkOfferUpgraded(checkAppFormModel),
        offerUpgradeHistoryAvailable:
            _computeUpgradeHistoryAvailability(checkAppFormModel),
        isVKYCFlow: _computeKYCFlow(checkAppFormModel),
        pennyTestingVariant: _checkPennyTestingType(checkAppFormModel),
        responseBody: checkAppFormModel.responseBody,
        applicantId: _computeApplicantId(checkAppFormModel),
        applicantPan: _computeApplicantPan(checkAppFormModel),
        applicantNumber: _computeApplicantNumber(checkAppFormModel),
      );
      onSuccess(appForm);
    } catch (e) {
      onApiError(checkAppFormModel.apiResponse
        ..state = ResponseState.jsonParsingError
        ..exception = e.toString());
    }
  }

  PlatformType computePlatformType(CheckAppFormModel checkAppFormModel) {
    String platformType = checkAppFormModel.responseBody['platform_type'] ?? "";
    switch (platformType) {
      case "web":
        return PlatformType.web;
      case "android":
        return PlatformType.android;
      case "ios":
        return PlatformType.ios;
      default:
        return PlatformType.android;
    }
  }

  String _checkPennyTestingType(CheckAppFormModel checkAppFormModel) {
    if (_pennyTestingNullCheck(checkAppFormModel)) {
      return checkAppFormModel.responseBody['pennyTesting']['variant'];
    } else {
      return "";
    }
  }

  String _computeApplicantId(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['applicant']?['applicantId'] ?? "";
  }

  String _computeApplicantPan(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['applicant']?['panCardId'] ?? "";
  }

  String _computeApplicantNumber(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['applicant']?['phoneNumber'] ?? "";
  }

  bool _pennyTestingNullCheck(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['pennyTesting'] != null &&
        checkAppFormModel.responseBody['pennyTesting']['variant'] != null;
  }

  String _checkOfferUpgraded(CheckAppFormModel checkAppFormModel) {
    if (_finalOfferNullCheck(checkAppFormModel)) {
      List<String> upgradeTypes = ["perfios", "account_aggregator"];
      return upgradeTypes.contains(
              "${checkAppFormModel.responseBody['finalOffer']['upgrade_type']}")
          ? "${checkAppFormModel.responseBody['finalOffer']['upgrade_type']}"
          : "";
    } else {
      return "";
    }
  }

  bool _finalOfferNullCheck(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['finalOffer'] != null &&
        checkAppFormModel.responseBody['finalOffer']['upgrade_type'] != null;
  }

  LoanProductCode getLoanProductCode(CheckAppFormModel checkAppFormModel) {
    return AppFunctions().computeLoanProductCode(
        checkAppFormModel.responseBody[_LOAN_PRODUCT_KEY]);
  }

  bool _computeUpgradeHistoryAvailability(CheckAppFormModel checkAppFormModel) {
    return checkAppFormModel.responseBody['pastOffers'] != null;
  }

  bool _computeKYCFlow(CheckAppFormModel checkAppFormModel) {
    if (checkAppFormModel.responseBody['kyc_type'] == null) return false;
    return checkAppFormModel.responseBody['kyc_type'] == 'vkyc';
  }
}
