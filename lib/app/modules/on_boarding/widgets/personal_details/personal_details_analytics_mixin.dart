import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/personal_details/user_personal_details.dart';

mixin PersonalDetailsAnalyticsMixin on AppAnalyticsMixin {
  late final String personalDetailsLoaded = "Personal Details Loaded";
  late final String nameInput = "Name Input";
  late final String dobInput = "DOB Input";
  late final String panInput = "PAN Input";
  late final String pincodeInput = "Pincode Input";
  late final String emailInput = "Email Input";
  late final String personalDetailsContinueCTA =
      "Personal Details Continue CTA";
  late final String personalDetailsVerified = "Personal Details Verified";
  late final String personalDetailsRejected = "Personal Details Rejected";
  late final String businessOwnerClicked = "Business_Owner_Clicked";
  late final String selfEmployedClicked = "Self_Employed_Clicked";
  late final String salariedClicked = "Salaried_Clicked";
  late final String personalDetailsSubmitted = "Personal_Details_Submitted";
  static const String partnerPersonalDetailsInterfaceLoaded =
      "Personal Details Validation Interface Loaded";
  static const String partnerPersonalDetailsContinueCTA =
      "Personal Details Validation Continue CTA";
  static const String creditScoreBCConditionFailed =
      "Credit_Score_BC_Conditon_Failed";

  void logPartnerPersonalDetailsInterfaceLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: partnerPersonalDetailsInterfaceLoaded,
    );
  }

  void logCreditScoreBCConditionFailed() {
    trackWebEngageEventWithAttribute(
      eventName: creditScoreBCConditionFailed,
    );
  }

  void logPartnerPersonalDetailsContinueCTA() {
    trackWebEngageEventWithAttribute(
      eventName: partnerPersonalDetailsContinueCTA,
    );
  }

  void logCustomerStatus() {
    trackWebEngageUser(
        userAttributeName: "CustomerStatus", userAttributeValue: "In-Progress");
  }

  void logAppFormStatus() {
    trackWebEngageUser(
        userAttributeName: "AppformStatus", userAttributeValue: "Created");
  }

  void logPersonalDetailsLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: personalDetailsLoaded,
    );
  }

  void logPersonalDetailsContinueCTA() {
    trackWebEngageEventWithAttribute(
      eventName: personalDetailsContinueCTA,
    );
  }

  String _getFlowType(String journeyType, bool isPartnerFlow) {
    if (isPartnerFlow) {
      if (journeyType == "CROSS_SELL") {
        return "cross-sell";
      } else {
        return "partner-flow";
      }
    } else {
      return "organic";
    }
  }

  String _getPartnerID(
      String journeyType, String partnerId, bool isPartnerFlow) {
    if (isPartnerFlow) {
      if (journeyType == "CROSS_SELL") {
        return "CS";
      } else {
        return partnerId;
      }
    } else {
      return "CS";
    }
  }

  void logFlowTypeAndPartnerId(
      {required String journeyType,
      required String partnerId,
      required bool isPartnerFlow}) {
    trackWebEngageUser(
        userAttributeName: "FlowType",
        userAttributeValue: _getFlowType(journeyType, isPartnerFlow));

    trackWebEngageUser(
        userAttributeName: "PartnerID",
        userAttributeValue:
            _getPartnerID(journeyType, partnerId, isPartnerFlow));
  }

  void logAllFieldsInput() {
    trackWebEngageEventWithAttribute(
        eventName: nameInput, attributeName: {"Status": "true"});
    trackWebEngageEventWithAttribute(
        eventName: dobInput, attributeName: {"Status": "true"});
    trackWebEngageEventWithAttribute(
        eventName: panInput, attributeName: {"Status": "true"});
    trackWebEngageEventWithAttribute(
        eventName: pincodeInput, attributeName: {"Status": "true"});
    trackWebEngageEventWithAttribute(
        eventName: emailInput, attributeName: {"Status": "true"});
  }

  logUserAttributes({
    required String appId,
    required String phone,
    required String email,
    required String firstName,
    required String lastname,
  }) {
    trackWebEngageUser(
      userAttributeName: "Application Id",
      userAttributeValue: appId,
    );
    trackWebEngageUser(
      userAttributeName: "Phone",
      userAttributeValue: phone,
    );
    trackWebEngageUser(
      userAttributeName: "Email",
      userAttributeValue: email,
    );
    trackWebEngageUser(
      userAttributeName: "First Name",
      userAttributeValue: firstName,
    );
    trackWebEngageUser(
      userAttributeName: "Last Name",
      userAttributeValue: lastname,
    );
  }

  void logPersonalDetailsVerified(String firstName, String email) {
    trackWebEngageEventWithAttribute(
      eventName: personalDetailsVerified,
      attributeName: {
        "First Name": firstName,
        "Email": email,
      },
    );
  }

  void logPersonalDetailsRejected(String firstName, String email) {
    trackWebEngageEventWithAttribute(
      eventName: personalDetailsRejected,
      attributeName: {
        "First Name": firstName,
        "Email": email,
      },
    );
  }

  String computeEventNameForEmployment(EmploymentType employmentType) {
    switch (employmentType) {
      case EmploymentType.selfEmployed:
        return selfEmployedClicked;
      case EmploymentType.salaried:
        return salariedClicked;
      case EmploymentType.businessOwner:
        return businessOwnerClicked;
      default:
        return "";
    }
  }

  void logPersonalDetailsSubmitted() {
    trackWebEngageEventWithAttribute(
      eventName: personalDetailsSubmitted,
    );
  }
}
