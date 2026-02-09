import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:get/get_core/src/get_main.dart';

import '../modules/home_screen_module/widgets/alert/home_page_alert_widget_logic.dart';

///Model to parse the response from customer loan details. This api returns all the
///available loans under a particular customer id
LoansModel LoansModelFromJson(ApiResponse apiResponse) {
  return LoansModel.decodeResponse(apiResponse);
}

///Class to parse loans of customers that are got by the api call.
class LoansModel {
  LoansModel({
    required this.customerId,
    required this.activeLoans,
    required this.closedLoans,
  });

  late final String customerId;
  late final List<Loans> activeLoans;
  late final List<Loans> closedLoans;
  late final ApiResponse apiResponse;
  List<Loans> overdueLoans = [];
  List<Loans> advanceEMILoans = [];
  HomePageCard homePageCard = HomePageCard.none;

  LoansModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          _computeHomePageCard();
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Pending loan details exception ${e.toString()}");
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
    customerId = json['customerId'];
    activeLoans = json['activeLoans'] == null
        ? []
        : List.from(json['activeLoans']).map((e) {
            if (e['LoanPaymentStatus'] == "Overdue" || e['LoanPaymentStatus'] == "Pending") {
              overdueLoans.add(Loans.fromJson(e));
            }
            if (e['LoanPaymentStatus'] == "AdvanceEMI") {
              advanceEMILoans.add(Loans.fromJson(e));
            }
            return Loans.fromJson(e);
          }).toList();
    closedLoans = json['closedLoans'] == null
        ? []
        : List.from(json['closedLoans']).map((e) => Loans.fromJson(e)).toList();
  }

  ///To parse json from model
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['customerId'] = customerId;
    _data['activeLoans'] = activeLoans.map((e) => e.toJson()).toList();
    _data['closedLoans'] = closedLoans;
    return _data;
  }

  void _computeHomePageCard() {
    if (overdueLoans.isNotEmpty) {
      homePageCard = HomePageCard.overdue;
    } else if (advanceEMILoans.isNotEmpty) {
      homePageCard = HomePageCard.advanceEMI;
    } else {
      homePageCard = HomePageCard.none;
    }
  }
}

enum LoanPaymentStatus { overdue, advanceEMI, pendingAmount,none }

///Returns the active loans of the customer from the response of all customer loans
class Loans {
  Loans({
    required this.loanId,
    required this.interestRate,
    required this.loanAmount,
    required this.loanProductCode,
    required this.loanTenure,
    required this.loanEndDate,
    required this.nextRepayDate,
    required this.active,
    required this.isInsured,
    required this.loanPaymentStatus,
    required this.dpd,
    required this.appFormId
  });

  late final String loanId;
  late final int interestRate;
  late final String loanAmount;
  late final String loanProductCode;
  late final int loanTenure;
  late final String loanEndDate;
  late final String nextRepayDate;
  late final bool active;
  late final bool isInsured;
  late final LoanPaymentStatus loanPaymentStatus;
  late final String dpd;
  late final String appFormId;

  ///To parse model from json
  Loans.fromJson(Map<String, dynamic> json) {
    loanId = json['loanId'];
    interestRate = json['interestRate'];
    loanAmount = "${json['loanAmount']}";
    loanProductCode = json['loanProductCode'];
    loanTenure = json['loanTenure'];
    loanEndDate = dateFormatterOfLoansEndDate(json['loanEndDate']);
    nextRepayDate = dateFormatterFunc(json['nextRepayDate'] ?? "");
    active = json['active'];
    isInsured = json['isInsured'];
    dpd = json['dpd'] ?? "";
    appFormId = json['appFormId'] ?? "";
    _computeLoanPaymentStatus(json['LoanPaymentStatus'] ?? "");
  }

  ///To parse model to json
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loanId'] = loanId;
    _data['interestRate'] = interestRate;
    _data['loanAmount'] = loanAmount;
    _data['loanProductCode'] = loanProductCode;
    _data['loanTenure'] = loanTenure;
    _data['loanEndDate'] = loanEndDate;
    _data['nextRepayDate'] = nextRepayDate;
    _data['active'] = active;
    _data['isInsured'] = isInsured;
    return _data;
  }

  String dateFormatterFunc(String datetime) {
    final DateFormat formatter = DateFormat('dd/MM/yy');
    DateTime dateTime = formatter.parse(datetime);
    return Jiffy.parseFromDateTime(dateTime).format(pattern: "do MMM yyyy");
  }

  String dateFormatterOfLoansEndDate(String datetime) {
    final DateFormat formatter = DateFormat('dd/MM/yy');
    DateTime dateTime = formatter.parse(datetime);
    return Jiffy.parseFromDateTime(dateTime).format(pattern: "yyyy-MM-dd");
  }

  void _computeLoanPaymentStatus(String loanPaymentStatusValue) {
    Map<String, LoanPaymentStatus> loanPaymentStatusMap = {
      "Overdue": LoanPaymentStatus.overdue,
      "AdvanceEMI": LoanPaymentStatus.advanceEMI,
      "Pending": LoanPaymentStatus.pendingAmount,
      "": LoanPaymentStatus.none,
    };
    loanPaymentStatus =
        loanPaymentStatusMap[loanPaymentStatusValue] ?? LoanPaymentStatus.none;
  }
}
