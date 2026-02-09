import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/ckyc_details/ckyc_details_navigation.dart';
import '../../../../api/api_error_mixin.dart';

import '../../../../data/provider/auth_provider.dart';
import '../../../../models/ckyc_response_model.dart';
import '../../../../utils/app_functions.dart';
import '../../mixins/on_boarding_mixin.dart';

class CKYCDetailsLogic extends GetxController
    with OnBoardingMixin, ApiErrorMixin {
  OnBoardingCKYCDetailsNavigation? onBoardingCKYCDetailsNavigation;

  CKYCDetailsLogic({this.onBoardingCKYCDetailsNavigation});

  KYCRepository kycRepository = KYCRepository();

  final String CKYC_DETAILS_SCREEN = 'ckyc_details';

  ///loading variables
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (onBoardingCKYCDetailsNavigation != null) {
      onBoardingCKYCDetailsNavigation!
          .toggleBack(isBackDisabled: _isPageLoading);
    } else {
      onNavigationDetailsNull(CKYC_DETAILS_SCREEN);
    }
  }

  late CkycData cKycModel;

  afterLayout() {
    getCKYCDetails();
  }

  getCKYCDetails() async {
    isPageLoading = true;

    CkycResponseModel ckycResponseModel = await kycRepository.getCKYCDetails();

    switch (ckycResponseModel.apiResponse.state) {
      case ResponseState.success:
        _onCkycDetailsSuccess(ckycResponseModel);
        break;
      case ResponseState.failure:
      case ResponseState.jsonParsingError:
      case ResponseState.timedOut:
        onAadhaarXML();
        break;
      default:
        handleAPIError(
          ckycResponseModel.apiResponse,
          screenName: CKYC_DETAILS_SCREEN,
          retry: getCKYCDetails,
        );
    }
  }

  void _onCkycDetailsSuccess(CkycResponseModel ckycResponseModel) {
    if (ckycResponseModel.status == 200 &&
        _isPhotoGraphNotPDF(ckycResponseModel.ckycData)) {
      cKycModel = ckycResponseModel.ckycData;
      isPageLoading = false;
    } else {
      onAadhaarXML();
    }
  }

  bool _isPhotoGraphNotPDF(CkycData ckycData) {
    return ckycData.imageDetails
            .singleWhere((element) => element.ckycimageType == "Photograph")
            .ckycimageExtension !=
        "pdf";
  }

  ///KYC Verfication widget logics
  ///on yes confirm details pressed
  onCKYCPressed() async {
    //ToDo: commented because not used
    // isPageLoading = true;
    // String imagePath = await AppFunctions.createImageFromString(cKycModel
    //     .imageDetails
    //     .singleWhere((element) => element.ckycimageType == "Photograph")
    //     .ckycimageData);
    //
    // Map<String, dynamic> resultBody = cKycModel.toJson();
    //
    // CheckAppFormModel model = await putKyc(
    //   resultBody: _makeResultBody(resultBody),
    // );
    //
    // switch (model.apiResponse.state) {
    //   case ResponseState.success:
    //     _onCkycSuccess(imagePath);
    //     break;
    //   case ResponseState.failure:
    //   case ResponseState.jsonParsingError:
    //     onAadhaarXML(fromCKYC: true);
    //     break;
    //   default:
    //     handleAPIError(model.apiResponse);
    // }
  }

  void _onCkycSuccess(String imagePath) {
    isPageLoading = false;
    if (onBoardingCKYCDetailsNavigation != null) {
      onBoardingCKYCDetailsNavigation!.onSelectCKYC(imagePath: imagePath);
    } else {
      onNavigationDetailsNull(CKYC_DETAILS_SCREEN);
    }
  }

  onAadhaarXML({bool fromCKYC = false}) {
    isPageLoading = false;
    if (onBoardingCKYCDetailsNavigation != null) {
      onBoardingCKYCDetailsNavigation!.onSelectAadhaar(fromCKYC: fromCKYC);
    } else {
      onNavigationDetailsNull(CKYC_DETAILS_SCREEN);
    }
  }

  _makeResultBody(Map<String, dynamic> resultBody) {
    return {
      "address": {
        "line1": resultBody['permanentAddLine1'],
        "line2": resultBody['permanentAddLine2'],
        "state": resultBody['permanentState'],
        "city": resultBody['permanentCity'],
        "country": "IN",
        "pinCode": resultBody['permanentPincode']
      },
      "ckyc": resultBody
    };
  }
}
