import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../modules/payment/payment_view.dart';

enum LoanStatus { active, closed }

enum ElasticCreditLineType { pure, hybrid, drop, none }

enum PaymentTypeStatus { eligible, nonEligible, unAvailable }

enum EmiPaymentStatus { inProgress, closed, nextEmi }

LoanDetailsModel loanDetailModelFromJson(ApiResponse apiResponse) {
  return LoanDetailsModel.decodeResponse(apiResponse);
}

class LoanDetailsModel {
  late final String loanId;
  late final String loanAmount;
  late final String loanStartDate;
  late final int tenure;
  late final String roi;
  late final String loanEndDate;
  late final String nextDueDate;
  late final String emiAmount;
  late final String principalOutstanding;
  late final String totalPrincipalPaid;
  late final String totalInterestPaid;
  late final String bpiAmount;
  late final String overdueEmiDate;
  late final String overduePrincipal;
  late final String overdueInterest;
  late final String totalPendingAmount;
  late final String latePaymentPenaltyInterest;
  late final String latePaymentPenalty;
  late final String unappliedAmount;
  late final String bounceCharges;
  late final int emiPaid;
  late final int emiTotal;
  late final int emiPending;
  late final int overdueInst;
  late final String disbursalAmount;
  late final String processingFee;
  late final String docHandlingFee;
  late final String totalRepayAmt;
  late final String apr;
  late final String emiPaidEmiTotal;
  late final String totalProfit;
  late final String monthsOrDaysAgoLoanTaken;
  late ApiResponse apiResponse;
  late final bool isForeClosureEnabled;
  late final PaymentType paymentType;
  late final String paymentTypeString;
  late final bool showAdvanceEmi;
  late final bool showForecloseLoan;
  late final bool isLoanCancellationEnabled;
  late final bool paymentHistoryEnabled;
  late final bool isPartPayEnabled;
  late final String appFormId;
  String dpd = "";
  late final LoanStatus loanStatus;
  double? sanctionedAmount;
  late ElasticCreditLineType elasticCreditLineType;
  static const String activeStatus = "ACTIVE";
  static const String closedStatus = "CLOSED";
  late final bool isPendingPayment;
  late final PaymentTypeDetails foreClosurePaymentTypeDetails;
  late final PaymentTypeDetails advanceEMIPaymentTypeDetails;
  late final PaymentTypeDetails overduePaymentTypeDetails;
  late final EmiPaymentStatus isEmiPaymentInProgress;
  late final TotalPayable totalPayable;

