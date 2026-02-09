import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/data/repository/on_boarding_repository/verify_bank_statement_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/modules/help_support/widget/contact_us_card.dart';
import 'package:privo/app/modules/loan_details/loan_details_logic.dart';
import 'package:privo/app/modules/pdf_document/widgets/contact_us_tile_widget.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/repository/loan_details_repository.dart';
import '../../models/loans_pdf_model.dart';
import '../../models/signed_url_model.dart';

enum DocumentType {
  sanctionLetter,
  sanctionLetterDownload,
  agreementLetter,
  agreementLetterDownload,
  soaLetter,
  generic,
  enhancedAgreementLetter,
  scheduleLetter,
  nocLetter,
  pastOfferLetter,
  insuranceCertificate
}

class PDFDocumentLogic extends GetxController with ApiErrorMixin {
  final String SANCTION_LETTER_DOWNLOAD_TYPE = 'sanction_letter';
  final String AGREEMENT_LETTER_DOWNLOAD_TYPE = 'loan_agreement';
  final String SCHEDULE_LETTER = 'SCHEDULE_LETTER';
  final String NOC_LETTER = 'NOC_CREDIT_LINE';
  final String CERTIFICATE_OF_INSURANCE = 'CERTIFICATE_OF_INSURANCE';

  var arguments = Get.arguments;

  LoanDetailsRepository loanDetailsRepository = LoanDetailsRepository();

  late String PDF_DOCUMENT_SCREEN = "pdf_document_screen";

  DocumentType _documentType = DocumentType.generic;

  DocumentType get documentType => _documentType;

  set documentType(DocumentType value) {
    _documentType = value;
    update();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  String? _url = "";

  String? get url => _url;

  set url(String? value) {
    _url = value;
    update();
  }

  fetchAgreementLetter() async {
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getLineAgreement();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        return model.responseBody;
      default:
        _showContactSupportBottomSheetWithBlueBackground(
            "Document unavailable",
            "The document is unavailable currently, please contact customer support",
            model.apiResponse);
    }
  }

  fetchEnhanceOfferAgreementLetter() async {
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getEnhancedOfferAgreement();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        return model.responseBody;
      default:
        _showContactSupportBottomSheetWithBlueBackground(
            "Document unavailable",
            "The document is unavailable currently, please contact customer support",
            model.apiResponse);
    }
  }

  fetchSanctionLetter() async {
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getSanctionLetter();
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        return model.responseBody;
      default:
        _showContactSupportBottomSheetWithBlueBackground(
            "Document unavailable",
            "The document is unavailable currently, please contact customer support",
            model.apiResponse);
    }
  }

  getLetterDownloadURL(String letterType) async {
    CheckAppFormModel model =
        await VerifyBankStatementRepository().getLetterDownloadURL(letterType);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        return model.responseBody;
      default:
        _showContactSupportBottomSheetWithBlueBackground(
            "Document unavailable",
            "The document is unavailable currently, please contact customer support",
            model.apiResponse);
    }
  }

  _fetchLoanDetailsLetterDownlodUrl(
      String letterType, String loanId, String appFormId) async {
    LoansPDFModel model = await VerifyBankStatementRepository()
        .getLoanDetailsLetterDownloadURL(letterType, loanId, appFormId);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        isLoading = false;
        return model.outputUrl;
      default:
        _showContactSupportBottomSheetWithBlueBackground(
            "Document unavailable",
            "The document is unavailable currently, please contact customer support",
            model.apiResponse);
        return;
    }
  }

  computeLoanDetailsLetterDownloadURL(String letterType, String loanId) async {
    String appFormId = arguments['appFormId'] ?? '';
    if (appFormId.isNotEmpty) {
      return _fetchLoanDetailsLetterDownlodUrl(letterType, loanId, appFormId);
    } else {
      _onAppFormNotFetched();
    }
  }

  void _onAppFormNotFetched() {
    handleAPIError(
        ApiResponse(
            state: ResponseState.failure,
            apiResponse: "App form id not fetched for loan"),
        screenName: PDF_DOCUMENT_SCREEN,
        retry: computeLoanDetailsLetterDownloadURL);
  }

  computeAndFetchUrl() async {
    switch (documentType) {
      case DocumentType.sanctionLetter:
        return await fetchSanctionLetter();
      case DocumentType.agreementLetter:
        return await fetchAgreementLetter();
      case DocumentType.soaLetter:
        return arguments['url'];
      case DocumentType.generic:
        return arguments['url'];
      case DocumentType.enhancedAgreementLetter:
        return await fetchEnhanceOfferAgreementLetter();
      case DocumentType.sanctionLetterDownload:
        return await getLetterDownloadURL(SANCTION_LETTER_DOWNLOAD_TYPE);
      case DocumentType.agreementLetterDownload:
        return await getLetterDownloadURL(AGREEMENT_LETTER_DOWNLOAD_TYPE);
      case DocumentType.scheduleLetter:
        return await computeLoanDetailsLetterDownloadURL(
            SCHEDULE_LETTER, arguments['loanId']);
      case DocumentType.nocLetter:
        return await computeLoanDetailsLetterDownloadURL(
            NOC_LETTER, arguments['loanId']);
      case DocumentType.insuranceCertificate:
        return await computeLoanDetailsLetterDownloadURL(
            CERTIFICATE_OF_INSURANCE, arguments['loanId']);
      case DocumentType.pastOfferLetter:
        return await _onDocumentModel(arguments['url']);
    }
  }

  _onDocumentModel(String pastOfferUrl) async {
    SignedUrlModel signedUrlModel =
        await loanDetailsRepository.getUrlSigned(pastOfferUrl);
    switch (signedUrlModel.apiResponse.state) {
      case ResponseState.success:
        url = signedUrlModel.url;
        isLoading = false;
        break;
      default:
        handleAPIError(
          signedUrlModel.apiResponse,
          screenName: PDF_DOCUMENT_SCREEN,
        );
        break;
    }
  }

  void _showContactSupportBottomSheetWithBlueBackground(
      String title, String subTitle, ApiResponse apiResponse) {
    ErrorLoggerMixin().logErrorWithApiResponse(apiResponse);
    Get.back();
    Get.bottomSheet(BottomSheetWidget(
      childPadding: EdgeInsets.zero,
      child: ShowCustomerSupportBottomSheet(
        title: title,
        subTitle: subTitle,
      ),
    ));
  }

  @override
  void onInit() async {
    super.onInit();
    documentType = arguments['documentType'];
    url = await computeAndFetchUrl();
    isLoading = false;
  }
}
