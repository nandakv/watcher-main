import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/models/app_form_rejection_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';

mixin SBDBusinessDetailsAnalytics on AppAnalyticsMixin {
  late String sbdBusinessDetails1Loaded = "SBD_Business_Details1_Loaded";
  late String sbdEntityTypeClicked = "SBD_Entity_Type_Clicked";
  late String sbdBusinessNameInput = "SBD_Business_Name_Input";
  late String sbdRegistrationDateInput = "SBD_Registration_Date_Input";
  late String sbdOwnershipTypeInput = "SBD_Ownership_Type_Input";
  late String sbdOperationalBusinessPincodeInput =
      "SBD_Operational_Business_Pincode_Input";
  late String sbdBusinessDetails1Submitted = "SBD_Business_Details1_Submitted";
  late String sbdGstListLoaded = "SBD_GST_List_Loaded";
  late String sbdGstSelected = "SBD_GST_Selected";
  late String sbdCpcVintageRejection = "SBD_CPC_Vintage_Rejection";
  late String sbdBPanRejection = "SBD_BPAN_Rejection";

  void logSbdBusinessDetails1Loaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdBusinessDetails1Loaded,
      attributeName: {
        "SBD_Business_Details1_Loaded": true,
      },
    );
  }

  void logSbdEntityTypeClicked() {
    trackWebEngageEventWithAttribute(
      eventName: sbdEntityTypeClicked,
    );
  }

  logFieldEvents() {
    trackWebEngageEventWithAttribute(
      eventName: sbdBusinessNameInput,
    );
    trackWebEngageEventWithAttribute(
      eventName: sbdRegistrationDateInput,
    );
    trackWebEngageEventWithAttribute(
      eventName: sbdOwnershipTypeInput,
    );
    trackWebEngageEventWithAttribute(
      eventName: sbdOperationalBusinessPincodeInput,
    );
  }

  void logSbdBusinessDetails1Submitted() {
    trackWebEngageEventWithAttribute(
      eventName: sbdBusinessDetails1Submitted,
      attributeName: {
        "SBD_ Business_Details1_Submitted": true,
      },
    );
    logAppsFlyerEvent(eventName: "Basic_Details_Submitted_SBD");
  }

  void logSbdGstListLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: sbdGstListLoaded,
    );
  }

  void logSbdGstSelected(int gstLength) {
    trackWebEngageEventWithAttribute(
      eventName: sbdGstSelected,
      attributeName: {
        "Number of GST": gstLength > 3 ? "3+" : "$gstLength",
      },
    );
  }

  void logSbdCpcVintageRejection(CheckAppFormModel checkAppFormModel) {
    if (checkAppFormModel.rejection?.code.toLowerCase().contains("cpc") ??
        false) {
      trackWebEngageEventWithAttribute(
        eventName: sbdCpcVintageRejection,
      );
    } else {
      trackWebEngageEventWithAttribute(
        eventName: sbdBPanRejection,
      );
    }
  }
}
