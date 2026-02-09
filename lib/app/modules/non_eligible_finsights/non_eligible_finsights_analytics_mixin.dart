import '../../mixin/app_analytics_mixin.dart';
import '../../models/home_screen_model.dart';
import '../../services/lpc_service.dart';

mixin NonEligibleFinSightsAnalyticsMixin on AppAnalyticsMixin {
  late final String finsightsHomeScreenLoadedNEFNE =
      "Finsights_Home_Screen_Loaded_NEF_NE";
  late final String finsightsHomeScreenClickedNEFNE =
      "Finsights_Home_Screen_Clicked_NEF_NE";
  late final String finSightsMotivationLoadedNEF =
      "Finsights_Motivation_Loaded_NEF";
  late final String finSightsMotivationCarouselNEF =
      "Finsights_Motivation_Carousel_V1_NEF";
  late final String finSightsMotivationClickedCarouselNEF =
      "Finsights_Motivation_Carousel_Clicked_V1_NEF";
  late final String finSightsSelfEmpClickedNEF = "Finsights_SelfEmpClicked_NEF";
  late final String finsightsSalariedClickedNEF =
      "Finsights_SalariedClicked_NEF";
  late final String finsightsBusinessOwnerClickedNEF =
      "Finsights_BusinessOwnerClicked_NEF";
  late final String finsightsFreelanceClickedNEF =
      "Finsights_FreelanceClicked_NEF";
  late final String finsightsQTrackExpernseSelectedNEF =
      "Finsights_Q_Track_ExpernseSelected_NEF";
  late final String finsightsQPerIncomeSelectedNEF =
      "Finsights_Q_PerIncomeSelected_NEF";
  late final String finsightsQBusinessTOSelectedNEF =
      "Finsights_Q_BusinessTOSelected_NEF";
  late final String finsightsQBusinessAgeSelectedNEF =
      "Finsights_Q_BusinessAgeSelected_NEF";
  late final String getEarlyAccessClicked = "Get_Early_Access_Clicked";
  late final String sucessfullyJoinedWLLoaded = "Sucessfully_Joined_WL_Loaded";
  late final String finsightsHomeScreenLoadedNEFAldJ =
      "Finsights_Home_Screen_Loaded_NEF_Ald_J";
  late final String finsightsHomeScreenClickedNEFAldJ =
      "Finsights_Home_Screen_Clicked_NEF_Ald_J";

  List<LpcCard> get _lpcCards => LPCService.instance.lpcCards;

  logfinsightsHomeScreenLoadedNEFNE() {
    trackWebEngageEventWithAttribute(
        eventName: finsightsHomeScreenLoadedNEFNE,
        attributeName: {
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsHomeScreenClickedNEFNE() {
    trackWebEngageEventWithAttribute(
        eventName: finsightsHomeScreenClickedNEFNE,
        attributeName: {
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logFinSightsMotivationLoadedNEF({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finSightsMotivationLoadedNEF,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

/*  logfinSightsMotivationCarouselNEF(String name) {
    trackWebEngageEventWithAttribute(
        eventName: finSightsMotivationCarouselNEF,
        attributeName: {"carousel_slide_name": name});
  }*/

  logFinSightsMotivationClickedCarouselNEF(String name) {
    trackWebEngageEventWithAttribute(
        eventName: finSightsMotivationClickedCarouselNEF,
        attributeName: {
          "carousel_slide_name": name,
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinSightsSelfEmpClickedNEF({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finSightsSelfEmpClickedNEF,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsSalariedClickedNEF({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsSalariedClickedNEF,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsBusinessOwnerClickedNEF({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsBusinessOwnerClickedNEF,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logFinsightsFreelanceClickedNEF({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsFreelanceClickedNEF,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsQTrackExpernseSelectedNEF(
      {required String value, String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsQTrackExpernseSelectedNEF,
        attributeName: {
          "selection": value,
          "version":  _getVersion(assignedGroup),
        });
  }

  logfinsightsQPerIncomeSelectedNEF(
      {required String value, String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsQPerIncomeSelectedNEF,
        attributeName: {
          "selection": value,
          "version":  _getVersion(assignedGroup),
        });
  }

  // need to check
  logfinsightsQBusinessTOSelectedNEF() {
    trackWebEngageEventWithAttribute(
      eventName: finsightsQBusinessTOSelectedNEF,
    );
  }

  logfinsightsQBusinessAgeSelectedNEF(
      {required String value, String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: finsightsQBusinessAgeSelectedNEF,
        attributeName: {
          "selection": value,
          "version":  _getVersion(assignedGroup),
        });
  }

  loggetEarlyAccessClicked(
      {String employment = "",
      String income = "",
      String turnOver = "",
      String age = "",
      String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: getEarlyAccessClicked,
        attributeName: {
          "selection employment": employment,
          "selection income": income,
          "selection turnOver": turnOver,
          "selection age": age,
          "version": _getVersion(assignedGroup),
        });
  }

  logsucessfullyJoinedWLLoaded({String assignedGroup = ""}) {
    trackWebEngageEventWithAttribute(
        eventName: sucessfullyJoinedWLLoaded,
        attributeName: {
          "version":  _getVersion(assignedGroup),
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsHomeScreenLoadedNEFAldJ() {
    trackWebEngageEventWithAttribute(
        eventName: finsightsHomeScreenLoadedNEFAldJ,
        attributeName: {
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }

  logfinsightsHomeScreenClickedNEFAldJ() {
    trackWebEngageEventWithAttribute(
        eventName: finsightsHomeScreenClickedNEFAldJ,
        attributeName: {
          "lpc_list": _lpcCards.map((e) => e.loanProductCode).toList().join("_")
        });
  }
  String _getVersion(String assignedGroup) =>
      assignedGroup == "intro_screen_2" ? "v2" : "v1";
}
