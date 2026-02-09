import 'dart:ui';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/experian_consent_model.dart';
import 'package:privo/app/modules/masked_credit_score/masked_number_analytics_mixin.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import '../../../res.dart';
import '../../data/repository/credit_report_repository.dart';
import 'model/key_benefits_model.dart';

enum CreditReportState {
  loading,
  knowMore,
  polling,
  success,
  failure,
  dashboard,
  accountDetails,
  creditOverview,
  keyMetricView,
  statelessKnowMore,
  scoreUpdateStatus
}

enum CreditScoreScale {
  poor(
    imagePath: Res.creditScorePoor,
    minScore: 300,
    maxScore: 579,
    title: "Poor",
    color: Color(0xFFEE3D4B),
    successScreenTitle: "A Fresh Start is Here!",
    details:
        "This is the lowest tier, suggesting a history of missed payments or credit problems. Qualifying for loans can be difficult, and interest rates will likely be very high.",
  ),
  fair(
    imagePath: Res.creditScoreLow,
    minScore: 580,
    maxScore: 669,
    title: "Fair",
    color: Color(0xFFFF919A),
    successScreenTitle: "You’re on the Right Path!",
    details:
        "This score indicates room for improvement. You may still qualify for loans, but interest rates might be higher.",
  ),
  good(
    imagePath: Res.creditScoreFair,
    minScore: 670,
    maxScore: 739,
    title: "Good",
    color: Color(0xFFF0C61C),
    successScreenTitle: "Your Score is Growing!",
    details:
        "This is a solid score, considered acceptable by most lenders. You may qualify for competitive interest rates, but they might not be the absolute best.",
  ),
  veryGood(
    imagePath: Res.creditScoreVeryGood,
    minScore: 740,
    maxScore: 799,
    title: "Very Good",
    color: Color(0xff5BC275),
    successScreenTitle: "One Step from the Top!",
    details:
        "This is a strong score, demonstrating a consistent track record of on-time payments and good credit habits. You will receive favourable interest rates and have access to a wide range of loan options",
  ),
  excellent(
    imagePath: Res.creditScoreExcellent,
    minScore: 800,
    maxScore: 900,
    title: "Excellent",
    successScreenTitle: "You’re a Credit Superstar!",
    color: Color(0xFF268E3A),
    details:
        "This is a top-tier score, showcasing exceptional credit management and a strong history of timely payments. With this score, you’ll qualify for the best interest rates and have access to premium loan options, giving you maximum financial flexibility and savings",
  );

  final String imagePath;
  final int minScore;
  final int maxScore;
  final String title;
  final Color color;
  final String details;
  final String successScreenTitle;

  const CreditScoreScale({
    required this.imagePath,
    required this.minScore,
    required this.maxScore,
    required this.title,
    required this.color,
    required this.details,
    required this.successScreenTitle,
  });
}

enum CreditAccountType {
  loan(title: "Loan", indexVal: 1),
  creditCard(title: "Credit Card", indexVal: 2);

  const CreditAccountType({required this.title, required this.indexVal});

  final String title;
  final int indexVal;

  static CreditAccountType fromString(String type) {
    switch (type) {
      case "Credit Card":
        return CreditAccountType.creditCard;
      default:
        return CreditAccountType.loan;
    }
  }
}

