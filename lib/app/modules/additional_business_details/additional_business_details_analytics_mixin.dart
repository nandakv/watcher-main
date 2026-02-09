import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'additional_business_details_logic.dart';

mixin AdditionalBusinessDetailsAnalyticsMixin on AppAnalyticsMixin {
  late final String documentConsentLoaded = "SBD_Document_Consent_Loaded";
  late final String documentConsentSubmitted = "SBD_Document_Consent_Submitted";
  late final String addBusinessLoaded = "SBD_AddBusiness_Loaded";
  late final String udhyamInput = "SBD_Udhyam_Input";
  late final String natureBusinessInput = "SBD_Nature_Business_Input";
  late final String businessSectorInput = "SBD_Business_Sector_Input";
  late final String correspondingAddressClicked =
      "SBD_Corresponding_Address_Clicked";
  late final String correspondingAddressLoaded =
      "SBD_Corresponding_Address_Loaded";
  late final String businessAddressClicked = "SBD_Business_Address_Clicked";
  late final String businessAddressLoaded = "SBD_Business_Address_Loaded";
  late final String addressLineInput = "SBD_AddressLine_Input";
  late final String docUploadSuccessful = "SBD_DocUpload_Successful";
  late final String docUploadClicked = "SBD_DocUpload_Clicked";
  late final String docUploadUploadFailed = "SBD_DocUpload_Upload_Failed";
  late final String docUploadUploadDeleted = "SBD_DocUpload_Upload_Deleted";
  late final String addBusinessSubmitted = "SBD_AddBusiness_Submitted";
  late final String sameAsOperationalClicked = "SBD_SameAsOperational_Clicked";

  logDocumentConsentLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: documentConsentLoaded,
    );
  }

  logDocumentConsentSubmitted() {
    trackWebEngageEventWithAttribute(
      eventName: documentConsentSubmitted,
    );
  }

  logAddBusinessLoaded() {
    trackWebEngageEventWithAttribute(
      eventName: addBusinessLoaded,
    );
    logAppsFlyerEvent(eventName: "Additional_Business_Details_Loaded_SBD");
  }

  logAddressSection(AddressDetailsState addressDetailsState) {
    late String clickEventName;
    late String loadEventName;
    switch (addressDetailsState) {
      case AddressDetailsState.residence:
        clickEventName = correspondingAddressClicked;
        loadEventName = correspondingAddressLoaded;
        break;
      case AddressDetailsState.business:
        clickEventName = businessAddressClicked;
        loadEventName = businessAddressLoaded;
        break;
    }
    trackWebEngageEventWithAttribute(
      eventName: clickEventName,
    );
    trackWebEngageEventWithAttribute(
      eventName: loadEventName,
    );
  }

  logAddressLineInput(String addressType) {
    trackWebEngageEventWithAttribute(
      eventName: addressLineInput,
      attributeName: {"address_type": addressType},
    );
  }

  logDocUploadSuccessful(String type) {
    trackWebEngageEventWithAttribute(
      eventName: docUploadSuccessful,
      attributeName: {"doc_type": type},
    );
  }

  logDocUploadClicked(String type) {
    trackWebEngageEventWithAttribute(
      eventName: docUploadClicked,
      attributeName: {"doc_type": type},
    );
  }

  logDocUploadUploadFailed(String type) {
    trackWebEngageEventWithAttribute(
      eventName: docUploadUploadFailed,
      attributeName: {"doc_type": type},
    );
  }

  logDocUploadUploadDeleted(String type) {
    trackWebEngageEventWithAttribute(
      eventName: docUploadUploadDeleted,
      attributeName: {"doc_type": type},
    );
  }

  logAddBusinessSubmitted() {
    trackWebEngageEventWithAttribute(
      eventName: udhyamInput,
    );

    trackWebEngageEventWithAttribute(
      eventName: natureBusinessInput,
    );

    trackWebEngageEventWithAttribute(
      eventName: businessSectorInput,
    );

    trackWebEngageEventWithAttribute(
      eventName: addBusinessSubmitted,
    );

    logAppsFlyerEvent(eventName: "Additional_Business_Details_Submitted_SBD");
  }

  logSameAsOperationalClicked() {
    trackWebEngageEventWithAttribute(
      eventName: sameAsOperationalClicked,
    );
  }
}
