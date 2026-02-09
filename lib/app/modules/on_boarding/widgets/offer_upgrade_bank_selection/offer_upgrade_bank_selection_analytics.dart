import 'package:privo/app/mixin/app_analytics_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/offer_upgrade_bank_selection_logic.dart';

mixin OfferUpgradeBankSelectionAnalytics on AppAnalyticsMixin {
  // Variables
  late String bankDetailsScreenLoaded = "Bank_Details_Screen_Loaded";
  late String addBankCta = "Add_Bank_CTA";
  late String bankSelected = "Bank_Selected";
  late String bankingMethodSelected = "Banking_Method_Selected";
  late String primaryBankAdded = "Primary_Bank_Added";
  late String primaryBankAddFailed = "Primary_Bank_Add_Failed";
  late String addMoreBanksCta = "Add_More_Banks_CTA";
  late String allBanksAddedContinueCta = "All_Banks_Added_Continue_CTA";
  late String missoutAddSecondBankCta = "Missout_Add_Second_Bank_CTA";
  late String missoutContinueWithoutAddingCta =
      "Missout_Continue_Without_Adding_CTA";

// Functions
  void logBankDetailsScreenLoaded(bool isCLP) {
    trackWebEngageEventWithAttribute(
      eventName: bankDetailsScreenLoaded,
    );
    if (!isCLP) {
      logAppsFlyerEvent(eventName: "Bank_Details_Loaded_SBD");
    }
  }

  void logAddBankCta(String bankPosition) {
    trackWebEngageEventWithAttribute(
      eventName: addBankCta,
      attributeName: {
        "Add_Bank_CTA": true,
        bankPosition: true,
      },
    );
  }

  void logBankSelected() {
    trackWebEngageEventWithAttribute(eventName: bankSelected, attributeName: {
      "Bank_Selected": true,
    });
  }

  void logBankingMethodSelected(
      BankStatementUploadOption bankStatementUploadOption) {
    trackWebEngageEventWithAttribute(
        eventName: bankingMethodSelected,
        attributeName: {
          "Banking_Method_Selected": true,
          bankStatementUploadOption.type: true,
        });
  }

  void logPrimaryBankAdded(bool isSuccess) {
    trackWebEngageEventWithAttribute(
      eventName: primaryBankAdded,
      attributeName: {
        "Primary_Bank_Added": true,
        isSuccess ? "success" : "failure": true,
      },
    );
    if (!isSuccess) {
      logPrimaryBankAddFailed();
    }
  }

  void logPrimaryBankAddFailed() {
    trackWebEngageEventWithAttribute(
      eventName: primaryBankAddFailed,
      attributeName: {
        "Primary_Bank_Add_Failed": true,
      },
    );
  }

  void logAddMoreBanksCta() {
    trackWebEngageEventWithAttribute(
      eventName: addMoreBanksCta,
      attributeName: {
        "Add_More_Banks_CTA": true,
      },
    );
  }

  void logAllBanksAddedContinueCta(bool isCLP) {
    trackWebEngageEventWithAttribute(
        eventName: allBanksAddedContinueCta,
        attributeName: {
          "All_Banks_Added_Continue_CTA": true,
        });
    if (!isCLP) {
      logAppsFlyerEvent(eventName: "Bank_Details_Submitted_SBD");
    }
  }

  void logMissoutAddSecondBankCta() {
    trackWebEngageEventWithAttribute(
      eventName: missoutAddSecondBankCta,
      attributeName: {
        "Missout_Add_Second_Bank_CTA": true,
      },
    );
  }

  void logMissoutContinueWithoutAddingCta(bool isCLP) {
    trackWebEngageEventWithAttribute(
      eventName: missoutContinueWithoutAddingCta,
      attributeName: {
        "Missout_Continue_Without_Adding_CTA": true,
      },
    );
    if (!isCLP) {
      logAppsFlyerEvent(eventName: "Bank_Details_Submitted_SBD");
    }
  }
}