enum CreditInfoType {
  onTimePayments(
    title: "On-time Payments",
    description:
        "On-Time Payments measure how often you have paid your loans on time in the last 12 months. It is calculated using the formula b / (a + b), where a is the number of times your payment was delayed (DPD > 0), and b is the number of times you paid on time (DPD = 0). A higher on-time payment ratio shows good repayment habits and can help improve your credit score.",
    iconPath: Res.onTimePaymentSVG,
    impactLevel: "High",
    infoText: "* Calculated based on past 12 months of data",
    indexValue: "1",
  ),
  creditUtilisation(
    title: "Credit Utilisation",
    description:
        "Credit Utilisation is the percentage of your available credit that you are using. It is calculated as (b - a) / b, where a is your current balance across credit cards and overdrafts, and b is the total approved credit limit. Keeping utilisation low shows responsible credit use and can boost your credit score, while high usage may negatively impact it.",
    iconPath: Res.creditUtilisationSVG,
    impactLevel: "High",
    indexValue: "2",
  ),
  creditAge(
    title: "Credit Age",
    description:
        "Credit Age refers to the length of time since your oldest active credit card or loan account was opened. It is measured in years and months and reflects your credit history's maturity. A longer credit age generally indicates responsible credit behavior and can positively impact your credit score.",
    iconPath: Res.creditAgeSvg,
    impactLevel: "Medium",
    indexValue: "3",
  ),
  creditEnquiries(
    title: "Credit Enquiries",
    description:
        "Credit Enquiry refers to the total number of loan enquiries made in the last 6 months. Each time you apply for credit, lenders check your credit report, and these enquiries are recorded. A high number of recent enquiries may indicate increased credit dependency and can negatively impact your credit score.",
    iconPath: Res.creditEnquiriesSVG,
    impactLevel: "Medium",
    indexValue: "4",
  ),
  creditMix(
    title: "Credit Mix",
    description:
        "Credit Mix is the ratio of your unsecured to total outstanding loans, calculated as b / (a + b), where a is secured loans and b is unsecured loans. \n\nSecured loans are backed by collateral, like a car or home, while unsecured loans are not tied to any asset and rely solely on your creditworthiness. \n\nConsidering only active accounts, a balanced mix can improve your credit profile. Having a good mix of both loan types shows responsible credit management and enhances your creditworthiness.",
    iconPath: Res.creditMixSVG,
    impactLevel: "Low",
    indexValue: "5",
  );

  const CreditInfoType({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.impactLevel,
    required this.indexValue,
    this.infoText = "",
  });

  final String title;
  final String description;
  final String iconPath;
  final String impactLevel;
  final String infoText;
  final String indexValue;
}

mixin CreditReportHelperMixin on MaskedNumberAnalyticsMixin, ErrorLoggerMixin {
  late final List<KeyBenefits> keyBenefits = [
    KeyBenefits(
      title: "Free Score Check",
      description:
          "Get your credit score for free - no fees, no hidden charges",
      iconPath: Res.creditScoreCheck,
    ),
    KeyBenefits(
      title: "Improve Financial Health",
      description:
          "Know where you stand: Get your credit score monthly and unlock better loan rates with us",
      iconPath: Res.creditScoreFinancialHealth,
    ),
    KeyBenefits(
      title: "Regular Score Updates",
      description: "Check your score every month to track your progress",
      iconPath: Res.creditScoreUpdates,
    ),
    KeyBenefits(
      title: "Data Protection",
      description:
          "Your data is encrypted and securely protected according to banking industry standards",
      iconPath: Res.creditScoreDataProtection,
    ),
  ];

  late List<String> month = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  bool isPhoneMatchingMaskedValue(String masked, String input) {
    final pattern = masked.replaceAllMapped(
      RegExp(r'.'),
      (match) => match.group(0) == 'X' ? r'\d' : RegExp.escape(match.group(0)!),
    );
    return RegExp('^$pattern\$').hasMatch(input);
  }

  String? validateMaskedMobileNumber(String? value,
      {required String maskedValue}) {
    if (value != null) {
      if (value.length != 10) {
        return "Enter a valid number";
      } else if (!isPhoneMatchingMaskedValue(maskedValue, value)) {
        if (value.length == 10) logCreditScoreMaskedFlowNumberMismatch();
        return "The number did not match. Please check and enter the correct number.";
      }
    }
    return null;
  }

  Future<ExperianConsentStatus?> checkConsentStatus() async {
    ExperianConsentModel experianConsentModel =
        await creditReportRepository.checkConsentStatus();

    switch (experianConsentModel.apiResponse.state) {
      case ResponseState.success:
        return experianConsentModel.status;
      default:
        logError(
          statusCode: experianConsentModel.apiResponse.statusCode.toString(),
          responseBody: experianConsentModel.apiResponse.apiResponse,
          requestBody: experianConsentModel.apiResponse.requestBody,
          exception: experianConsentModel.apiResponse.exception,
          url: experianConsentModel.apiResponse.url,
        );
        return null;
    }
  }

  late final String REFRESH_PULL = "D2CRP";

  final creditReportRepository = CreditReportRepository();
}
