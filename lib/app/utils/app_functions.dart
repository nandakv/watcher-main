import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart' as pes;
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/on_boarding_repository/on_boarding_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/app_form_status_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

class AppFunctions {
  late final String NA_TEXT = "-";

  ///Post permissions data to the aquaman server
  postUserDataToServer(
      {required String thirdPartyName,
      required Map requestJson,
      required Map responseJson}) async {
    List<String> grantedPermissions = [];

    for (var i = 0; i < pes.Permission.values.length; i++) {
      if (await pes.Permission.values[i].isGranted) {
        grantedPermissions.add(
            pes.Permission.values[i].toString().replaceAll('Permission.', ''));
      }
    }

    Get.log("granted permissions - ${grantedPermissions.toString()}");

    OnBoardingRepository().postUserDataToServer(body: {
      "appformId": await AppAuthProvider.appFormID,
      "applicantId": await AppAuthProvider.appFormID,
      "dataForm": thirdPartyName,
      "dataOpr": "Post",
      "mobileNumber": await AppAuthProvider.phoneNumber,
      "permissions": '{${grantedPermissions.join(',')}',
      "requestJson": jsonEncode(requestJson),
      "responseJson": jsonEncode(responseJson)
    });
  }

  // ///this function will check if the appform is rejected or not
  // ///make [postRejection] to `true` only if you want to change the state
  // ///if [postRejection] is `true` please pass the [index]
  // Future<AppFormRejectionModel> isAppFormRejected(
  //     {required AppFormStatusModel appFormStatusModel,
  //     required bool postRejection,
  //     String? fullName,
  //     String? index,
  //     bool? isNotWithdrawal}) async {
  //   String errorTitle = "";
  //   String errorBody = "";
  //
  //   if (appFormStatusModel.rejection != null) {
  //     switch (appFormStatusModel.rejection!.code) {
  //       case "CPC_PINCODE_FAILED":
  //         errorBody =
  //             "Oops! It seems your location isn't in our current coverage.";
  //         break;
  //       case "CPC_SALARYTYPE_FAILED":
  //         errorBody =
  //             "Sorry, we are not processing loans to self-employed individuals currently. We’ll get in touch with you. But it’s not all bad news, you can reapply in 90 days.";
  //         break;
  //       case "CPC_INCOME_FAILED":
  //         errorBody =
  //             "Sorry, we cannot process your loan currently. You do not match our eligibility criteria.";
  //         break;
  //       case "PAN_VERIFICATION_FAILED":
  //         errorBody =
  //             "Sorry, we cannot process your loan currently. We were unable to verify your PAN.";
  //         break;
  //       case "EMPLOYMENT_VERIFICATION_FAILED":
  //         errorBody =
  //             "Sorry, we cannot process your loan currently. You do not match our eligibility criteria.";
  //         break;
  //       case "INITIAL_OFFER_REJECTED":
  //       case "FINAL_OFFER_REJECTED":
  //         errorTitle = "Sorry, we cannot offer you a credit line";
  //         errorBody =
  //             "Sorry, we cannot process your application currently. You do not meet our eligibility criteria";
  //         break;
  //       default:
  //         errorBody =
  //             "Sorry, we cannot process your loan currently. You do not match our eligibility criteria.";
  //     }
  //
  //     return AppFormRejectionModel(
  //         isRejected: true, errorTitle: errorTitle, errorBody: errorBody);
  //   } else {
  //     return AppFormRejectionModel(
  //         isRejected: false, errorTitle: '', errorBody: '');
  //   }
  // }

