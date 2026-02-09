import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/models/check_app_form_model.dart';
import 'package:privo/app/models/offer_upgrade_history_model.dart';
import 'package:privo/app/routes/app_pages.dart';

import '../on_boarding/mixins/app_form_mixin.dart';
import '../pdf_document/pdf_document_logic.dart';

class OfferUpgradeHistoryLogic extends GetxController
    with ApiErrorMixin, AppFormMixin {
  final String PAGE_WIDGET_ID = 'page_widget_id';

  var arguments = Get.arguments;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    update([PAGE_WIDGET_ID]);
  }

  late String OFFER_UPGRADE_HISTORY_SCREEN = "offer_upgrade_history";

  List<OfferSection> pastOffers = [];

  late FinalOffer finalOffer;
  late Docs docs;

  late LoanProductCode loanProductCode;

  String enhanceOfferDateTime = "";
  String pastOfferDateTime = "";

  void onAfterLayout() {
    isLoading = true;
    if (arguments != null && arguments['appform'] != null) {
      _parseUpgradeHistory(arguments['appform']);
    } else {
      getAppForm(
        onApiError: _onAppformError,
        onRejected: _onRejected,
        onSuccess: _onAppformSuccess,
      );
    }
  }

  _onAppformError(ApiResponse error) {
    handleAPIError(error,
        screenName: OFFER_UPGRADE_HISTORY_SCREEN, retry: onAfterLayout);
  }

  _onRejected(CheckAppFormModel appFormModel) {}

  _onAppformSuccess(AppForm appform) {
    _parseUpgradeHistory(appform);
  }

  void _parseUpgradeHistory(AppForm appform) {
    try {
      OfferUpgradeHistoryModel model =
          OfferUpgradeHistoryModel.fromJson(appform.responseBody);
      loanProductCode = appform.loanProductCode;
      pastOffers = model.pastOffers;
      finalOffer = model.finalOffer;
      docs = model.docs;
      enhanceOfferDateTime = appform.responseBody['LetterAcceptance']
          ['Upgraded Line Agreement Accepted Time'];
      pastOfferDateTime = appform.responseBody['LetterAcceptance']
          ['Line Agreement Accepted Time'];

      isLoading = false;
    } catch (e) {
      handleAPIError(
        ApiResponse(
          state: ResponseState.jsonParsingError,
          apiResponse: "",
          exception: e.toString(),
        ),
        screenName: OFFER_UPGRADE_HISTORY_SCREEN,
      );
    }
  }

  showAgreementLetter(
      {required DocumentType documentType, String letterUrl = ''}) {
    Get.toNamed(
      Routes.PDF_DOCUMENT_SCREEN,
      arguments: {
        'fileName': 'agreement_letter_download',
        'documentType': documentType,
        'url': letterUrl,
      },
    );
  }
}
