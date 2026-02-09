import 'package:intl/intl.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/model/key_metric.dart';
import '../../../utils/app_functions.dart';
import '../credit_report_helper_mixin.dart';

/// 000 - Paid, XXX - notAvailable, any no like 030 is unpaid, no data is none
enum TransactionHistoryDataType {
  none,
  notAvailable,
  paid,
  unpaid;

  static TransactionHistoryDataType fromString(String type) {
    /// From API response, we get Paid, Unpaid, Not Available only, if we dont get anything then it is none
    Map<String, TransactionHistoryDataType> mapping = {
      "Paid": TransactionHistoryDataType.paid,
      "Unpaid": TransactionHistoryDataType.unpaid,
      "Not Available": TransactionHistoryDataType.notAvailable,
    };
    return mapping[type] ?? TransactionHistoryDataType.notAvailable;
  }
}

enum CreditAccountStatus {
  active,
  closed;

  static CreditAccountStatus fromString(String status) {
    switch (status) {
      case "Closed":
        return CreditAccountStatus.closed;
      default:
        return CreditAccountStatus.active;
    }
  }
}

class CreditReport {
  late List<CreditAccount> accounts;
  Map<int, CreditAccount> creditAccountMap = {};
  int nActiveAccount = 0;
  int nClosedAccount = 0;
  late int score;
  Map<CreditInfoType, KeyMetricModel> keyMetricInfos = {};
  late final String NA_TEXT = "-";

  AppFunctions appFunctions = AppFunctions();

  CreditReport.fromJson(Map<String, dynamic> json) {
    json = json['report'];
    score = int.parse(json['credit_score']);

    accounts = [];

    List rawCreditAccounts = json['credit_overview'];

    for (var acc in rawCreditAccounts) {
      CreditAccount account = CreditAccount.fromJson(acc);
      accounts.add(account);
      creditAccountMap[account.accountSerialNumber] = account;
      if (account.isLoanClosed) {
        nClosedAccount += 1;
      } else {
        nActiveAccount += 1;
      }
    }

    _parseOnTimePayments(json['credit_analytics']['on_time_payments']);
    _parseCreditUtilization(json['credit_analytics']['credit_utilisation']);
    _parseCreditMix(json['credit_analytics']['credit_mix']);
    _parseCreditEnquiry(json['credit_analytics']['credit_enquiry']);
    _parseCreditAge(json['credit_analytics']['credit_age']);
  }

  _parseCreditAge(Map<String, dynamic> json) {
    keyMetricInfos[CreditInfoType.creditAge] = KeyMetricModel(
      keyMetrics: [],
      value: json['oldest_credit'],
      remarks: RemarkType.fromString(json['remarks']),
      keyMetricCreditAccountDetails: (json['loans'] as List).map((account) {
        int accountSerialNumber = account['serial_number'];
        return KeyMetricCreditAccountDetails(
          accountSerialNumber: accountSerialNumber,
          accountType: creditAccountMap[accountSerialNumber]!.accountName,
          lenderName: creditAccountMap[accountSerialNumber]!.lenderName,
          firstDataPoint: "${account['age']}",
          secondDataPoint: "",
        );
      }).toList(),
    );
  }

  _parseCreditEnquiry(Map<String, dynamic> json) {
    keyMetricInfos[CreditInfoType.creditEnquiries] = KeyMetricModel(
      keyMetrics: [],
      value: json['count'].toString(),
      remarks: RemarkType.fromString(json['remarks']),
      keyMetricCreditAccountDetails: (json['loans'] as List)
          .map((account) => KeyMetricCreditAccountDetails(
                accountSerialNumber: account['serial_number'],
                accountType: account['enquiry_reason'] ?? "",
                lenderName: account['subscriber_name'] ?? "",
                firstDataPoint: "${account['date_of_request']}",
                secondDataPoint: "at ${account['report_time']}",
              ))
          .toList(),
    );
  }

