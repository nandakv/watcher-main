import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/referral_data_model.dart';
import 'package:privo/app/modules/home_screen_module/widgets/financial_tools_widget.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';

import '../api/response_model.dart';
import '../modules/credit_report/model/credit_report_response_model.dart';

enum LPCCardType {
  loan,
  topUp,
  lowngrow,
}

class HomeScreenModel {
  List<LpcCard> allCards = [];
  List<LpcCard> exploreMore = [];
  List<LpcCard> upgradeCards = [];
  late FinancialToolsModel financialTools;
  ReferralDataModel? referralData;
  List<FinancialToolType> financialToolsList = [];
  UserData? userData;
  int? deviceDetailsRefreshWindow;
  late ApiResponse apiResponse;

  HomeScreenModel.decodeResponse(ApiResponse apiResponse,
      [this.deviceDetailsRefreshWindow]) {
    switch (apiResponse.state) {
      case ResponseState.success:
        try {
          Map<LoanProductCode, LpcCard> exploreMoreMap = {
            // LoanProductCode.clp: LpcCard.decodeResponse(clpNewUser),
            LoanProductCode.sbl: LpcCard.decodeResponse(sblUserJson)
          };

          ///least number is the highest priority
          ///the first element in the list is the highest priority
          ///group all the higher priority cards in primaryCards List
          ///secondaryCards List will contain the rest of the cards
          Map<String, dynamic> json = jsonDecode(apiResponse.apiResponse);
          financialTools =
              FinancialToolsModel.fromJson(json['financial_tools'] ?? {});
          if (json["account"] != null &&
              json["account"]['accountStatus'] != null) {
            _computeAccountStatus(apiResponse);
          }

          if (json['referral_data'] != null) {
            referralData = ReferralDataModel.fromJson(json['referral_data']);
            _setShowReferral();
          }

          if (json['user_data'] != null) {
            userData = UserData.fromJson(json, deviceDetailsRefreshWindow);
          }

          // _addExploreMore();
          if (json["cards"] == null) {
            ///temporary event to debug polling appform empty prod incident
            AppAnalytics.trackWebEngageEventWithAttribute(
              eventName: "Cards is null in magnus response",
              attributeName: json,
            );
            _computeNewUser(apiResponse, exploreMoreMap);
            return;
          }

          allCards = List<LpcCard>.from(
            json["cards"].map(
              (json) {
                LpcCard card = LpcCard.decodeResponse(json);
                LoanProductCode currentLpc =
                    AppFunctions().computeLoanProductCode(card.loanProductCode);
                _computeExploreMore(currentLpc, exploreMoreMap);
                return card;
              },
            ),
          );

          exploreMore.addAll(exploreMoreMap.values.toList());

          if (json['offer_zone'] != null &&
              json['offer_zone']['upgrades'] != null) {
            upgradeCards = List<LpcCard>.from(
              json["offer_zone"]['upgrades'].map(
                (json) {
                  return LpcCard.decodeResponse(json);
                },
              ),
            );
          }



          LPCService.instance.lpcCards = allCards;
          LPCService.instance.upgradeCards = upgradeCards;
          LPCService.instance.activeCard = null;
          this.apiResponse = apiResponse;
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

  void _setShowReferral() {
    if (referralData!.enableReferral) {
      AppAuthProvider.setShowReferral(true);
    } else {
      AppAuthProvider.setShowReferral(false);
    }
  }

  void _computeExploreMore(LoanProductCode currentLpc,
      Map<LoanProductCode, LpcCard> exploreMoreMap) {
    switch (currentLpc) {
      // case LoanProductCode.clp:
      //   exploreMoreMap.remove(LoanProductCode.clp);
      //   break;
      case LoanProductCode.sbl:
      case LoanProductCode.sbd:
        exploreMoreMap.remove(LoanProductCode.sbl);
        break;
      default:
        break;
    }
  }

  void _computeNewUser(
      ApiResponse apiResponse, Map<LoanProductCode, LpcCard> lpcMap) {
    LpcCard lpcCard = LpcCard.decodeResponse(sblUserJson);
    allCards.add(lpcCard);
    _computeExploreMore(LoanProductCode.sbd, lpcMap);
    exploreMore.addAll(lpcMap.values.toList());
    LPCService.instance.lpcCards = allCards;
    LPCService.instance.activeCard = null;
    this.apiResponse = apiResponse;
    return;
  }

  Map<String, dynamic> sblUserJson = {
    "customer_cif": "",
    "loan_product_code": "SBD",
    "loan_product_name": "Small Business Loan",
    "appform_created_at":
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
    "app_form_id": "",
    "applicant_type": "LinkedIndividual",
    "applicant_party_type": "",
    "applicant_id": "0",
    "appform_status": "",
    "appform_status_numeric": "",
    "visible": true,
    "priority": "0"
  };

  Map<String, dynamic> clpNewUser = {
    "customer_cif": "",
    "loan_product_code": "CLP",
    "loan_product_name": "Privo Instant loan",
    "appform_created_at":
        DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()),
    "app_form_id": "",
    "applicant_type": "LinkedIndividual",
    "applicant_party_type": "",
    "applicant_id": "0",
    "appform_status": "",
    "appform_status_numeric": "",
    "visible": true,
    "priority": "0"
  };

  void _computeAccountStatus(ApiResponse apiResponse) {
    AccountModel accountModel = AccountModel.decodeResponse(
        jsonDecode(apiResponse.apiResponse)['account']);
    sblUserJson.addAll({
      'type': accountModel.type,
      'title': accountModel.title,
      'text': accountModel.text,
      'status': accountModel.accountStatus
    });
  }
}

class LpcCard {
  late String customerCif;
  late String loanProductCode;
  late String loanProductName;
  late DateTime appformCreatedAt;
  late String appFormId;
  late String applicantType;
  late String applicantPartyType;
  late String appformStatus;
  late bool visible;
  late int priority;
  late String type;
  late String title;
  late String text;
  late LPCCardType lpcCardType;

  bool isPrimary = false;
  String? applicantId;
  bool isRejected = false;
  bool isAccountDeleted = false;

  LpcCard.decodeResponse(Map<String, dynamic> json) {
    customerCif = json['customer_cif'];
    loanProductCode = json["loan_product_code"];
    loanProductName = json["loan_product_name"] ?? "Your Loan";
    appformCreatedAt = DateTime.parse(json["appform_created_at"]);
    appFormId = json["app_form_id"];
    applicantType = json["applicant_type"];
    applicantPartyType = json["applicant_party_type"];
    appformStatus = json["appform_status"];
    visible = json["visible"];
    priority = int.parse(json["priority"]);
    applicantId = json['applicant_id'];
    isRejected = json['appform_status_numeric'] == "-20";

    ///This parsing is because backend
    ///sends priority as string as from their end in go lang its taking by
    ///default 0 if passed as integer which is not ideal as 0 can be used as
    ///another priority number.
    isRejected = json['appform_status_numeric'] == "-20";

    type = json['type'] ?? "";
    title = json['title'] ?? "";
    text = json['text'] ?? "";
    isAccountDeleted = type.toLowerCase().contains("accountdeleted");
    lpcCardType = _computeLPCCardType(json['loan_type'] ?? "");
  }

  LPCCardType _computeLPCCardType(String loanType) {
    switch (loanType) {
      case "topup":
        return LPCCardType.topUp;
      case "LOW_AND_GROW":
        return LPCCardType.lowngrow;
      default:
        return LPCCardType.loan;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerCif'] = customerCif;
    data['loanProductCode'] = loanProductCode;
    data['loanProductName'] = loanProductName;
    data['appformCreatedAt'] = appformCreatedAt.toIso8601String();
    data['appFormId'] = appFormId;
    data['applicantType'] = applicantType;
    data['applicantPartyType'] = applicantPartyType;
    data['appformStatus'] = appformStatus;
    data['visible'] = visible;
    data['priority'] = "$priority";
    data['applicantId'] = applicantId;
    return data;
  }
}

class AccountModel {
  late String type;
  late String title;
  late String text;
  late String accountStatus;

  AccountModel.decodeResponse(Map<String, dynamic> json) {
    accountStatus = json['accountStatus'];
    title = json['title'];
    text = json['text'];
    type = json['type'];
  }
}

class FinancialToolsModel {
  CreditScoreModel? creditScore;
  FinSightsModel? finSights;

  FinancialToolsModel.fromJson(Map<String, dynamic> json) {
    creditScore = json['credit_score'] != null
        ? CreditScoreModel.fromJson(json['credit_score'])
        : null;

    // json['account_insights'] = {
    //   "tag": "",
    //   "refresh_available": false,
    //   "application_details": {
    //     "pull_status": "SUCCESS",
    //     "account_id": "d1c6d086-6314-4ee8-ba0b-200cfb6cc28b",
    //     // "account_id": "",
    //     "app_form_id": "7f8a70cf-f55a-4571-bb6c-5e9022a2a1ca",
    //     "data_page_viewed": false
    //   }
    // };

    finSights = json['account_insights'] != null
        ? FinSightsModel.fromJson(json['account_insights'])
        : null;
  }
}

class FinSightsModel {
  late final String tag;
  late bool refreshAvailable;
  late bool isLocked;
  late FinsightsApplicationDetails applicationDetails;

  FinSightsModel.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    refreshAvailable = json['refresh_available'];
    isLocked = json['is_locked'];
    applicationDetails =
        FinsightsApplicationDetails.fromJson(json['application_details']);
  }
}

class FinsightsApplicationDetails extends ApplicationDetails {
  FinsightsApplicationDetails.fromJson(Map<String, dynamic> json)
      : super.fromJson(json);
}

class CreditScoreModel {
  late final String tag;
  late bool refreshAvailable;
  late final String cardText;
  late CreditScoreApplicationDetails applicationDetails;
  late final bool isFreshPullDone;
  late bool isLocked;

  CreditScoreModel.fromJson(Map<String, dynamic> json) {
    tag = json['tag'];
    refreshAvailable = json['refresh_available'];
    cardText = json['card_text'];
    applicationDetails =
        CreditScoreApplicationDetails.fromJson(json['application_details']);
    // if s3 url present then freshpull is done
    isFreshPullDone = applicationDetails.reportS3url.isNotEmpty;
    isLocked = json['is_locked'];
  }

  updateApplicationDetails(CreditReportResponseModel model) {
    String lastPulledDateTime = model.lastPulledDateTime;
    if (lastPulledDateTime.isNotEmpty) {
      refreshAvailable = model.refreshAvailable;
      applicationDetails.lastPulledDateTime = lastPulledDateTime;
      applicationDetails.lastUpdatedDate =
          AppFunctions().getLastUpdatedFormat(lastPulledDateTime);
      applicationDetails.nextScoreUpdateDays =
          AppFunctions().getNextScoreUpdateDaysCount(lastPulledDateTime);
      applicationDetails.nextUpdateAvailableFormat =
          AppFunctions().getNextUpdateAvailableFormat(lastPulledDateTime);
    }
  }
}

class CreditScoreApplicationDetails extends ApplicationDetails {
  late final String consentDateTime;
  late String lastPulledDateTime;
  late final String applicantId;
  late final String reportS3url;

  // String variables for the three formats
  String get lastUpdatedText => "Last updated on $lastUpdatedDate";
  String lastUpdatedDate = "";

  String get nextScoreUpdateText =>
      'Next score update in $nextScoreUpdateDays days';
  int nextScoreUpdateDays = 0;
  String nextUpdateAvailableFormat = "";

  @override
  CreditScoreApplicationDetails.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    consentDateTime = json['consent_date_time'];
    lastPulledDateTime = json['last_pulled_date_time'];
    reportS3url = json['report_s3_url'] ?? "";
    applicantId = json['applicant_id'];

    if (lastPulledDateTime.isNotEmpty) {
      lastUpdatedDate = AppFunctions().getLastUpdatedFormat(lastPulledDateTime);
      nextScoreUpdateDays =
          AppFunctions().getNextScoreUpdateDaysCount(lastPulledDateTime);
      nextUpdateAvailableFormat =
          AppFunctions().getNextUpdateAvailableFormat(lastPulledDateTime);
    }
  }
}

abstract class ApplicationDetails {
  late final String pullStatus;
  late final String appFormId;
  late final bool dataPageViewed;
  late final String accountId;

  ApplicationDetails.fromJson(Map<String, dynamic> json) {
    pullStatus = json['pull_status'];
    appFormId = json['app_form_id'];
    dataPageViewed = json['data_page_viewed'];
    accountId = json['account_id'] ?? "";
  }
}

class UserData {
  late final bool pushCustomerDeviceDetails;
  int? deviceDetailsRefreshWindow;

  UserData.fromJson(
      Map<String, dynamic> json, this.deviceDetailsRefreshWindow) {
    pushCustomerDeviceDetails =
        _computePushCustomerDeviceDetails(json['user_data']);
  }

  bool _computePushCustomerDeviceDetails(Map<String, dynamic> json) {
    if (json['device_details_updated_at'] == null ||
        json["device_details_updated_at"].isEmpty ||
        deviceDetailsRefreshWindow == null) {
      return true;
    }
    DateTime? deviceDetailsRefreshWindowTime =
        DateTime.tryParse(json['device_details_updated_at'] ?? "");
    if (deviceDetailsRefreshWindowTime == null) return false;
    DateTime currentTime = DateTime.now();
    Duration difference =
        currentTime.difference(deviceDetailsRefreshWindowTime);
    return difference.inHours >= deviceDetailsRefreshWindow!;
  }
}
