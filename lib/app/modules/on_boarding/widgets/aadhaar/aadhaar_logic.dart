// import 'package:cs_aadhaar_xml/cs_aadhaar_xml.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/on_boarding_repository/kyc_repository.dart';
import 'package:privo/app/data/repository/on_boarding_repository/sequence_engine_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/on_boarding/on_boarding_logic.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/aadhaar/aadhaar_navigation.dart';
import 'package:privo/app/utils/native_channels.dart';

import '../../../../../flavors.dart';
import '../../../../utils/app_functions.dart';

class AadhaarLogic extends GetxController with OnBoardingMixin, ApiErrorMixin {
  OnBoardingAadhaarNavigation? onBoardingAadhaarNavigation;

  late String AADHAR_SCREEN = "aadhar";

  AadhaarLogic({this.onBoardingAadhaarNavigation});

  late SequenceEngineModel sequenceEngineModel;

  ///loading variable
  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (onBoardingAadhaarNavigation != null) {
      onBoardingAadhaarNavigation!.toggleBack(isBackDisabled: _isPageLoading);
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  ///when the user clicks aadhaar xml button
  ///sets the page to loading and will start the
  ///aadhaar xml sdk
  ///when completes the loading will stop and
  ///shows the error and success respective to the response
  ///on success goes to the open camera screen
  onAadhaarXML() async {
    isPageLoading = true;

    Map<String, String>? result =
        await NativeFunctions().startKarzaAadhaarSDK();

    // Map<String, String>? result = {};

    Get.log("aadhaar xml result = $result");

    if (result != null) {
      if (result["isError"]! == "true") {
        isPageLoading = false;
        Get.showSnackbar(
          GetSnackBar(
            title: "Oops!!! Try Again Later",
            message: result["message"],
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        await AppFunctions().postUserDataToServer(
          thirdPartyName: "AadharXML",
          requestJson: {
            "url": F.envVariables.karzaKeys.url,
            "karzaKey": F.envVariables.karzaKeys.karzaKey,
            "environment": F.envVariables.karzaKeys.environment
          },
          responseJson: result,
        );

        await _putKyc(result);
      }
    } else {
      isPageLoading = false;

      await Get.snackbar("Oops!!! Something went wrong", "Try Again Later",
              backgroundColor: Colors.red, duration: const Duration(seconds: 3))
          .show();
    }
  }

  Future<void> _putKyc(Map<String, String> result) async {
    _getSequenceEngineModel();
    CheckAppFormModel model =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: _makeResultBody(result),
    );

    switch (model.apiResponse.state) {
      case ResponseState.success:
        await _onPutKycSuccess(result);
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: AADHAR_SCREEN,
          retry: () => _putKyc(result),
        );
    }
  }

  Future<void> _onPutKycSuccess(Map<String, String> result) async {
    String imagePath =
        await AppFunctions.createImageFromString(result["imagebase64"]!);
    isPageLoading = false;

    if (onBoardingAadhaarNavigation != null) {
      onBoardingAadhaarNavigation!.onAadhaarSuccess(imagePath: imagePath);
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  _makeResultBody(Map<String, String> resultBody) {
    return {
      "kyc": {
        "kycType": "aadhaarCard",
        "kycValue": resultBody['maskedAadhaarNumber'],
        "issuedCountry": "IN"
      },
      "address": {
        "line1": generateLineOne(resultBody),
        "line2": resultBody['address_landmark'],
        "state": resultBody['address_state'],
        "city": resultBody['address_vtc'],
        "country": "IN",
        "pinCode": resultBody['address_pc']
      },
      "aadhaar": resultBody
    };
  }

  _getSequenceEngineModel() {
    if (onBoardingAadhaarNavigation != null) {
      sequenceEngineModel =
          onBoardingAadhaarNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  ///Check if the user ckyc failed or not
  ///if the ckyc is failed we have to set [unableToFetch] as the state
  ///if the ckyc is success and user selected aadhaar
  ///we have to set the state directly to [consent]
  void onAfterLayout() {
    _getSequenceEngineModel();
    if (onBoardingAadhaarNavigation != null) {
      checkFromCKYC();
    } else {
      onNavigationDetailsNull(AADHAR_SCREEN);
    }
  }

  void checkFromCKYC() {
    if (onBoardingAadhaarNavigation!.checkFromCKYC()) {
      onAadhaarXML();
    } else {
      isPageLoading = false;
    }
  }
}