  _parseOnTimePayments(Map<String, dynamic> json) {
    keyMetricInfos[CreditInfoType.onTimePayments] = KeyMetricModel(
      keyMetrics: [
        KeyMetric(
            name: "On-time payment", value: "${json['on_time'] ?? NA_TEXT}"),
        KeyMetric(name: "Total Payment", value: "${json['total'] ?? NA_TEXT}"),
      ],
      value: "${json['percentage']}",
      remarks: RemarkType.fromString(json['remarks']),
      keyMetricCreditAccountDetails: (json['loans'] as List).map((account) {
        int accountSerialNumber = account['serial_number'];
        return KeyMetricCreditAccountDetails(
          accountSerialNumber: accountSerialNumber,
          accountType: creditAccountMap[accountSerialNumber]!.accountName,
          lenderName: creditAccountMap[accountSerialNumber]!.lenderName,
          firstDataPoint: "${account['on_time']}/${account['total']}",
          secondDataPoint: "on-time",
        );
      }).toList(),
    );
  }

  _parseCreditUtilization(Map<String, dynamic> json) {
    keyMetricInfos[CreditInfoType.creditUtilisation] = KeyMetricModel(
      keyMetrics: [
        KeyMetric(
          name: "Total Utilised Credit",
          value: appFunctions.parseNumberToCommaFormatWithRupeeSymbol(
              json['total_credit_utilised']),
        ),
        KeyMetric(
          name: "Total Credit Limit",
          value: appFunctions.parseNumberToCommaFormatWithRupeeSymbol(
              json['total_credit_limit']),
        ),
      ],
      value: "${json['percentage']}",
      remarks: RemarkType.fromString(json['remarks']),
      keyMetricCreditAccountDetails: (json['loans'] as List).map((account) {
        int accountSerialNumber = account['serial_number'];
        return KeyMetricCreditAccountDetails(
          accountSerialNumber: accountSerialNumber,
          accountType: creditAccountMap[accountSerialNumber]!.accountName,
          lenderName: creditAccountMap[accountSerialNumber]!.lenderName,
          firstDataPoint:
              "${appFunctions.parseNumberToCommaFormatWithRupeeSymbol(account['credit_utilised'])}/${appFunctions.parseNumberToCommaFormatWithRupeeSymbol(account['credit_limit'])}",
          secondDataPoint: "${account['percentage']}%",
        );
      }).toList(),
    );
  }

  _parseCreditMix(Map<String, dynamic> json) {
    keyMetricInfos[CreditInfoType.creditMix] = KeyMetricModel(
      keyMetrics: [
        KeyMetric(
          name: "Unsecured",
          value: "${json['unsecured_loan'] ?? NA_TEXT}",
        ),
        KeyMetric(
          name: "Secured",
          value: "${json['secured_loan'] ?? NA_TEXT}",
        ),
      ],
      value: "${json['percentage']}",
      remarks: RemarkType.fromString(json['remarks']),
      keyMetricCreditAccountDetails: [],
    );
  }
}

class CreditAccount {
  late final int accountSerialNumber;
  late final String lenderName;
  late final CreditAccountType accountType;
  late final String accountName;
  late final String updatedOn;
  late final String sanctionAmountText;
  late final double? sanctionAmount;
  late final String amountToBePaidText;
  late final double? amountToBePaid;
  late final String limitUtilizedText;
  late final double? limitUtilizedPercent;
  late final String creditCardUtilizationPercentText;
  late DateTime paymentHistoryStartDate = DateTime.now();
  late DateTime paymentHistoryEndDate = DateTime.now();
  late final String repaymentTenureText;
  late final String issuedOn;
  late final bool isLoanClosed;
  late final String emi;
  late final bool isLimitDetailsAvailable;
  late final bool isCreditCard;
  late final String dateClosedText;
  late final bool isAnyValueNotAvailable;

  late final String NA_TEXT = "-";
  final int nMonths = 12;

  /// if any one of the data is not available then set this to true
  bool isTransactionHistoryNotAvailable = false;
  Map<int, List<TransactionHistoryDataType>> tableData = {};

