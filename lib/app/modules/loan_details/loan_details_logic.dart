import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/common_widgets/blue_button.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/mixin/advance_emi_payment_mixin.dart';
import 'package:privo/app/models/advance_emi_payment_info_model.dart';
import 'package:privo/app/models/foreclosure_payment_info_model.dart';
import 'package:privo/app/models/loans_model.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/models/servicing_config_model.dart';
import 'package:privo/app/modules/faq/faq_page.dart';
import 'package:privo/app/modules/faq/faq_utility.dart';
import 'package:privo/app/modules/loan_details/widgets/document_button_widget.dart';
import 'package:privo/app/modules/payment/model/loan_breakdown_model.dart';
import 'package:privo/app/modules/payment/model/payment_view_model.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_analytics.dart';
import 'package:privo/app/utils/app_dialogs.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';
import 'package:privo/components/badges/cs_badge.dart';
import 'package:privo/components/bottom_sheet/simple_bottom_sheet.dart';
import 'package:privo/components/svg_icon.dart';
import 'package:privo/res.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../api/response_model.dart';
import '../../common_widgets/bottom_sheet_widget.dart';
import '../../common_widgets/gradient_button.dart';
import '../../common_widgets/overdue_details_bottom_sheet.dart';
import '../../common_widgets/spacer_widgets.dart';
import '../../components/pill_button.dart';
import '../../data/repository/emi_repository.dart';
import '../../data/repository/loan_details_repository.dart';
import '../../firebase/analytics.dart';
import '../../models/document_model.dart';
import '../../models/loan_details_model.dart';
import '../../models/signed_url_model.dart';
import '../../routes/app_pages.dart';
import '../../theme/app_colors.dart';
import '../../utils/app_functions.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/web_engage_constant.dart';
import '../faq/widget/faq_tile.dart';
import '../help_support/widget/contact_us_card.dart';
import '../on_boarding/mixins/app_form_mixin.dart';
import '../payment/widgets/payment_know_more_bottom_sheet.dart';
import '../pdf_document/pdf_document_logic.dart';
import '../re_payment_type_selector/re_payment_type_selector_logic.dart';
import 'loan_details_analytics_mixin.dart';
import 'widgets/foreclosure_non_eligible_knowmore_widget.dart';
import 'widgets/loan_documents_bottom_sheet.dart';

enum RowType { top, bottom }

enum ContactUsSvgStyle { fill, outline }