  AppFormRejectionModel computeAppFormRejection(
      {required Rejection? rejection}) {
    String errorTitle = "";
    String errorBody = "";
    RejectionType rejectionType = RejectionType.general;
    if (rejection != null) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.rejectionReason,
          attributeName: {"rejectionReason": rejection.code});
      switch (rejection.code) {
        case "CPC_PINCODE_FAILED":
          errorTitle =
              "Oops! It seems your location isn't in our current coverage.";
          errorBody =
              "Oops! It seems your location isn't in our current coverage.";
          rejectionType = RejectionType.location;
          break;
        case "CPC_SALARYTYPE_FAILED":
          errorBody =
              "Sorry, we are not processing loans to self-employed individuals currently. We’ll get in touch with you. But it’s not all bad news, you can reapply in 90 days.";
          break;
        case "CPC_INCOME_FAILED":
          errorBody =
              "Sorry, we cannot process your application currently. You do not match our eligibility criteria.";
          break;
        case "PAN_VERIFICATION_FAILED":
          errorTitle =
              "Uh-oh! Your application has been rejected as we're unable to verify your PAN Card details.";
          rejectionType = RejectionType.panCard;
          break;
        case "EMPLOYMENT_VERIFICATION_FAILED":
          errorBody =
              "Sorry, we cannot process your application currently. You do not match our eligibility criteria.";
          break;
        case "Fraud Check Reject":
        case "Dedupe QC Stage Reject":
        case "VKYC_REJECT":
          errorTitle =
              "Uh-oh! Your application has been rejected as we're unable to verify your KYC details.";
          rejectionType = RejectionType.kyc;
          break;
        case "INITIAL_OFFER_REJECTED":
        case "FINAL_OFFER_REJECTED":
          errorTitle = "Sorry, we cannot offer you a credit line";
          errorBody =
              "Sorry, we cannot process your application currently. You do not meet our eligibility criteria";
          break;
        default:
          errorBody =
              "Sorry, we cannot process your application currently. You do not match our eligibility criteria.";
      }