  CreditAccount.fromJson(Map<String, dynamic> json) {
    AppFunctions appFunctions = AppFunctions();

    accountSerialNumber = json['serial_number'];
    lenderName = json['subscriber_name'] ?? "";
    accountName = json['account_name'] ?? "Loan";
    String loanTypeName = json['loan_type'] ?? "";
    accountType = CreditAccountType.fromString(loanTypeName);
    isCreditCard = (accountType == CreditAccountType.creditCard);

    Map loanDetails = json['loan_details'];

    int? emiAmount = int.tryParse(loanDetails['emi_amount'] ?? "");
    emi = appFunctions.parseNumberToCommaFormatWithRupeeSymbol(emiAmount);

    String? dateOpened = loanDetails['issued_on'];
    DateTime? dateOpenedDateTime =
        dateOpened == null ? null : DateTime.parse(dateOpened);
    issuedOn = dateOpenedDateTime == null
        ? NA_TEXT
        : DateFormat("dd MMM ''yy").format(dateOpenedDateTime);

    String? dateClosed = loanDetails['date_closed'];
    DateTime? dateClosedDateTime = dateClosed != null && dateClosed.isNotEmpty
        ? DateTime.parse(dateClosed)
        : null;
    dateClosedText = dateClosedDateTime == null
        ? NA_TEXT
        : DateFormat("dd MMM ''yy").format(dateClosedDateTime);

    isLoanClosed = CreditAccountStatus.fromString(json['loan_status']) ==
        CreditAccountStatus.closed;

    String? dateReportedAndCertified = json['bureau_updated'];
    updatedOn = dateReportedAndCertified == null
        ? NA_TEXT
        : DateFormat('dd MMMM, yyyy \'at\' hh:mm a')
            .format(DateTime.parse(dateReportedAndCertified));

    sanctionAmount = double.tryParse(loanDetails['total_limit']);
    sanctionAmountText =
        appFunctions.parseNumberToCommaFormatWithRupeeSymbol(sanctionAmount);

    amountToBePaid = double.tryParse(loanDetails['balance'] ?? "");

    amountToBePaidText =
        appFunctions.parseNumberToCommaFormatWithRupeeSymbol(amountToBePaid);

    Map<String, dynamic>? utilizationDetails = loanDetails['utilization'];
    double? limitUtilized = null;
    if (utilizationDetails != null) {
      limitUtilizedPercent = double.tryParse(utilizationDetails['percentage']);
      limitUtilized = double.tryParse(utilizationDetails['used_limit']);
    }
    isLimitDetailsAvailable = !(limitUtilizedPercent == null ||
        limitUtilized == null ||
        sanctionAmount == null);
    if (isLimitDetailsAvailable) {
      limitUtilizedText =
          appFunctions.parseNumberToCommaFormatWithRupeeSymbol(limitUtilized);
      creditCardUtilizationPercentText = "$limitUtilizedPercent%";
    } else {
      limitUtilizedText = NA_TEXT;
      creditCardUtilizationPercentText = "";
    }

    int? repaymentTenure = int.tryParse(loanDetails['tenure'] ?? "");
    repaymentTenureText =
        repaymentTenure == null ? NA_TEXT : "$repaymentTenure months";

    if (isCreditCard) {
      isAnyValueNotAvailable = sanctionAmount == null ||
          amountToBePaid == null ||
          issuedOn == NA_TEXT ||
          limitUtilizedText == NA_TEXT;
    } else {
      isAnyValueNotAvailable = sanctionAmount == null ||
          amountToBePaid == null ||
          repaymentTenure == null ||
          issuedOn == NA_TEXT ||
          emiAmount == null;
    }

    List accountHistory = json['payment_history'] ?? [];

    if (accountHistory.isNotEmpty) {
      // startdate is last data of history and enddate is first data
      // Todo: revisit to check for optimisation
      PaymentHistory firstPaymentHistory =
          PaymentHistory.fromJson(accountHistory.last);
      PaymentHistory lastPaymentHistory =
          PaymentHistory.fromJson(accountHistory.first);
      paymentHistoryStartDate =
          DateTime(firstPaymentHistory.year, firstPaymentHistory.month);
      paymentHistoryEndDate =
          DateTime(lastPaymentHistory.year, lastPaymentHistory.month);

      for (var year = paymentHistoryStartDate.year;
          year <= paymentHistoryEndDate.year;
          year++) {
        tableData[year] = List.filled(nMonths, TransactionHistoryDataType.none);
      }

      for (var history in accountHistory) {
        PaymentHistory paymentHistory = PaymentHistory.fromJson(history);
        if (paymentHistory.type == TransactionHistoryDataType.notAvailable) {
          isTransactionHistoryNotAvailable = true;
        }
        tableData[paymentHistory.year]![paymentHistory.month - 1] =
            paymentHistory.type;
      }
    }
  }
}

class PaymentHistory {
  late int month;
  late int year;
  late TransactionHistoryDataType type;

  PaymentHistory.fromJson(Map<String, dynamic> json) {
    month = int.parse(json['month']);
    year = int.parse(json['year']);
    type = TransactionHistoryDataType.fromString(json['status'] ?? "");
  }
}