  LoanDetailsModel.decodeResponse(ApiResponse apiResponse) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          _parseJson(apiResponse);
          this.apiResponse = apiResponse..state = ResponseState.success;
        } catch (e) {
          Get.log("Loan details exception ${e.toString()}");
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
    loanId = json['loanId'];
    loanAmount = json['loanAmount'];
    loanStartDate = json['loanStartDate'];
    tenure = json['tenure'];
    roi = json['roi'] != null
        ? AppFunctions().normalizeNumberString(json['roi'])
        : "-";
    loanEndDate = json['loanEndDate'];
    nextDueDate = json['nextDueDate'];
    emiAmount = json['emiAmount'];
    principalOutstanding = json['principalOutstanding'];
    totalPrincipalPaid = json['totalPrincipalPaid'];
    totalInterestPaid = json['totalInterestPaid'];
    bounceCharges = json['bounceCharges'] ?? "";
    bpiAmount = json['bpiAmount'];
    overdueInterest = json['overdueInterest'] ?? "";
    overdueEmiDate = json['overdueEmiDate'] ?? "";
    overduePrincipal = json['overduePrincipal'] ?? "";
    latePaymentPenaltyInterest = json['latePaymentPenaltyInterest'] ?? "";
    latePaymentPenalty = json['latePaymentPenalty'] ?? "";
    unappliedAmount = json['unappliedAmount'] ?? "0";
    totalPendingAmount = json['totalPendingAmount'];
    emiTotal = int.parse(json['emiTotal']);
    emiPaid = int.parse(json['emiPaid']);
    emiPending = emiTotal - emiPaid;
    overdueInst = json['overdueInst'];
    disbursalAmount = json['disbursalAmount'];
    processingFee = json['processingFee'];
    docHandlingFee = _getDocHandlingFee(json);
    totalRepayAmt = json['totalRepayAmt'];
    apr = _computeApr(json['apr']);
    totalProfit = json['totalProfit'];
    paymentTypeString = json['paymentType'] ?? "";
    isForeClosureEnabled = json['isForeClosureEnabled'] ?? false;
    showAdvanceEmi = json['showAdvanceEmi'] ?? false;
    showForecloseLoan = json['showForecloseLoan'] ?? false;
    monthsOrDaysAgoLoanTaken = _computeMonthsOrDayAgoLoanTaken();
    _computePaymentType(json['paymentType'] ?? "");
    isLoanCancellationEnabled = json['isLoanCancellationEnabled'] ?? false;
    paymentHistoryEnabled = json['paymentHistoryEnabled'] ?? false;
    loanStatus = _computeLoanStatus(json["loanStatus"]);
    sanctionedAmount = json['sanctionAmount'].toString().isNotEmpty
        ? double.parse(json['sanctionAmount'].toString())
        : null;
    elasticCreditLineType =
        computeElasticCreditLineType(json['elasticCreditLineType'] ?? "");
    isPartPayEnabled = json["isPartPaymentEnabled"];
    appFormId = json['appFormId'];

    foreClosurePaymentTypeDetails =
        PaymentTypeDetails.fromJson(json['foreclose']);
    advanceEMIPaymentTypeDetails = PaymentTypeDetails.fromJson(json['advance']);
    overduePaymentTypeDetails = PaymentTypeDetails.fromJson(json['overdue']);
    isPendingPayment = _computeIsPending();
    isEmiPaymentInProgress = _computeIsEmiPaymentInProgress();
    totalPayable = _calculateAmountPayable();
  }

  _computeIsPending() {
    if (overduePaymentTypeDetails.type == PaymentTypeStatus.eligible) {
      return (overduePrincipal.isEmpty && overdueInterest.isEmpty) ||
          (num.parse(overduePrincipal) == 0 && num.parse(overdueInterest) == 0);
    }
    return false;
  }

  computeElasticCreditLineType(String elasticClType) {
    switch (elasticClType) {
      case "D":
        return ElasticCreditLineType.drop;
      case "P":
        return ElasticCreditLineType.pure;
      case "H":
        return ElasticCreditLineType.hybrid;
      case "":
        return ElasticCreditLineType.none;
    }
  }

  String _getDocHandlingFee(Map<String, dynamic> json) {
    final docHandlingFee = json['docHandlingFee'];
    return docHandlingFee == null || docHandlingFee.toString().isEmpty
        ? "0"
        : docHandlingFee.toString();
  }

  _computeLoanStatus(String loanStatusString) {
    switch (loanStatusString) {
      case activeStatus:
        return LoanStatus.active;
      case closedStatus:
        return LoanStatus.closed;
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['loanId'] = loanId;
    _data['loanAmount'] = loanAmount;
    _data['loanStartDate'] = loanStartDate;
    _data['tenure'] = tenure;
    _data['roi'] = roi;
    _data['loanEndDate'] = loanEndDate;
    _data['nextDueDate'] = nextDueDate;
    _data['emiAmount'] = emiAmount;
    _data['principalOutstanding'] = principalOutstanding;
    _data['totalPrincipalPaid'] = totalPrincipalPaid;
    _data['totalInterestPaid'] = totalInterestPaid;
    _data['bpiAmount'] = bpiAmount;
    _data['overdueEmiDate'] = overdueEmiDate;
    _data['overduePrincipal'] = overduePrincipal;
    _data['overdueInterest'] = overdueInterest;
    _data['totalPendingAmount'] = totalPendingAmount;
    _data['emiTotal'] = emiPaidEmiTotal;
    _data['disbursalAmount'] = disbursalAmount;
    _data['processingFee'] = processingFee;
    _data['totalRepayAmt'] = totalRepayAmt;
    _data['apr'] = apr;
    _data['totalProfit'] = totalProfit;
    return _data;
  }

  _computeMonthsOrDayAgoLoanTaken() {
    DateTime givenDate = DateFormat("yyyy-MM-DD").parse(loanStartDate);
    return AppFunctions().computeMonthsOrDayAgoLoanTaken(givenDate);
  }

  String _computeApr(String? apr) {
    if (apr != null && apr.isNotEmpty) {
      return "${AppFunctions().normalizeNumberString(apr)}%";
    } else {
      return '-';
    }
  }

  void _computePaymentType(String paymentTypeValue) {
    switch (paymentTypeValue.toLowerCase()) {
      case "overdue":
        paymentType = PaymentType.overdue;
        break;
      case "advance":
        paymentType = PaymentType.advanceEmi;
        break;
      case "foreclose":
        paymentType = PaymentType.foreclosure;
        break;
      case "partpay":
        paymentType = PaymentType.partPay;
        break;
      default:
        paymentType = PaymentType.none;
    }
  }

  EmiPaymentStatus _computeIsEmiPaymentInProgress() {
    if (loanStatus == LoanStatus.closed) return EmiPaymentStatus.closed;
    try {
      final parsedLoanEndDate = DateTime.parse(loanEndDate);
      final inputDate = DateTime.parse(nextDueDate);

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));

      if (today.isAfter(parsedLoanEndDate)) {
        return EmiPaymentStatus.closed;
      }

      if (inputDate.isAtSameMomentAs(today) ||
          inputDate.isAtSameMomentAs(tomorrow)) {
        return EmiPaymentStatus.inProgress;
      }

      return EmiPaymentStatus.nextEmi;
    } catch (e) {
      Get.log("Error parsing date: $e");
      return EmiPaymentStatus.closed;
    }
  }

  TotalPayable _calculateAmountPayable() {
    final double principalNum = double.tryParse(loanAmount) ?? 0.0;
    final double interestNum = double.tryParse(totalProfit) ?? 0.0;
    final double principalPaidNum = double.tryParse(totalPrincipalPaid) ?? 0.0;
    final double interestPaidNum = double.tryParse(totalInterestPaid) ?? 0.0;

    final double totalAmountPayable = principalNum + interestNum;
    final double amountPaid = principalPaidNum + interestPaidNum;
    final double amountPayable = totalAmountPayable - amountPaid;

    return TotalPayable(totalAmountPayable: totalAmountPayable, amountPaid: amountPaid, amountPayable: amountPayable);
  }
}

class TotalPayable {
  final double totalAmountPayable;
  final double amountPaid;
  final double amountPayable;

  TotalPayable({
    required this.totalAmountPayable,
    required this.amountPaid,
    required this.amountPayable,
  });
}

class PaymentTypeDetails {
  late PaymentTypeStatus type;
  late String title;
  late String message;
  late String? startDate;
  late String? endDate;

  PaymentTypeDetails.fromJson(Map<String, dynamic> json) {
    type = _computeType(json['type']);
    title = json['title'];
    message = json['message'];
    startDate = _parseDateTime(json['startDate']);
    endDate = _parseDateTime(json['endDate']);
  }

  _computeType(String typeValue) {
    switch (typeValue.toLowerCase()) {
      case "eligible":
        return PaymentTypeStatus.eligible;
      case "unavailable":
        return PaymentTypeStatus.unAvailable;
      default:
        return PaymentTypeStatus.nonEligible;
    }
  }

  _parseDateTime(String inputDateString) {
    if (inputDateString.isEmpty) return null;
    DateTime dateTime = DateTime.parse(inputDateString);
    DateFormat outputFormat = DateFormat("dd MMM ’yy");
    return outputFormat.format(dateTime);
  }
}