      return AppFormRejectionModel(
          isRejected: true,
          errorTitle: errorTitle,
          errorBody: errorBody,
          rejectionType: rejectionType,
          rejectionCode: rejection.code);
    } else {
      return AppFormRejectionModel(
        isRejected: false,
        errorTitle: '',
        errorBody: '',
        rejectionCode: '',
        rejectionType: rejectionType,
      );
    }
  }

  String parseIntoCommaFormat(String num) {
    if(num.isEmpty) return num;
    Get.log("Before parsing ${num}");
    return NumberFormat.currency(
      symbol: '',
      locale: "HI",
      decimalDigits: 0,
    ).format(double.parse(num));
  }

  String parseNumberToCommaFormatWithRupeeSymbol(num? number) {
    if (number == null) {
      return NA_TEXT;
    }
    String numberWithComma = NumberFormat.currency(
      symbol: '',
      locale: "HI",
      decimalDigits: 0,
    ).format(number.abs());
    if (number.isNegative) {
      return "-₹$numberWithComma";
    } else {
      return "₹$numberWithComma";
    }
  }

  String parseIntoDecimalCommaFormat(String num) {
    if(num.isEmpty) return num;
    Get.log("Before parsing ${num}");
    if (double.parse(num) > 0.0) {
      return NumberFormat.currency(
        symbol: '',
        locale: "HI",
        decimalDigits: 2,
      ).format(double.parse(num));
    }
    return double.parse(num).toInt().toString();
  }

  ///logic to display initial and final offer
  ///the amount should be in (* lakh) if limit amount is above 100000
  ///else it should be in comma separated thousand
  static String getIOFOAmount(double limitAmount, {int decimalDigit = 0}) {
    return "₹ ${NumberFormat.currency(
      symbol: '',
      locale: "HI",
      decimalDigits: decimalDigit,
    ).format(limitAmount)}";
  }

  ///this function converts the base64String to
  ///file and store it in the internal directory
  ///this doesn't need the storage permission
  static Future<String> createImageFromString(String encodedStr) async {
    Uint8List bytes = base64.decode(encodedStr);
    var dir = await path_provider.getApplicationDocumentsDirectory();
    File file = File("${dir.path}/" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        ".png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  String getDayOfMonthSuffix(int dayNum) {
    if (!(dayNum >= 1 && dayNum <= 31)) {
      throw Exception('Invalid day of month');
    }

    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  computeMonthsOrDayAgoLoanTaken(DateTime givenDate) {
    DateTime currentDate = DateTime.now();
    int differenceInMonths = currentDate.year * 12 +
        currentDate.month -
        (givenDate.year * 12 + givenDate.month);
    if (differenceInMonths < 1) {
      int differenceInDays = currentDate.difference(givenDate).inDays;
      return '$differenceInDays ${differenceInDays == 1 ? "day" : "days"} ago';
    } else {
      return '$differenceInMonths month${differenceInMonths > 1 ? 's' : ''} ago';
    }
  }

  String getDobFormat(DateTime dateTime) {
    DateFormat format = DateFormat.MMMM();
    return "${dateTime.day}${getDayOfMonthSuffix(dateTime.day)}${'-'}${format.format(dateTime)}${'-'}${dateTime.year}";
  }

  String getSlashDobFormate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  ///get current date time with TimeZone to update the dynamoDB
  String getCurrentDateTimeWithTimeZone() {
    return DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(DateTime.now());
  }

  showInAppReview(String event) async {
    if (event.isEmpty) return;
    final InAppReview inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      AppAnalytics.trackWebEngageEventWithAttribute(eventName: event);
      await inAppReview.requestReview();
    }
  }

  String getBaseUrlFromString(String urlString) {
    try {
      Uri uri = Uri.parse(urlString);
      String baseUrl = uri.origin;
      return baseUrl;
    } catch (e) {
      return "";
    }
  }

  LoanProductCode computeLoanProductCode(String lpc) {
    switch (lpc) {
      case "SBL":
        return LoanProductCode.sbl;
      case "SBD":
      case "SBA":
        return LoanProductCode.sbd;
      case "CLP":
        return LoanProductCode.clp;
      case "UPL":
        return LoanProductCode.upl;
      case "FCL":
        return LoanProductCode.fcl;
      default:
        return LoanProductCode.unknown;
    }
  }

  String getLastUpdatedFormat(String lastPulledDateTime) {
    DateTime lastPulledDate = DateTime.parse(lastPulledDateTime);
    String formattedLastPulledDate =
        DateFormat('d MMMM, yyyy').format(lastPulledDate);
    return formattedLastPulledDate;
  }

  int getNextScoreUpdateDaysCount(String lastPulledDateTime) {
    DateTime lastPulledDate = DateTime.parse(lastPulledDateTime);
    DateTime nextPullDate = lastPulledDate.add(const Duration(days: 30));
    DateTime currentDate = DateTime.now();
    int daysUntilNextPull = nextPullDate.difference(currentDate).inDays;

    return daysUntilNextPull > 0 ? daysUntilNextPull : 0;
  }

  String getNextUpdateAvailableFormat(String lastPulledDateTime) {
    DateTime lastPulledDate = DateTime.parse(lastPulledDateTime);
    DateTime nextPullDate = lastPulledDate.add(Duration(days: 30));
    String formattedNextPullDate =
        DateFormat('d MMMM, yyyy').format(nextPullDate);
    return formattedNextPullDate;
  }

  String formatNumberWithCommas(double value) {
    if (value == value.toInt()) {
      return NumberFormat('#,##0', 'en_IN').format(value.toInt());
    } else {
      final NumberFormat formatter = NumberFormat('#,##0.##', 'en_IN');
      return formatter.format(value);
    }}

  String camelCase(String input) {
    if (input.isEmpty) {
      return "";
    }

    String trimmedInput = input.trim().toLowerCase();

    List<String> words = trimmedInput.split(RegExp(r'[\s_-]+'));

    StringBuffer result = StringBuffer(words[0]);
    for (int i = 1; i < words.length; i++) {
      result.write(words[i][0].toUpperCase() + words[i].substring(1));
    }

    return result.toString();
  }

  String normalizeNumberString(String numberString) {
    final double? value = double.tryParse(numberString);

    if (value == null) {
      return numberString;
    }

    if (value == value.truncate()) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }
}
