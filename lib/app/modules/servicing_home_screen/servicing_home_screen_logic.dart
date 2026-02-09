import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/data/repository/emi_repository.dart';
import 'package:privo/app/models/check_app_form_model.dart';

import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/servicing_home_screen/servicing_analytics_mixin.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

import '../../data/repository/loan_details_repository.dart';
import '../../firebase/analytics.dart';
import '../../models/home_screen_model.dart';
import '../../models/loan_details_model.dart';
import '../../models/loans_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/web_engage_constant.dart';
import '../pdf_document/pdf_document_logic.dart';
import 'loans_tab_model.dart';

///Class to control the backend details of the Home screen view
class ServicingHomeScreenLogic extends GetxController
    with
        ApiErrorMixin,
        AppFormMixin,
        ErrorLoggerMixin,
        GetSingleTickerProviderStateMixin,
        ServicingAnalyticsMixin {
  final String OVERLAY_WIDGET_ID = 'overlay_widget_id';

  bool _enableOverlay = false;

  bool get enableOverlay => _enableOverlay;

  set enableOverlay(bool value) {
    _enableOverlay = value;
    update([OVERLAY_WIDGET_ID]);
  }

  late String ALL_LOANS_DASHBOARD_SCREEN = "all_loans_dashboard";

  EmiRepository emiRepository = EmiRepository();
  LoanDetailsRepository loanDetailsRepository = LoanDetailsRepository();
  LoanProductCode loanProductCode = LoanProductCode.clp;

  bool _isPageLoading = true;

  bool get isPageLoading => _isPageLoading;

  set isPageLoading(bool value) {
    _isPageLoading = value;
    update();
  }

  final String TABBAR_VIEW_ID = 'tab_bar_view_id';

  bool _tabBarViewLoading = true;

  bool get tabBarViewLoading => _tabBarViewLoading;

  set tabBarViewLoading(bool value) {
    _tabBarViewLoading = value;
    update([TABBAR_VIEW_ID]);
  }

  late LoanDetailsModel loanDetailModel;

// bool offerUpgradeHistoryAvailable = false;
  late AppForm appForm;

  var arguments = Get.arguments;

  late final TabController tabController = TabController(
    length: LPCService.instance.lpcCards.length,
    vsync: this,
    initialIndex: arguments == null ? 0 : arguments['tab_index'] ?? 0,
  );

  List<LpcCard> get _lpcCards => LPCService.instance.lpcCards;

  List<LoansTabModel> lpcTabList = [];

  LoansTabModel get activeLoanTab => lpcTabList[tabController.index];

  void onAfterLayout() {
    _generateTabBarItems();
    logLoanDashboardLoadedEvent(_lpcCards);
  }

  void _generateTabBarItems() {
    Get.log("generateTabList");
    isPageLoading = true;
    for (LpcCard card in _lpcCards) {
      lpcTabList.add(
        LoansTabModel(
          title: card.loanProductName,
          appFormId: card.appFormId,
          cif: card.customerCif,
          state: card.customerCif.isEmpty
              ? LoanTabState.empty
              : LoanTabState.loading,
        ),
      );
    }
    LPCService.instance.activeCard = _lpcCards[tabController.index];
    if (lpcTabList.length > 1) {
      tabController.addListener(() {
        if (!tabController.indexIsChanging) {
          Get.log("tab index - ${tabController.index}");
          LPCService.instance.activeCard = _lpcCards[tabController.index];
          _getAppForm();
        }
      });
    }
    isPageLoading = false;
    _getAppForm();
  }

  _getAppForm() {
    tabBarViewLoading = true;
    if (activeLoanTab.state != LoanTabState.empty) {
      _checkForUpgradeHistory();
    } else {
      tabBarViewLoading = false;
    }
  }

  _checkForUpgradeHistory() {
    if (activeLoanTab.offerHistoryAvailable == null) {
      getAppForm(
        onApiError: _onAppformError,
        onRejected: _onAppformRejected,
        onSuccess: _onAppformSuccess,
      );
    } else {
      _checkActiveLoanModel();
    }
  }

  _checkActiveLoanModel() {
    if (activeLoanTab.loansModel == null) {
      _getLoans();
    } else {
      activeLoanTab.state = LoanTabState.success;
      tabBarViewLoading = false;
    }
  }

  _onAppformError(ApiResponse apiResponse) {
    activeLoanTab.state = LoanTabState.error;
    _logError(apiResponse);
    tabBarViewLoading = false;
  }

  _onAppformRejected(CheckAppFormModel checkAppFormModel) {}

  _onAppformSuccess(AppForm appForm) {
    activeLoanTab.offerHistoryAvailable = appForm.offerUpgradeHistoryAvailable;
    this.appForm = appForm;
    _checkActiveLoanModel();
  }

  Future<void> _getLoans() async {
    tabBarViewLoading = true;
    LoansModel loansModel =
        await emiRepository.getLoans(customerId: AppAuthProvider.getCif);
    switch (loansModel.apiResponse.state) {
      case ResponseState.success:
        activeLoanTab.loansModel = loansModel;
        activeLoanTab.state = LoanTabState.success;
        await Future.delayed(const Duration(milliseconds: 500));
        tabBarViewLoading = false;
        break;
      case ResponseState.failure:
      case ResponseState.badRequestError:
        await _checkIfCustomerIsInvalid(loansModel);
        break;
      default:
        activeLoanTab.state = LoanTabState.error;
        _logError(loansModel.apiResponse);
        tabBarViewLoading = false;
        // handleAPIError(loansModel.apiResponse,
        //     screenName: HOME_PAGE_SCREEN, retry: _getLoans);
        break;
    }
  }

  void _logError(ApiResponse apiResponse) {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.somethingWentWrongPopup,
        attributeName: {"screen_name": ALL_LOANS_DASHBOARD_SCREEN});
    logError(
      url: apiResponse.url,
      exception: apiResponse.exception,
      requestBody: apiResponse.requestBody,
      responseBody: apiResponse.apiResponse,
      statusCode: apiResponse.statusCode.toString(),
    );
  }

  String computeTitle() {
    if (lpcTabList.length > 1) return "Loan Dashboard";
    return lpcTabList.first.title;
  }

  LpcCard? lpcCard() {
    if (lpcTabList.length > 1) return _lpcCards[tabController.index];
    return _lpcCards.first;
  }

  void onTapLoanTabRetry() {
    _getAppForm();
  }

  Future<void> _checkIfCustomerIsInvalid(LoansModel model) async {
    if (model.apiResponse.apiResponse.contains('customerId is invalid')) {
      activeLoanTab.loansModel = LoansModel(
        customerId: AppAuthProvider.getCif,
        activeLoans: [],
        closedLoans: [],
      );
      activeLoanTab.state = LoanTabState.empty;
      tabBarViewLoading = false;
    } else {
      activeLoanTab.state = LoanTabState.error;
      tabBarViewLoading = false;
      // handleAPIError(loansModel.apiResponse,
      //     screenName: HOME_PAGE_SCREEN, retry: _getLoans);
    }
  }

  fetchLetter(DocumentType documentType, String fileName) async {
    await Get.toNamed(
      Routes.PDF_DOCUMENT_SCREEN,
      arguments: {
        'documentType': documentType,
        'fileName': fileName,
      },
    );
  }

  void openUpgradeHistory() async {
    AppAnalytics.trackWebEngageEventWithAttribute(
        eventName: WebEngageConstants.lgViewUpgradeHistory);
    await Get.toNamed(
      Routes.OFFER_UPGRADE_HISTORY,
      arguments: {
        'appform': appForm,
      },
    );
    enableOverlay = false;
  }

  void toggleOverlay({required bool overlayValue}) {
    enableOverlay = overlayValue;
  }

  onClickedArrow({required Loans loans}) async {
    await Get.toNamed(
      Routes.LOAN_DETAILS_SCREEN,
      arguments: {"loan_details": loans},
    );
    _getLoans();
  }

  computeMonthsOrDayAgoLoanTaken(String loanEndDate, int loanTenure) {
    DateTime givenDate = DateTime.parse(loanEndDate);
    return AppFunctions().computeMonthsOrDayAgoLoanTaken(givenDate);
  }

  bool loanNotPresent(LoansTabModel loanTab) {
    return loanTab.loansModel!.activeLoans.isEmpty &&
        loanTab.loansModel!.closedLoans.isEmpty;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
