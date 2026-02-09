import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/processing_fee_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/model/branch_led_break_down_data.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/model/top_up_break_down_data.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/cross_sell_breakdown_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer/widgets/offer_table_Model.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../utils/app_functions.dart';
import 'rich_text_model.dart';

///Response model that have CheckAppFormModel as base
///Helps in catching the json parsing errors
///If parsing fails we have the response state

PreApprovalOfferModel initialOfferModelFromJson(ApiResponse apiResponse) {
  return PreApprovalOfferModel.decodeResponse(apiResponse);
}

class PreApprovalOfferModel extends CheckAppFormModel {
  late final InsuranceDetails? insuranceDetails;
  late final String applicationStatus;
  late final OfferSection? offerSection;
  late List<OfferTableModel> loanBreakDownData = [];
  late final String offerText;
  late final String infoText;
  late final ProcessingFeeModel? processingFeeModel;
  final int _offerFirstTextIndex = 0;
  final int _offerSecondTextIndex = 1;
  late final List<VasDetails>? vasDetailsList;
  late final String title;
  late final String subtitle;
  late final String buttonText;
  late final bool isUpgradeEligible;

  PreApprovalOfferModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          insuranceDetails = responseBody['insuranceDetails'] == null
              ? null
              : InsuranceDetails.fromJson(responseBody['insuranceDetails']);
          applicationStatus = responseBody['applicationStatus'] ?? "";
          offerSection = responseBody['offerSection'] == null
              ? null
              : OfferSection.fromJson(responseBody['offerSection']);
          offerText = _parseOfferInfo();
          vasDetailsList = (responseBody['vasDetails'] == null
              ? null
              : List.from(responseBody['vasDetails'])
                  .map((e) => VasDetails.fromJson(e))
                  .toList());
          _parseOfferDetails();
          _addOfferTableDataPoints();
          _computeInfoText();
          isUpgradeEligible = responseBody['is_upgrade_eligible'] ?? false;
          title = responseBody['title'] ?? "";
          subtitle = responseBody['subtitle'] ?? "";
          buttonText = responseBody['button_text'] ?? "";
        } catch (e) {
          Get.log(e.toString());
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _addOfferTableDataPoints() {
    String lpc = LPCService.instance.activeCard?.loanProductCode ?? "";
    switch (AppFunctions().computeLoanProductCode(lpc)) {
      case LoanProductCode.clp:
        break;
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
      case LoanProductCode.sbd:
        _computeLpcCardType();
        break;
      default:
        break;
    }
  }

  void _computeLpcCardType() {
    LPCCardType lpcCardType =
        LPCService.instance.activeCard?.lpcCardType ?? LPCCardType.loan;
    switch (lpcCardType) {
      case LPCCardType.loan:
        loanBreakDownData =
            BranchLedBreakDownData().computeOfferTableModel(offerSection);
        break;
      case LPCCardType.topUp:
        loanBreakDownData =
            TopUpBreakDownData().computeOfferTableModel(offerSection);
        break;
    }
  }

  _parseOfferInfo() {
    if (responseBody["offer_info"] != null) {
      return responseBody["offer_info"]["title"] == null
          ? ""
          : responseBody["offer_info"]["title"].toString();
    }
    return "";
  }

  void _parseOfferDetails() {
    List<String> data = offerText.isNotEmpty ? offerText.split('|') : [];

    /// we are using the length greater than 1 as we only need 2 variables here. the sub title is not required
    if (data.isNotEmpty && data.length > 1) {
      processingFeeModel = ProcessingFeeModel(
          offerFirstHeaderTitle: data[_offerFirstTextIndex],
          offerSecondHeaderTitle: data[_offerSecondTextIndex],
          offerHeaderSubTitle: '');
    } else {
      processingFeeModel = null;
    }
  }

  void _computeInfoText() {
    String lpc = LPCService.instance.activeCard?.loanProductCode ?? "";
    switch (AppFunctions().computeLoanProductCode(lpc)) {
      case LoanProductCode.clp:
        break;
      case LoanProductCode.sbl:
      case LoanProductCode.upl:
      case LoanProductCode.sbd:
        _parseInfoText();
        break;
      default:
        break;
    }
  }

  void _parseInfoText() {
    if (LPCService.instance.activeCard?.lpcCardType != LPCCardType.topUp) {
      infoText =
          "Broken Period Interest (BPI) & Annual Percentage Rate (APR) are calculated as on current date. They are subject to change as per actual disbursement date";
    } else {
      infoText = '';
    }
  }
}

class VasDetails {
  late final String provider;
  late final String vasType;
  late final double serviceFee;
  late final String tenure;
  late final List<Clauses> clauses;
  late final List<String> productBenefits;
  late final int vasId;
  bool isChecked = true;
  late double netDisbursalAmount = 0;