class LoanDetailsLogic extends GetxController
    with
        AppFormMixin,
        ApiErrorMixin,
        AdvanceEMIPaymentMixin,
        LoanDetailsAnalyticsMixin,
        PaymentLoansListAnalytics {
  late LoanDetailsModel loanDetailModel;
  List<Widget> documentsList = [];
  List<Widget> emiDocumentsList = [];

  EmiRepository emiRepository = EmiRepository();

  LoanDetailsRepository loanDetailsRepository = LoanDetailsRepository();

  AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel;
  ForeclosurePaymentInfoModel? foreclosePaymentInfoModel;

  LoanProductCode loanProductCode = LoanProductCode.clp;

  late String LOAN_DETAILS_SCREEN = "loan_details";

  final double BOTTOM_ITEM_SPACE = 40;

  late AppForm appForm;

  var arguments = Get.arguments;

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  late Loans loans;
  late LoanDocumentsModel model;

  final String OVERLAY_WIDGET_KEY = 'overlay_widget_key';

  bool _enableOverlay = false;

  bool get enableOverlay => _enableOverlay;

  set enableOverlay(bool value) {
    _enableOverlay = value;
    update([OVERLAY_WIDGET_KEY]);
  }

  void onOptionMenuTap() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.menuClicked,
    );

    toggleOverlay(overlayValue: true);
  }

  void toggleOverlay({required bool overlayValue}) {
    enableOverlay = overlayValue;
  }

  @override
  void onInit() {
    loans = arguments['loan_details'];
    super.onInit();
  }

  void onAfterLayout() {
    _getLoanDetails();
  }

  ///fetch data by passing referenceID
  Future<void> _getLoanDetails() async {
    isPageLoading = true;
    LoanDetailsModel loanDetailModel =
        await emiRepository.getLoanDetails(loanId: loans.loanId);
    switch (loanDetailModel.apiResponse.state) {
      case ResponseState.success:
        this.loanDetailModel = loanDetailModel;
        _logWebEngageEvents();
        if (!isClosedLoan()) {
          _getPaymentDetails();
        } else {
          _getDocuments();
        }
        break;
      default:
        handleAPIError(loanDetailModel.apiResponse,
            screenName: LOAN_DETAILS_SCREEN, retry: _getLoanDetails);
        break;
    }
  }

  bool isClosedLoan() => loanDetailModel.loanStatus == LoanStatus.closed;

  void _getPaymentDetails() async {
    if (loanDetailModel.foreClosurePaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      _getForeClosurePaymentDetails();
    }

    if (loanDetailModel.advanceEMIPaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      _getAdvanceEMIPaymentDetails();
    }

    if (loanDetailModel.overduePaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      logOverdueCTALoadedEvent(
        overDueAmount: loanDetailModel.totalPendingAmount,
        loanId: loanDetailModel.loanId,
      );
    }

    _getDocuments();
    return;
  }

  Future _getAdvanceEMIPaymentDetails() async {
    await getAdvanceEMIPaymentInfoFromAPI(
      loanId: loanDetailModel.loanId,
      loanStartDate: loanDetailModel.loanStartDate,
      nextDueDate: loanDetailModel.nextDueDate,
      onSuccess: (AdvanceEMIPaymentInfoModel advanceEMIPaymentInfoModel) {
        this.advanceEMIPaymentInfoModel = advanceEMIPaymentInfoModel;
        logAdvanceEMICTALoadedEvent(
          advanceEMIDueAmount: advanceEMIPaymentInfoModel.emiAmount.toString(),
          loanId: advanceEMIPaymentInfoModel.loanId,
        );
        _getForeClosurePaymentDetails();
      },
      onFailure: (ApiResponse apiResponse) {
        handleAPIError(
          apiResponse,
          screenName: LOAN_DETAILS_SCREEN,
          retry: _getAdvanceEMIPaymentDetails,
        );
      },
    );
  }

  Future _getForeClosurePaymentDetails() async {
    ForeclosurePaymentInfoModel paymentInfoModel =
        await emiRepository.getForeclosePaymentInfo(
      loanId: loanDetailModel.loanId,
      loanStartDate: loanDetailModel.loanStartDate,
      paymentType: 'foreClose',
      nextDueDate: loanDetailModel.nextDueDate,
    );
    switch (paymentInfoModel.apiResponse.state) {
      case ResponseState.success:
        foreclosePaymentInfoModel = paymentInfoModel;
        _getDocuments();
        logBPIAmountLoaded(foreclosePaymentInfoModel!.bpiCharges);
        break;
      default:
        handleAPIError(
          paymentInfoModel.apiResponse,
          screenName: LOAN_DETAILS_SCREEN,
          retry: _getForeClosurePaymentDetails,
        );
    }
  }

  _getDocuments() async {
    model = await loanDetailsRepository.getLoanDocuments(
        loans.loanId, loans.loanProductCode);
    switch (model.apiResponse.state) {
      case ResponseState.success:
        _configureDocumentWidgets(model);
        isPageLoading = false;
        break;
      default:
        handleAPIError(
          model.apiResponse,
          screenName: LOAN_DETAILS_SCREEN,
          retry: _getDocuments,
        );
    }
  }

  void _onInsuranceCertificateTapped(Function()? onTapCallBack) {
    if (onTapCallBack == null) {
      logCoiClicked(loans.loanId);
      fetchLetter(DocumentType.insuranceCertificate, "CERTIFICATE_OF_INSURANCE",
          loanDetailModel.loanId);
    } else {
      onTapCallBack();
    }
  }

  void _onNocTapped(Function()? onTapCallBack) {
    if (model.nocDocument != null) {
      switch (model.nocDocument!.status) {
        case DocStatus.show:
          showNocLetter(onTapCallBack);
          break;
        case DocStatus.hide:
          showNocBottomsheet();
          break;
        case DocStatus.redirect:
          _showContactSupportBottomSheetWithBlueBackground(
              "NOC update", model.nocDocument!.reason);
          break;
      }
    }
  }

  showNocLetter(Function()? onTapCallBack) {
    if (onTapCallBack == null) {
      logNocClicked(loans.loanId);
      fetchLetter(
          DocumentType.nocLetter, "NOC_CREDIT_LINE", loanDetailModel.loanId);
    } else {
      logFiveDaysNocTriggered(loans.loanId);
      onTapCallBack();
    }
  }

  void showNocBottomsheet() {
    Get.bottomSheet(
      SimpleBottomSheet(
        title: "NOC update",
        subTitle: model.nocDocument!.reason,
        body: VerticalSpacer(32.h),
      ),
    );
  }

  void _configureDocumentWidgets(LoanDocumentsModel model) {
    documentsList.clear();
    emiDocumentsList.clear();
    for (Document document in model.documents) {
      switch (document.status) {
        case DocStatus.show:
          computeDocument(docType: document.document);
          break;
        case DocStatus.hide:
          _onHideDocument(document);
          break;
        case DocStatus.redirect:
          _onHideDocument(document);
      }
    }
    documentsList.add(PillButton(
        text: "Loan documents",
        isSelected: false,
        trailing: Res.accordingRight,
        onTap: () {
          logLoanDocumentsClicked(loanDetailModel.loanId);
          Get.bottomSheet(LoanDocumentsBottomSheet(), isDismissible: false);
        }));
  }

  Widget? computeDocument(
      {Function()? onTapCallBack, required String docType}) {
    switch (docType) {
      case "SCHEDULE_LETTER":
        emiDocumentsList.add(
          PillButton(
            text: "EMI schedule",
            onTap: () {
              _emiScheduleOnTap(onTapCallBack);
            },
            isSelected: false,
            leading: Res.download,
          ),
        );
        break;
      case "SOA":
        emiDocumentsList.add(
          PillButton(
            text: "Loan statement",
            onTap: () {
              _onSoaTapped(onTapCallBack);
            },
            isSelected: false,
            leading: Res.download,
          ),
        );
        break;
      case "COI":
        loans.isInsured
            ? documentsList.add(
                PillButton(
                  text: "Insurance certificate",
                  onTap: () {
                    _onInsuranceCertificateTapped(onTapCallBack);
                  },
                  leading: Res.download,
                  isSelected: false,
                ),
              )
            : null;
        break;
      case "NOC_LETTER":
        loanDetailModel.loanStatus == LoanStatus.closed
            ? emiDocumentsList.add(
                PillButton(
                  text: "NOC",
                  onTap: () {
                    _onNocTapped(onTapCallBack);
                  },
                  isSelected: false,
                  leading: Res.description,
                ),
              )
            : null;
        break;
      default:
        return null;
    }
  }

  void _onHideDocument(Document document) {
    if (document.reason.isNotEmpty) {
      _addDocument(
        computeDocument(
          docType: document.document,
          onTapCallBack: () {
            _onHideDocumentTapped(document);
          },
        ),
      );
    }
  }

  void _onHideDocumentTapped(Document document) {
    AppDialogs.appDefaultDialog(
        title: "Sorry!",
        actions: [
          Expanded(
            child: BlueButton(
                onPressed: () {
                  Get.back();
                },
                title: "OKAY",
                buttonColor: activeButtonColor),
          )
        ],
        content: document.reason);
  }

  void _onSoaTapped(Function()? onTapCallBack) {
    if (onTapCallBack == null) {
      logStatementsClicked(loans.loanId);
      onStatementClicked(
        loanDetailModel.loanId,
        loanDetailModel.loanStartDate,
      );
    } else {
      onTapCallBack();
    }
  }

  void _emiScheduleOnTap(Function()? onTapCallBack) {
    if (onTapCallBack == null) {
      logEmiScheduleClicked(loans.loanId);
      fetchLetter(
        DocumentType.scheduleLetter,
        "SCHEDULE_LETTER",
        loanDetailModel.loanId,
      );
    } else {
      onTapCallBack();
    }
  }

  void _addDocument(Widget? documentWidget) {
    if (documentWidget != null) {
      documentsList.add(documentWidget);
    }
  }

  double itemSpacing({RowType rowType = RowType.top}) {
    switch (rowType) {
      case RowType.top:
        return 15;
      case RowType.bottom:
        return 40;
    }
  }

  fetchLetter(DocumentType documentType, String fileName, String loanId) async {
    await Get.toNamed(
      Routes.PDF_DOCUMENT_SCREEN,
      arguments: {
        'documentType': documentType,
        'fileName': fileName,
        'loanId': loanId,
        'appFormId': loanDetailModel.appFormId
      },
    );
  }

  goToTransactionHistory() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.paymentHistoryCTAClicked,
        attributeName: {
          "LAN": loanDetailModel.loanId,
        });
    Get.toNamed(Routes.TRANSACTION_HISTORY, arguments: {
      "loanDetails": loanDetailModel,
    });
  }

  Future<void> onPartPayClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.knowMore,
      attributeName: {
        "loan_details_page": true,
        "partpay_cta": true,
      },
    );
    await goToPaymentScreen(_getPartPaymentArgument());
  }

  Future<dynamic> goToPaymentScreen(
      PaymentViewArgumentModel paymentViewArgumentModel) async {
    return await PaymentNavigationService().navigate(
      routeArguments: paymentViewArgumentModel,
    );
  }

  PaymentViewArgumentModel _getPartPaymentArgument() {
    return PaymentViewArgumentModel(
        loanId: loanDetailModel.loanId,
        appFormID: loanDetailModel.appFormId,
        paymentType: PaymentType.partPay,
        breakdownRowData: [],
        bottomWidgetPadding:
            const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        finalPayableAmount: double.parse(loanDetailModel.loanAmount));
  }

  void onPartPayKnowMoreClicked() async {
    await Get.bottomSheet(
      PaymentKnowMoreBottomSheet(
        onPressMoreFAQ: () async {
          await Get.to(
            () => FAQPage(
              faqModel: FAQUtility().partPayFAQs,
            ),
          );
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.closeScreen,
            attributeName: {
              "close_faq_partpay": true,
            },
          );
        },
        paymentNotEnabledTitles: [],
        faqTile: const FAQTile(
          answer:
              "Yes, part payments can easily be done via Credit Saison India app.",
          question: "Can I make part-payments through the mobile app?",
          isExpandEnabled: false,
        ),
        body:
            "The Part-pay feature is an option for paying off the outstanding balance (remaining EMIs). Once you Part-pay, your limit will be adjusted. You’re ready to start withdrawing the amount whenever you want.",
        bottomWidget: _prePayFaqBottomWidget(),
        paymentNotEnabledString: "",
      ),
    );
  }

  Padding _prePayFaqBottomWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          GradientButton(
            title: "Pay now",
            onPressed: onPartPayClicked,
            enabled: true,
            isLoading: false,
          ),
        ],
      ),
    );
  }

  onStatementClicked(String referenceId, String startDate) async {
    String fromStartDate =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(startDate));
    await computeSoaFromDB(referenceId, fromStartDate);
  }

  ///Get statement letter
  computeSoaFromDB(String loanId, String fromStartDate) async {
    _showLoadingDialog();
    String currentDateTime = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DocumentModel _documentModel =
        await loanDetailsRepository.getStatementOfAccount(
            loanId: loanId,
            fromDate: fromStartDate,
            toDate: currentDateTime.toString());
    switch (_documentModel.apiResponse.state) {
      case ResponseState.success:
        await _onDocumentModel(_documentModel);
        break;
      default:
        Get.back();
        ErrorLoggerMixin().logErrorWithApiResponse(_documentModel.apiResponse);
        _showContactSupportBottomSheetWithBlueBackground("Document unavailable",
            "The document is unavailable currently, please contact customer support");
    }
  }

  Future<void> _onDocumentModel(DocumentModel _documentModel) async {
    SignedUrlModel signedUrlModel =
        await loanDetailsRepository.getUrlSigned(_documentModel.outputUrl);
    switch (signedUrlModel.apiResponse.state) {
      case ResponseState.success:
        await _onDownloadSoaSuccess(signedUrlModel.url);
        break;
      default:
        handleAPIError(
          signedUrlModel.apiResponse,
          screenName: LOAN_DETAILS_SCREEN,
        );
        break;
    }
  }

  Future<void> _onDownloadSoaSuccess(String url) async {
    await Get.toNamed(Routes.PDF_DOCUMENT_SCREEN, arguments: {
      'url': url,
      'fileName': 'SOA',
      'documentType': DocumentType.soaLetter,
      'appFormId': loanDetailModel.appFormId
    });
    Get.back();
  }

  _showLoadingDialog() {
    Get.defaultDialog(
      title: "Please wait..",
      titleStyle: const TextStyle(fontSize: 12),
      onWillPop: () async {
        return false;
      },
      barrierDismissible: false,
      content: const CircularProgressIndicator(),
    );
  }

  Future<void> onOverdueCTAClicked() async {
    logOverduePayAmountClickedEvent(
      overDueAmount: loanDetailModel.totalPendingAmount,
      loanId: loanDetailModel.loanId,
    );

    await Get.toNamed(Routes.RE_PAYMENT_TYPE_SELECTOR, arguments: {
      'loanDetails': loanDetailModel,
      'paymentType': RePaymentType.fullPayment,
    });

    isPageLoading = true;
    onAfterLayout();
  }

  void onForeclosureKnowMoreClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.knowMore,
      attributeName: {
        "loan_details_page": true,
        "prepay_cta": true,
      },
    );

    await Get.bottomSheet(
      isScrollControlled: true,
      PaymentKnowMoreBottomSheet(
        onPressMoreFAQ: () async {
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.seeMoreFAQ,
            attributeName: {
              "faq_prepay": true,
            },
          );
          await Get.to(
            () => FAQPage(
              faqModel: FAQUtility().foreClosureFAQs,
            ),
          );
          AppAnalytics.trackWebEngageEventWithAttribute(
            eventName: WebEngageConstants.closeScreen,
            attributeName: {
              "close_faq_prepay": true,
            },
          );
        },
        paymentNotEnabledTitles: [],
        disableFaq: true,
        faqTile: const SizedBox(),
        body:
            "The Foreclosure option lets you repay the outstanding balance in full before the scheduled end date. After payment, the request will be processes and your loan will be considered fully closed. Learn more with",
        loanBreakdownModel: _getForeClosureLoanBreakDownModel(),
        bottomWidget: _bottomInfoWidget(),
        paymentNotEnabledString: loanDetailModel
                    .foreClosurePaymentTypeDetails.type ==
                PaymentTypeStatus.eligible
            ? ""
            // : "Coming Soon!",
            : "You cannot foreclose your loan in the first month. Please try again in a few days",
      ),
    );
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.closeScreen,
      attributeName: {
        "close_know_more_modal_prepay": true,
      },
    );
  }

  goToHelp() {
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.getHelpClicked,
      attributeName: {
        (loanDetailModel.isLoanCancellationEnabled
            ? "cancellation_page_eligible"
            : "cancellation_page_ineligible"): true,
      },
    );
    Get.toNamed(Routes.HELP_AND_SUPPORT, arguments: {
      "loanID": loans.loanId,
      "appFormId": loans.appFormId,
      "showLoanCancellation": loanDetailModel.isLoanCancellationEnabled,
    });
    toggleOverlay(overlayValue: false);
  }

  LoanBreakdownModel _getForeClosureLoanBreakDownModel() {
    List<LoanBreakdownRowData> breakdownRowData = [
      LoanBreakdownRowData(
        key: "Principal outstanding",
        keyTextStyle:
            AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
        valueTextStyle:
            AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
        value: AppFunctions.getIOFOAmount(
          foreclosePaymentInfoModel?.principalOutStanding.toDouble() ?? 0,
        ),
      ),
      LoanBreakdownRowData(
        key: "Pre-payment charges",
        keyTextStyle:
            AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
        valueTextStyle:
            AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
        value: AppFunctions.getIOFOAmount(
          foreclosePaymentInfoModel?.prepaymentCharges.toDouble() ?? 0,
        ),
      ),
      LoanBreakdownRowData(
        key: "Interest Calculation",
        keyTextStyle:
            AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
        valueTextStyle:
            AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
        value: AppFunctions.getIOFOAmount(
          foreclosePaymentInfoModel?.currentInterest.toDouble() ?? 0,
        ),
      ),
    ];
    // if ((foreclosePaymentInfoModel?.bpiCharges != null)) {
    //   breakdownRowData.add(LoanBreakdownRowData(
    //     key: "BPI charges",
    //     keyTextStyle:
    //         AppTextStyles.bodySRegular(color: AppTextColors.neutralDarkBody),
    //     valueTextStyle:
    //         AppTextStyles.bodySMedium(color: AppTextColors.neutralDarkBody),
    //     value: "- ${AppFunctions.getIOFOAmount(
    //       foreclosePaymentInfoModel?.bpiCharges!.toDouble() ?? 0,
    //     )}",
    //   ));
    // }
    return LoanBreakdownModel(
      showDivider: true,
      backgroundColor: Colors.white,
      bottomBarColor: Colors.transparent,
      title: "Amount breakdown",
      titleTextStyle:
          AppTextStyles.headingSMedium(color: AppTextColors.brandBlueBodyFocus),
      breakdownRowData: breakdownRowData,
      padding: EdgeInsets.zero,
      bottomWidgetPadding: EdgeInsets.zero,
      bottomWidget: _breakdownRow(
        "Remaining amount payable",
        AppFunctions.getIOFOAmount(
          foreclosePaymentInfoModel?.totalAmount.toDouble() ?? 0,
        ),
      ),
    );
  }

  Widget _bottomInfoWidget() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 16.h,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppBackgroundColors.primarySubtle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.r),
          bottomRight: Radius.circular(8.r),
        ),
      ),
      child: Center(
        child: Text(
          "By foreclosing, your credit score will not get affected",
          style:
              AppTextStyles.bodySRegular(color: AppTextColors.brandBlueTitle),
        ),
      ),
    );
  }

  TextStyle get _tableValueTextStyle {
    return GoogleFonts.poppins(
      fontSize: 14,
      color: primaryDarkColor,
      fontWeight: FontWeight.w600,
    );
  }

  LoanBreakdownRowData _getBreakdownRowData(String key, num value,
      {bool isNegativeValue = false}) {
    return LoanBreakdownRowData(
      key: key,
      value: isNegativeValue
          ? "- ${_parseIntToString(value)}"
          : _parseIntToString(value),
      valueTextStyle: _tableValueTextStyle,
    );
  }

  String _parseIntToString(num num) {
    return '₹${AppFunctions().parseIntoCommaFormat(num.toString())}';
  }

  Future<void> onForeclosePayClicked() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.prepayClicked);
    await goToPaymentScreen(_getForeclosurePaymentArgument());

    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.closeScreen,
      attributeName: {
        "close_prepay_payment": true,
      },
    );
    _getLoanDetails();
  }

  Future<void> onAdvanceEMIPayClicked() async {
    switch (loanDetailModel.advanceEMIPaymentTypeDetails.type) {
      case PaymentTypeStatus.eligible:
        if (advanceEMIPaymentInfoModel != null) {
          logCTAPayClicked("loan_details");
          await goToPaymentScreen(
            getAdvanceEMIPaymentArgument(
                advanceEMIPaymentInfoModel: advanceEMIPaymentInfoModel!,
                loanDetailModel: loanDetailModel),
          );
        }
        AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.closeScreen,
          attributeName: {
            "close_upcoming_due_payment": true,
          },
        );
        _getLoanDetails();
        break;
      case PaymentTypeStatus.nonEligible:
        onAdvanceEMIKnowMoreClicked();
        break;
      case PaymentTypeStatus.unAvailable:
        Get.bottomSheet(
          SimpleBottomSheet(
            title: loanDetailModel.advanceEMIPaymentTypeDetails.title,
            subTitle: loanDetailModel.advanceEMIPaymentTypeDetails.message,
            body: VerticalSpacer(32.h),
          ),
        );
        break;
    }
  }

  PaymentViewArgumentModel _getForeclosurePaymentArgument() {
    List<LoanBreakdownRowData> breakdownData = [
      _getBreakdownRowData("Principal outstanding",
          foreclosePaymentInfoModel!.principalOutStanding),
      _getBreakdownRowData("Interest calculation",
          foreclosePaymentInfoModel!.currentInterest),
      _getBreakdownRowData(
          "Pre-payment charges", foreclosePaymentInfoModel!.prepaymentCharges),
    ];
    // if (foreclosePaymentInfoModel!.bpiCharges != null) {
    //   breakdownData.add(_getBreakdownRowData(
    //       "BPI charges", foreclosePaymentInfoModel!.bpiCharges!,
    //       isNegativeValue: true));
    // }
    return PaymentViewArgumentModel(
        loanId: loanDetailModel.loanId,
        appFormID: loanDetailModel.appFormId,
        paymentType: PaymentType.foreclosure,
        breakdownRowData: breakdownData,
        totalAmoutKey: "Total amount",
        totalAmountValue:
            _parseIntToString(foreclosePaymentInfoModel!.totalAmount),
        finalPayableAmount: foreclosePaymentInfoModel!.totalAmount);
  }

  void onAdvanceEMIKnowMoreClicked() async {
    await onAdvanceEMIKnowMorePressed(advanceEMIPaymentInfoModel,
        advanceEmi: loanDetailModel.advanceEMIPaymentTypeDetails);
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.closeScreen,
      attributeName: {
        "close_know_more_modal_upcoming_dues": true,
      },
    );
  }

  TextStyle _commonTextStyle(
      {double fontSize = 10,
      FontWeight fontWeight = FontWeight.w400,
      Color color = Colors.black}) {
    return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Figtree',
        height: 1.4,
        color: color);
  }

  Widget _breakdownRow(String key, String value) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Text(
            key,
            style: _commonTextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: _commonTextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  void _logWebEngageEvents() {
    _sendLoanCancellationWebengageEvent();
    _sendTransactionHistoryWebengageEvent();
    if (loanDetailModel.loanStatus == LoanStatus.closed) {
      logClosedLoanLoaded(
        loanDetailModel.loanId,
        loanDetailModel.loanAmount,
        loans.isInsured,
      );
      logNocCtaLoaded(loanDetailModel.loanId);
    } else {
      logActiveLoanLoaded(
        loanDetailModel.loanId,
        loanDetailModel.loanAmount,
        loans.isInsured,
      );
    }
    logEmiScheduleCtaLoaded(loanDetailModel.loanId);
    logStatementsCtaLoaded(loanDetailModel.loanId);
    if (loans.isInsured) {
      logCoiCtaLoaded(loanDetailModel.loanId);
    }
  }

  _sendLoanCancellationWebengageEvent() {
    if (loanDetailModel.isLoanCancellationEnabled) {
      AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.loanCancellationAvailable,
      );
    }
  }

  _sendTransactionHistoryWebengageEvent() {
    if (loanDetailModel.paymentHistoryEnabled) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.paymentHistoryCTALoaded,
          attributeName: {
            "LAN": loanDetailModel.loanId,
          });
    }
  }

  onTapForeclosureKnowMore() {
    switch (loanDetailModel.foreClosurePaymentTypeDetails.type) {
      case PaymentTypeStatus.eligible:
        onForeclosureKnowMoreClicked();
        break;
      case PaymentTypeStatus.nonEligible:
      case PaymentTypeStatus.unAvailable:
        Get.bottomSheet(const ForeclosureNonEligibleKnowMoreWidget(),
            isDismissible: false);
        break;
    }
  }

  void onTapForecloseCTA() {
    switch (loanDetailModel.foreClosurePaymentTypeDetails.type) {
      case PaymentTypeStatus.eligible:
        onForeclosePayClicked();
        break;
      case PaymentTypeStatus.nonEligible:
        Get.bottomSheet(
          SimpleBottomSheet(
            title: loanDetailModel.foreClosurePaymentTypeDetails.title,
            subTitle: loanDetailModel.foreClosurePaymentTypeDetails.message,
          ),
        );
        break;
      case PaymentTypeStatus.unAvailable:
        _showContactSupportBottomSheet();
        break;
    }
  }

  void _showContactSupportBottomSheet() {
    Get.bottomSheet(
      SimpleBottomSheet(
        title: "Please contact customer support for foreclosure",
        body: contactUsTile(ContactUsSvgStyle.fill),
      ),
    );
  }

  Widget contactUsTile(ContactUsSvgStyle style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (style == ContactUsSvgStyle.outline) VerticalSpacer(12.h),
        ContactUsTile(
          iconPath: (style == ContactUsSvgStyle.outline)
              ? Res.newPhoneSvg
              : Res.phoneImg,
          title: "Helpline (9:30am - 6:30pm)",
          subtitle: "1800-1038-961",
          onTap: () {
            launchUrlString('tel:18001038961',
                mode: LaunchMode.externalApplication);
          },
        ),
        ContactUsTile(
          iconPath: (style == ContactUsSvgStyle.outline)
              ? Res.newMailSvg
              : Res.mailImg,
          title: "Mail to",
          subtitle: "support@creditsaison-in.com",
          onTap: () {
            launchUrlString("mailto:support@creditsaison-in.com");
          },
        ),
        if (style == ContactUsSvgStyle.outline) VerticalSpacer(12.h),
      ],
    );
  }

  void _showContactSupportBottomSheetWithBlueBackground(
      String title, String subTitle) {
    Get.bottomSheet(BottomSheetWidget(
      childPadding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: AppTextStyles.headingSMedium(
                color: AppTextColors.brandBlueTitle,
              ),
            ),
          ),
          VerticalSpacer(12.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              subTitle,
              textAlign: TextAlign.start,
              style: AppTextStyles.bodySRegular(
                color: AppTextColors.neutralBody,
              ),
            ),
          ),
          VerticalSpacer(24.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
                color: primaryLightColor),
            child: contactUsTile(ContactUsSvgStyle.outline),
          ),
        ],
      ),
    ));
  }

  onTapOverdueKnowMore() {
    Get.bottomSheet(
      OverDueDetailsBottomSheet(
        loanDetailsModel: loanDetailModel,
        referenceId: loanDetailModel.loanId,
      ),
      isScrollControlled: true,
    );
  }

  void onSanctionLetterTapped({Function()? onTapCallBack}) {
    Get.back();
    logSanctionLetterClicked(loanDetailModel.loanId);
    fetchLetter(
      DocumentType.sanctionLetter,
      "sanction_letter",
      loanDetailModel.loanId,
    );
  }

  void onAgreementLetter({Function()? onTapCallBack}) {
    Get.back();
    logAgreementLetterClicked(loanDetailModel.loanId);
    fetchLetter(
      DocumentType.agreementLetter,
      "loan_agreement",
      loanDetailModel.loanId,
    );
  }

  computeSecondaryWidget() {
    if (loanDetailModel.loanStatus == LoanStatus.closed) {
      return const CSBadge(
        text: "Closed",
      ).neutral(showLeadingIcon: false);
    }

    if (loanDetailModel.overduePaymentTypeDetails.type ==
        PaymentTypeStatus.eligible) {
      return CSBadge(
        text: loanDetailModel.isPendingPayment ? "Pending amount" : "Overdue",
        textStyle: AppTextStyles.bodyXSMedium(color: red700),
      ).negative(showLeadingIcon: false);
    }

    if (loanDetailModel.paymentType == PaymentType.loanCancellation) {
      return const CSBadge(
        text: "Cancelled",
      ).negative(type: CSBadgeType.outlined, showLeadingIcon: false);
    }
  }

  String computeOverdueCardTitle() {
    if (loanDetailModel.isPendingPayment) return "Pending amount";
    return "Overdue alert";
  }

  void onEmiInProgressTapped() {
    Get.bottomSheet(SimpleBottomSheet(
      title: "EMI payment is in progress",
      subTitle:
          "We're currently processing your EMI payment. In some cases, it might take 24-48 hours to reflect in your app",
      body: VerticalSpacer(20.h),
    ));
  }
}
