import 'dart:convert';

import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';

import '../modules/additional_business_details/model/address_details.dart';

AdditionalBusinessDetailsModel additionalBusinessDetailsModelFromJson(
    ApiResponse apiResponse) {
  return AdditionalBusinessDetailsModel.decodeResponse(apiResponse);
}

class AdditionalBusinessDetailsModel {
  late final String applicantId;
  late bool isConsentAgreed;
  late final bool isGstDocumentMandatory;
  late final AddressDetails operationalAddress;
  late final AddressDetails correspondingAddress;
  late final AddressDetails registeredAddress;
  late final ApiResponse apiResponse;
  late final String lpc;
  late final String udyamNumber;
  late final String sector;
  late final String natureOfBusiness;
  late final bool reKycToBeDone;
  late final String loanAppFormId;
  late final String loanAppFormLpc;
  late final bool reconfirmAddressYes;
  late final bool reconfirmAddressNo;
  late final String oldApplicantId;

  AdditionalBusinessDetailsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse.apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("AdditionalBusinessDetailsModel exception ${e.toString()}");
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(String apiResponse) {
    var json = jsonDecode(apiResponse);
    json = json['responseBody'];
    applicantId = "${json['applicantId']}";
    isConsentAgreed = json?['isDocumentConsentAgreed'] ?? false;
    operationalAddress = AddressDetails.fromJson(
      json?['operationalAddress'],
      type: "Operational",
    );
    correspondingAddress = AddressDetails.fromJson(
      json?['residenceAddress'],
      type: "Residence",
    );

    registeredAddress = AddressDetails.fromJson(
      json?['registeredAddress'] ?? {},
      type: "Registered",
    );
    isGstDocumentMandatory = json?['isGstDocumentMandatory'] ?? false;
    lpc = (json?['loanProduct'] ?? "").toString().toUpperCase();
    String udyamNum = (json?['udyam'] ?? "").toString().toUpperCase();
    udyamNumber = udyamNum.replaceAll("UDYAM-", "");
    natureOfBusiness = (json?['nature'] ?? "").toString();
    sector = (json?['sector'] ?? "").toString();
    reKycToBeDone = json?['reKycToBeDone'] ?? false;
    loanAppFormId = (json?['loanAppFormId'] ?? "").toString();
    loanAppFormLpc = (json?['loanAppFormLpc'] ?? "").toString();
    reconfirmAddressYes = json?['reconfirmAddressYes'] ?? false;
    reconfirmAddressNo = json?['reconfirmAddressNo'] ?? false;
    oldApplicantId = (json?['oldApplicantId'] ?? "").toString();
  }
}
