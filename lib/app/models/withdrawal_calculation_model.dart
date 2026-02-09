import 'dart:convert';

import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/pre_approval_offer_model.dart';
import 'package:privo/res.dart';

WithdrawalCalculationResponseModel withdrawalCalculationResponseModelFromJson(
    ApiResponse apiResponse) {
  return WithdrawalCalculationResponseModel.decodeResponse(apiResponse);
}

class WithdrawalCalculationResponseModel extends CheckAppFormModel {
  late Map<String, dynamic> calculationResponseBody;
  late WithdrawalCalculationModel withdrawalCalculationModel;

  WithdrawalCalculationResponseModel.decodeResponse(ApiResponse apiResponse)
      : super.decodeResponse(apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          this.apiResponse = apiResponse
            ..state = ResponseState.jsonParsingError
            ..exception = e.toString();
        }
        break;
      default:
        this.apiResponse = apiResponse;
    }
  }

  _parseJson(ApiResponse apiResponse) {
    Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
    Map<String, dynamic> jsonMap = json['responseBody'];
    calculationResponseBody = jsonMap;
    withdrawalCalculationModel = WithdrawalCalculationModel.fromJson(jsonMap);
  }
}

class WithdrawalCalculationModel {
  late double? emiAmount;
  late double? interestAmount;
  late double? interestRate;
  late int? salaryDay;
  late double? disbursedAmount;
  late double? loanAmount;
  late int? processingFee;
  late double? bpi;
  late String? nextRepayDate;
  late String? modeOfPayment;
  late double? apr;
  late int? tenure;
  double? discountedProcessingFee;
  late String? promoName;
  late String? promoDesc;
  late String? promoSubText;
  late Map? processingFeeMap;

  final int _offerSecondPromoText = 1;
  final int _offerFirstPromoText = 0;

  late WithdrawalInsuranceDetails? insuranceDetails;
  late List<InsuranceWrapperResponse>? insuranceWrapperResponse;

  WithdrawalCalculationModel({
    this.emiAmount,
    this.interestAmount,
    this.interestRate,
    this.salaryDay,
    this.disbursedAmount,
    this.loanAmount,
    this.processingFee,
    this.tenure,
    this.bpi,
    this.nextRepayDate,
    this.modeOfPayment,
    this.discountedProcessingFee,
    this.promoDesc,
    this.promoName,
    this.promoSubText,
    this.processingFeeMap,
    this.apr,
    this.insuranceDetails,
    this.insuranceWrapperResponse,
  });

  WithdrawalCalculationModel.fromJson(Map<String, dynamic> jsonMap) {
    emiAmount = jsonMap['emiAmount'];
    interestAmount = jsonMap['interestAmount'];
    interestRate = double.parse("${jsonMap['interestRate']}");
    salaryDay = jsonMap['salaryDay'];
    disbursedAmount = jsonMap['disbursedAmount'];
    loanAmount = jsonMap['loanAmount'];
    processingFeeMap = jsonMap['processingFee'];
    processingFee = jsonMap['processingFee'] != null
        ? jsonMap['processingFee']['original_total_processing_fee']
        : null;
    bpi =
        jsonMap['bpi'] != null ? double.parse(jsonMap['bpi'].toString()) : null;
    nextRepayDate = jsonMap['nextRepayDate'];
    modeOfPayment = jsonMap['modeOfPayment'];
    discountedProcessingFee = jsonMap['processingFee'] != null &&
            jsonMap['processingFee']['discounted_total_processing_fee'] != null
        ? double.parse(jsonMap['processingFee']
                ['discounted_total_processing_fee']
            .toString())
        : null;

    apr = double.parse(jsonMap['apr'].toString());
    promoName = jsonMap['promo_name'] != null ? _parsePromoName(jsonMap) : "";
    promoDesc =
        jsonMap['promo_desc'] != null ? jsonMap['promo_desc'].toString() : "";
    promoSubText = jsonMap['promo_subtext'] != null
        ? jsonMap['promo_subtext'].toString()
        : "";
    tenure = jsonMap['tenure'];
    insuranceDetails = jsonMap['insuranceDetails'] == null
        ? null
        : WithdrawalInsuranceDetails.fromJson(jsonMap["insuranceDetails"]);
    insuranceWrapperResponse = jsonMap['insuranceWrapperResponse'] == null
        ? null
        : List<InsuranceWrapperResponse>.from(
            jsonMap["insuranceWrapperResponse"]
                .map((x) => InsuranceWrapperResponse.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        if (insuranceWrapperResponse != null)
          "insuranceWrapperResponse": List<dynamic>.from(
              insuranceWrapperResponse!.map((x) => x.toJson())),
      };

  String _parsePromoName(Map<String, dynamic> jsonMap) {
    List<String> data = jsonMap['promo_name'].toString().split('|');
    if (data.isNotEmpty && data.length == 3) {
      return data[_offerFirstPromoText] + data[_offerSecondPromoText];
    }
    return "";
  }
}

class WithdrawalInsuranceDetails {
  WithdrawalInsuranceDetails({
    required this.productCode,
    required this.insurancePlatform,
    required this.planCode,
    required this.policyDetails,
    required this.policyBenefits,
    required this.acceptanceClauses,
    required this.howTo,
    required this.customerSupportContacts,
    required this.premiumPerDay,
  });

  late final String productCode;
  late final String insurancePlatform;
  late final String planCode;
  late final List<PolicyDetails> policyDetails;
  late final List<PolicyBenefit> policyBenefits;
  late final List<Clauses> acceptanceClauses;
  late final List<String> howTo;
  late final CustomerSupportContacts customerSupportContacts;
  late final String premiumPerDay;

  WithdrawalInsuranceDetails.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    insurancePlatform = json['insurancePlatform'];
    planCode = json['planCode'];
    policyDetails = List.from(json['policy_details'])
        .map((e) => PolicyDetails.fromJson(e))
        .toList();
    policyBenefits = List.from(json['policy_benefits'])
        .map((e) => PolicyBenefit.fromJson(e))
        .toList();
    acceptanceClauses = List.from(json['acceptance_clauses'])
        .map((e) => Clauses.fromJson(e))
        .toList();
    howTo = List.castFrom<dynamic, String>(json['how_to']);
    customerSupportContacts =
        CustomerSupportContacts.fromJson(json['customer_support_contacts']);
    premiumPerDay = "${json['premium_per_day'] ?? ""}";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['productCode'] = productCode;
    _data['insurancePlatform'] = insurancePlatform;
    _data['planCode'] = planCode;
    _data['policy_details'] = policyDetails.map((e) => e.toJson()).toList();
    _data['policy_benefits'] = policyBenefits.map((e) => e.toJson()).toList();
    _data['how_to'] = howTo;
    _data['customer_support_contacts'] = customerSupportContacts.toJson();
    _data['premium_per_day'] = premiumPerDay;
    return _data;
  }
}

class PolicyDetails {
  PolicyDetails({
    required this.title,
    required this.text,
  });

