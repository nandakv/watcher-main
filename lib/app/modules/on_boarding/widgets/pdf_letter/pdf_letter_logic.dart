import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/sequence_engine_model.dart';
import 'package:privo/app/modules/low_and_grow/widgets/low_and_grow_offer/model/special_offer_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/mixins/on_boarding_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/pdf_letter/pdf_letter_navigation.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/apps_flyer_constants.dart';

import '../../../../api/response_model.dart';
import '../../../../common_widgets/spacer_widgets.dart';
import '../../../../data/repository/on_boarding_repository/sequence_engine_repository.dart';
import '../../../../data/repository/on_boarding_repository/verify_bank_statement_repository.dart';
import '../../../../models/app_form_rejection_model.dart';
import '../../../../models/check_app_form_model.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../../low_and_grow/widgets/low_and_grow_agreement/widgets/low_and_grow_special_offer_card.dart';
import '../../user_state_maps.dart';
import 'line_agreement_offer_model.dart';

enum PDFLetterType { sanctionLetter, lineAgreement }

class PDFLetterLogic extends GetxController
    with ApiErrorMixin, OnBoardingMixin, AppFormMixin {
  late PDFLetterType pdfLetterType;

  late SequenceEngineModel sequenceEngineModel;

  late String screenName;

  _computeScreenName() {
    if (pdfLetterType == PDFLetterType.lineAgreement) {
      screenName = 'line_agreement';
    }
    screenName = 'sanction_letter';
  }

  String pdfDownloadURL = "";
  final String fileName = "SANCTION_LETTER";

  OnBoardingPDFLetterNavigation? pdfLetterNavigation;

  bool _isPageLoading = true;

  bool _isButtonLoading = false;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
    if (pdfLetterNavigation != null) {
      pdfLetterNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(screenName);
    }
  }

  bool get isButtonLoading => _isButtonLoading;

  set isButtonLoading(bool value) {
    _isButtonLoading = value;
    update();
    if (pdfLetterNavigation != null) {
      pdfLetterNavigation!
          .toggleBack(isBackDisabled: _isPageLoading || _isButtonLoading);
    } else {
      onNavigationDetailsNull(screenName);
    }
  }

  late String lpc;
  late LineAgreementOfferModel offerModel;
  late LoanProductCode loanProductCode;

  getLetterType({required PDFLetterType pdfLetterType}) {
    this.pdfLetterType = pdfLetterType;
    _computeScreenName();
    _getAppForm();
  }

  String appFormId = "";

  _getAppForm() async {
    isPageLoading = true;
    getAppForm(
      onSuccess: _onAppFormApiSuccess,
      onApiError: _onAppFormApiError,
      onRejected: _onAppFormRejected,
    );
  }

  _onAppFormApiSuccess(AppForm appForm) {
    lpc = appForm.responseBody['loanProduct'];
    appFormId = appForm.responseBody['appFormId'];
    loanProductCode = appForm.loanProductCode;
    _getPDFLetterURL(appForm);
  }

  _onAppFormApiError(ApiResponse apiResponse) {
    isPageLoading = false;
    handleAPIError(apiResponse, screenName: screenName, retry: _getAppForm);
  }

  _onAppFormRejected(CheckAppFormModel checkAppFormModel) {
    isPageLoading = false;
    if (pdfLetterNavigation != null) {
      pdfLetterNavigation!
          .onAppFormRejected(model: checkAppFormModel.appFormRejectionModel);
    } else {
      onNavigationDetailsNull(screenName);
    }
  }

  _getSequenceEngineModel() {
    if (pdfLetterNavigation != null) {
      sequenceEngineModel = pdfLetterNavigation!.getSequenceEngineDetails();
    } else {
      onNavigationDetailsNull(screenName);
    }
  }

  _getPDFLetterURL(AppForm appForm) async {
    offerModel = LineAgreementOfferModel.fromJson(appForm.responseBody);
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getPDFLetterURL(
      pdfLetterType: _computeLetterType(),
    );

    switch (model.apiResponse.state) {
      case ResponseState.success:
        pdfDownloadURL = model.responseBody;
        isPageLoading = false;
        _logCreditLineSanctionedEvents();
        break;
      default:
        isPageLoading = false;
        handleAPIError(model.apiResponse,
            screenName: screenName, retry: _getPDFLetterURL);
    }
  }

  void _logCreditLineSanctionedEvents() {
    // AppAnalytics.trackWebEngageEventWithAttribute(eventName: WebEngageConstants.postOfferApproved);
    AppAnalytics.logAppsFlyerEvent(
        eventName: AppsFlyerConstants.creditLineSanctioned);
    AppAnalytics.logAppsFlyerEvent(
        eventName: pdfLetterType == PDFLetterType.lineAgreement
            ? AppsFlyerConstants.agreementLoaded
            : AppsFlyerConstants.sanctionLetterLoaded);
  }

  void onAfterFirstLayout() {
    if (pdfLetterNavigation != null) {
      pdfLetterNavigation!.toggleAppBarVisibility(true);
    } else {
      onNavigationDetailsNull(screenName);
    }
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.lineAgreementScreen);
  }

  onContinuePressed() async {
    isButtonLoading = true;
    _getSequenceEngineModel();
    CheckAppFormModel checkAppFormModel =
        await SequenceEngineRepository(sequenceEngineModel).makeHttpRequest(
      body: {},
    );
    switch (checkAppFormModel.apiResponse.state) {
      case ResponseState.success:
        if (checkAppFormModel.sequenceEngine != null) {
          _onUpdateSuccess(checkAppFormModel.sequenceEngine!);
        }
        break;
      default:
        isButtonLoading = false;
        handleAPIError(
          checkAppFormModel.apiResponse,
          screenName: screenName,
          retry: onContinuePressed,
        );
    }
  }

  void _onUpdateSuccess(SequenceEngineModel sequenceEngineModel) {
    AppAnalytics.logAppsFlyerEvent(
        eventName: pdfLetterType == PDFLetterType.sanctionLetter
            ? AppsFlyerConstants.creditLineSanctionAccepted
            : AppsFlyerConstants.lineAgreementAccepted);
    pdfLetterType == PDFLetterType.sanctionLetter
        ? ""
        : AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.lineAgreementAccepted);
    AppAnalytics.trackWebEngageUser(
        userAttributeName: "AppformStatus",
        userAttributeValue: "Credit Line Activated");

    isButtonLoading = false;
    if (pdfLetterNavigation != null) {
      pdfLetterNavigation!
          .navigateUserToAppStage(sequenceEngineModel: sequenceEngineModel);
    } else {
      onNavigationDetailsNull(screenName);
    }
  }

  String _computeLetterType() {
    switch (pdfLetterType) {
      case PDFLetterType.sanctionLetter:
        return "LOAN_SANCTION_LETTER";
      case PDFLetterType.lineAgreement:
        return "LOAN_AGREEMENT&loan_product_code=$lpc";
    }
  }

  Map _computeUpdateBody() {
    switch (pdfLetterType) {
      case PDFLetterType.sanctionLetter:
        return {
          "LetterAcceptance": {
            "Sanction Letter Accepted": "Yes",
            "Sanction Letter Accepted Time": DateTime.now().toString()
          },
        };
      case PDFLetterType.lineAgreement:
        return {
          "LetterAcceptance": {
            "${lpc != "CLP" ? "Loan" : "Line"} Agreement Accepted": "Yes",
            "${lpc != "CLP" ? "Loan" : "Line"} Agreement Accepted Time":
                DateTime.now().toString()
          }
        };
    }
  }

  ///no need to check the null for [pdfLetterNavigation] here
  ///[_computeUpdateSuccessNavigation] is called after null check
  void _computeUpdateSuccessNavigation() {
    // switch (pdfLetterType) {
    //   case PDFLetterType.sanctionLetter:
    //     pdfLetterNavigation!.navigateToOfferScreen();
    //     break;
    //   case PDFLetterType.lineAgreement:
    //     pdfLetterNavigation!.navigateToCreditLineScreen();
    //     break;
    // }
  }

  String computeTenure() {
    return "${offerModel.offerSection!.minTenure} - ${offerModel.offerSection!.maxTenure} months";
  }

  Widget computeLoanProductLineAgreementOffer() {
    switch (lpc) {
      case "CLP":
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Line Agreement",
              style: GoogleFonts.poppins(
                color: darkBlueColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const VerticalSpacer(10),
            SpecialOfferCard(
              specialOffer: computeSpecialOfferForclp(),
              loanProductCode: loanProductCode,
            ),
          ],
        );
      case "SBL":
      case "UPL":
        /*   return SpecialOfferCard(
          specialOffer: computeSpecialOfferForUplSbl(),
          loanProductCode: loanProductCode,
        );*/
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }

  computeSpecialOfferForUplSbl() {
    return SpecialOffer(
      enhancedLimitAmount: offerModel.uplOfferSection!.loanAmount,
      enhancedProcessingFee: offerModel.uplOfferSection!.processingFee,
      enhancedInterest: offerModel.uplOfferSection!.roi,
      enhancedTenure: '${offerModel.uplOfferSection!.tenure.toString()} months',
    );
  }

  computeSpecialOfferForclp() {
    return SpecialOffer(
      enhancedLimitAmount: offerModel.offerSection!.limitAmount,
      enhancedProcessingFee: offerModel.offerSection!.processingFee,
      enhancedInterest: offerModel.offerSection!.interest,
      enhancedTenure: computeTenure(),
    );
  }
}