  VasDetails.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    vasType = json['vasType'];
    serviceFee = json['serviceFee'];
    tenure = json['tenure'];
    clauses =
        List.from(json['clauses']).map((e) => Clauses.fromJson(e)).toList();
    productBenefits = json['productBenefits'].cast<String>();
    vasId = json['vasId'];
  }

  Widget computeKnowMoreBottomSheetWidget() {
    return CrossSellBreakDownWidget(
      productBenefitList: productBenefits,
      title: '',
      knowMoreClicked: true,
    );
  }

  double computeNetDisbursalAmount() {
    return isChecked ? serviceFee : 0;
  }

  List<OfferTableModel> initHealthcareDetailsItemList() {
    return [
      OfferTableModel(title: "Package Tenure", value: "$tenure months"),
      OfferTableModel(
        title: "Healthcare Service Fee",
        value: AppFunctions.getIOFOAmount(serviceFee),
      ),
    ];
  }
}

class OfferSection {
  late final double interest;
  late final double limitAmount;
  late final String offerStatus;
  late final double minTenure;
  late final double maxTenure;
  late final String processingFee;
  late final String docHandlingFee;
  late final String emi;
  late final String insurance;
  late final String roi;
  late final String loanAmount;
  late final String tenure;
  late final String netDisbursalAmount;
  late final String apr;
  late final String bpiAmount;
  late final double topUpAmount;
  late final double outStandingBalance;

  OfferSection.fromJson(Map<String, dynamic> json) {
    interest = json['interest'] == null
        ? 0
        : double.parse(json['interest'].toString());
    limitAmount = json['limitAmount'] == null
        ? 0
        : double.parse(json['limitAmount'].toString());
    processingFee =
        json['processFee'] == null ? "0" : json['processFee'].toString();
    docHandlingFee = json['docHandlingFee'] == null
        ? "0"
        : json['docHandlingFee'].toString();
    minTenure = json['minTenure'] == null
        ? 0
        : double.parse(json['minTenure'].toString());
    maxTenure = json['maxTenure'] == null
        ? 0
        : double.parse(json['maxTenure'].toString());
    offerStatus = json['offerStatus'] ?? json['status'] ?? "";

    emi = json['emi'] == null ? "0" : json['emi'].toString();

    insurance = json['insurance'] == null ? "0" : json['insurance'].toString();

    roi = json['roi'] == null ? "0" : json['roi'].toString();

    loanAmount =
        json['loanAmount'] == null ? "0" : json['loanAmount'].toString();

    tenure = json['tenure'] == null ? "0" : json['tenure'].toString();
    netDisbursalAmount = json['netDisbursalAmount'] == null
        ? "0"
        : json['netDisbursalAmount'].toString();
    bpiAmount = json['bpiAmount'] == null ? "0" : json['bpiAmount'].toString();
    apr = json['apr'] == null ? "0" : json['apr'].toString();
    topUpAmount = double.parse(json['topUpAmount'] ?? "0");
    outStandingBalance =
        double.parse(json['outstandingBalance'] ?? "0");
  }
}

class InsuranceDetails {
  late final String provider;
  late final String sumInsured;
  late final String premiumAmount;
  late final String tenure;
  late final List<Clauses> clauses;
  late final List<String> productBenefits;
  bool isChecked = true;
  late double netDisbursalAmount = 0;

  InsuranceDetails.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    sumInsured = json['sumInsured'];
    premiumAmount = json['premiumAmount'];
    tenure = json['tenure'];
    clauses =
        List.from(json['clauses']).map((e) => Clauses.fromJson(e)).toList();
    productBenefits = json['productBenefits'].cast<String>();
  }

  Widget computeKnowMoreBottomSheetWidget() {
    return CrossSellBreakDownWidget(
      productBenefitList: productBenefits,
      title: '',
      knowMoreClicked: true,
    );
  }

  double computeNetDisbursalAmount() {
    return isChecked ? double.parse(premiumAmount) : 0;
  }

  List<OfferTableModel> initInsuranceDetailsItemList() {
    return [
      OfferTableModel(title: "Insurance Tenure", value: "$tenure months"),
      OfferTableModel(
        title: "Sum Insured",
        value: AppFunctions.getIOFOAmount(double.parse(sumInsured)),
      ),
      OfferTableModel(
        title: "Insurance Premium",
        value: AppFunctions.getIOFOAmount(double.parse(premiumAmount)),
      ),
    ];
  }
}

class Clauses {
  late final String title;
  late final List<RichTextModel> info;

  Clauses.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    info =
        List.from(json['info']).map((e) => RichTextModel.fromJson(e)).toList();
  }
}