  late final String title;
  late final String text;

  PolicyDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['text'] = text;
    return _data;
  }
}

class PolicyBenefit {
  PolicyBenefit({
    required this.benefitCode,
    required this.benefitTitle,
    required this.carouselText,
    required this.benefitDetails,
    required this.icon,
  });

  late final String benefitCode;
  late final String benefitTitle;
  late final String carouselText;
  late final List<String> benefitDetails;
  late final String icon;

  PolicyBenefit.fromJson(Map<String, dynamic> json) {
    benefitCode = json['benefit_code'];
    benefitTitle = json['benefit_title'];
    carouselText = json['carousel_text'];
    benefitDetails = List.castFrom<dynamic, String>(json['benefit_details']);
    icon = _computeIcon(benefitCode);
  }

  String _computeIcon(String benefitCode) {
    return _policyIconMap[benefitCode] ?? Res.benefit_one_svg;
  }

  Map<String, String> get _policyIconMap => {
        "CF": Res.policy_benefit_cf_svg,
        "JL": Res.policy_benefit_jl_svg,
        "FI": Res.policy_benefit_fi_svg,
        "HD": Res.policy_benefit_hd_svg,
        "FC": Res.policy_benefit_fc_svg,
        "PICOD": Res.policy_benefit_picod_svg,
        "PTD": Res.policy_benefit_ptd_svg,
        "HCB": Res.policy_benefit_hcb_svg,
        "PPD": Res.policy_benefit_ppd_svg,
        "CI": Res.policy_benefit_ci_svg,
        "MSP": Res.policy_benefit_msp_svg,
      };

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['benefit_code'] = benefitCode;
    _data['benefit_title'] = benefitTitle;
    _data['carousel_text'] = carouselText;
    _data['benefit_details'] = benefitDetails;
    return _data;
  }
}

class CustomerSupportContacts {
  CustomerSupportContacts({
    required this.phone,
    required this.email,
  });

  late final String phone;
  late final String email;

  CustomerSupportContacts.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phone'] = phone;
    _data['email'] = email;
    return _data;
  }
}

class InsuranceWrapperResponse {
  InsuranceWrapperResponse({
    required this.insurancePlatform,
    required this.planCode,
    required this.planName,
    required this.product,
    required this.basicPremium,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.ugst,
    required this.totalGST,
    required this.totalPremium,
  });

  late final String insurancePlatform;
  late final String planCode;
  late final String planName;
  late final String product;
  late final double basicPremium;
  late final double cgst;
  late final double sgst;
  late final double igst;
  late final double ugst;
  late final double totalGST;
  late final double totalPremium;

  InsuranceWrapperResponse.fromJson(Map<String, dynamic> json) {
    insurancePlatform = json['insurancePlatform'];
    planCode = json['planCode'];
    planName = json['planName'];
    product = json['product'];
    basicPremium = json['basicPremium'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
    ugst = json['ugst'];
    totalGST = json['totalGST'];
    totalPremium = json['totalPremium'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['insurancePlatform'] = insurancePlatform;
    _data['planCode'] = planCode;
    _data['planName'] = planName;
    _data['product'] = product;
    _data['basicPremium'] = basicPremium;
    _data['cgst'] = cgst;
    _data['sgst'] = sgst;
    _data['igst'] = igst;
    _data['ugst'] = ugst;
    _data['totalGST'] = totalGST;
    _data['totalPremium'] = totalPremium;
    return _data;
  }
}
