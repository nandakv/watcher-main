import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/models/advance_emi_payment_info_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_analytics.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/primary_home_screen_card/primary_home_screen_card_logic.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_interface.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_logic.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_view.dart';
import 'package:privo/app/modules/re_payment_type_selector/re_payment_type_selector_logic.dart';
import 'package:privo/app/services/lpc_service.dart';

import '../../../../api/response_model.dart';
import '../../../../common_widgets/overdue_details_bottom_sheet.dart';
import '../../../../data/provider/auth_provider.dart';
import '../../../../data/repository/emi_repository.dart';
import '../../../../mixin/advance_emi_payment_mixin.dart';
import '../../../../models/home_screen_card_model.dart';
import '../../../../models/loans_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_functions.dart';
import '../../../../utils/error_logger_mixin.dart';

enum HomePageCard { overdue, advanceEMI, none }

enum WithdrawalDetailState { loading, success, error }

class HomePageWithdrawalAlertLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        AdvanceEMIPaymentMixin,
        HomeScreenAnalytics {
  final homeScreenLogic = Get.find<HomeScreenLogic>();

  PrimaryHomeScreenCardLogic get primaryHomeScreenLogic =>
      Get.find<PrimaryHomeScreenCardLogic>(tag: lpcCard.appFormId);

  WithdrawalDetailState _withdrawalDetailState = WithdrawalDetailState.loading;

  WithdrawalDetailState get withdrawalDetailState => _withdrawalDetailState;

  set withdrawalDetailState(WithdrawalDetailState value) {
    _withdrawalDetailState = value;
    update();
  }

  Map<dynamic, int> priorityOrder = {
    HomePageCard.overdue: 1,
    HomePageCard.advanceEMI: 2,
    HomePageCard.none: 3
  };

  bool shouldOpenAllWithdrawals = true;

  late LoansModel customerLoansModel;
  late LoanDetailsModel loanDetailsModel;
  late LoanDetailsModel overDueLoanDetailsModel;
  AdvanceEMIPaymentInfoModel? advanceEMIPaymentInfoModel;

  late int overdueLoansLength;

  late HomeScreenInterface homeScreenInterface;

  ///this model is to compute low and grow Widget
  late WithdrawalDetailsHomeScreenType? withdrawalDetailsHomeScreenType;

  late LpcCard lpcCard;

  List<HomePageCard> homePageCard = [];

  onAfterFirstLayout(
    WithdrawalDetailsHomeScreenType? withdrawalDetailsHomeScreenType,
    LpcCard lpcCard,
  ) async {
    this.lpcCard = lpcCard;
    this.withdrawalDetailsHomeScreenType = withdrawalDetailsHomeScreenType;
    await getCustomerLoans(lpcCard);
  }

  getCustomerLoans(LpcCard lpcCard) async {
    withdrawalDetailState = WithdrawalDetailState.loading;
    LoansModel model = await EmiRepository().getLoans(
      customerId: lpcCard.customerCif,
    );
    homePageCard = [];
    switch (model.apiResponse.state) {
      case ResponseState.success:
        customerLoansModel = model;
        homeScreenLogic.loansModel = model;
        overdueLoansLength = customerLoansModel.overdueLoans.length;
        if (_computeLoanId() != '') {
          await _computeLoanDetails();
        } else {
          withdrawalDetailState = WithdrawalDetailState.success;
        }
        break;
      case ResponseState.failure:
      case ResponseState.badRequestError:
        await _checkIfCustomerIsInvalid(model);
        break;
      default:
        _onApiError(model);
    }
  }

  onPressAdvanceEMIKnowMore() {
    logAdvanceEMIKnowMoreClick();
    onAdvanceEMIKnowMorePressed(advanceEMIPaymentInfoModel,
        showFAQ: true,
        advanceEmi: loanDetailsModel.advanceEMIPaymentTypeDetails);
  }

  String computeOverdueCTAText() {
    if (overdueLoansLength > 1) {
      return "Pay Now";
    }
    return "Pay ₹${_getOverduePayableAmount()}";
  }

  String _getOverduePayableAmount() {
    return AppFunctions()
        .parseIntoCommaFormat(overDueLoanDetailsModel.totalPendingAmount);
  }

  String computeOverdueAlertTitle() {
    String title = "Loan. ID: #${customerLoansModel.overdueLoans.first.loanId}";
    if (overdueLoansLength > 1) {
      return title += "\n +${overdueLoansLength - 1} more";
    }
    return title;
  }

  Function()? onOverdueKnowMore() {
    if (overdueLoansLength == 1) {
      return onSingleOverdueKnowMore;
    }
    return null;
  }

  onSingleOverdueKnowMore() {
    Get.bottomSheet(
      OverDueDetailsBottomSheet(
        loanDetailsModel: overDueLoanDetailsModel,
        referenceId: overDueLoanDetailsModel.loanId,
      ),
      isScrollControlled: true,
    );
  }

  onPressPayAdvanceEMIButton() async {
    LPCService.instance.activeCard = lpcCard;
    if (advanceEMIPaymentInfoModel == null) {
      ///Redirect to payment loan list page if more than one loan
      logAdvanceEMIPayCTAClick(
        amount: "",
        loanId: "",
        noOfEMIs: customerLoansModel.advanceEMILoans.length.toString(),
      );
      await Get.toNamed(
        Routes.PAYMENT_LOAN_LIST,
        arguments: {
          'type': PaymentLoanListType.advanceEMI,
          'loans_list': customerLoansModel.advanceEMILoans,
        },
      );
    } else {
      logAdvanceEMIPayCTAClick(
        amount: advanceEMIPaymentInfoModel!.emiAmount.toString(),
        loanId: advanceEMIPaymentInfoModel!.loanId,
        noOfEMIs: "1",
      );
      await PaymentNavigationService().navigate(
        routeArguments: getAdvanceEMIPaymentArgument(
            advanceEMIPaymentInfoModel: advanceEMIPaymentInfoModel!,
            loanDetailModel: loanDetailsModel),
      );
    }
    getCustomerLoans(lpcCard);
    homeScreenInterface.fetchHomePageV2();
  }

  _computeLoanDetails() async {
    LoanDetailsModel? loanDetailsModel =
        await _onLoanIdFetched(_computeLoanId());
    if (loanDetailsModel != null) {
      this.loanDetailsModel = loanDetailsModel;
      if (customerLoansModel.overdueLoans.isNotEmpty) {
        await _computeOverDueLoanDetails(loanDetailsModel);
      }
      if (customerLoansModel.advanceEMILoans.isNotEmpty) {
        logAdvanceEMICTALoadedEvent(
          noOfEMIs: "${customerLoansModel.advanceEMILoans.length}",
          advanceEMIDueAmount: "",
          loanId: "",
        );
        await _checkAdvanceEMILoans();
      }
      homePageCard
          .sort((a, b) => priorityOrder[a]!.compareTo(priorityOrder[b]!));
      withdrawalDetailState = WithdrawalDetailState.success;
    } else {
      withdrawalDetailState = WithdrawalDetailState.error;
    }
  }

  _checkAdvanceEMILoans() async {
    if (customerLoansModel.advanceEMILoans.length == 1) {
      await _computeAdvanceEMILoanDetails(
          customerLoansModel.advanceEMILoans.first);
    } else {
      homePageCard.add(HomePageCard.advanceEMI);
    }
  }

  _computeOverDueLoanDetails(LoanDetailsModel mainLoanDetailsModel) async {
    if (customerLoansModel.overdueLoans.first.loanId ==
        mainLoanDetailsModel.loanId) {
      overDueLoanDetailsModel = mainLoanDetailsModel;
      overDueLoanDetailsModel.dpd = customerLoansModel.overdueLoans.first.dpd;
      homePageCard.add(HomePageCard.overdue);
    } else {
      LoanDetailsModel? loanDetailsModel =
          await _onLoanIdFetched(customerLoansModel.overdueLoans.first.loanId);
      if (loanDetailsModel != null) {
        overDueLoanDetailsModel = loanDetailsModel;
        overDueLoanDetailsModel.dpd = customerLoansModel.overdueLoans.first.dpd;
        logOverdueCTALoadedEvent(
          daysPastDue: overDueLoanDetailsModel.dpd,
          noOfLoans: customerLoansModel.overdueLoans.length,
          overDueAmount: overDueLoanDetailsModel.totalPendingAmount,
          loanId: overDueLoanDetailsModel.loanId,
        );
        homePageCard.add(HomePageCard.overdue);
      } else {
        withdrawalDetailState = WithdrawalDetailState.error;
      }
    }
  }

  _computeAdvanceEMILoanDetails(Loans advanceEMILoan) async {
    LoanDetailsModel? loanDetailsModel =
        await _onLoanIdFetched(customerLoansModel.advanceEMILoans.first.loanId);
    if (loanDetailsModel != null) {
      if (loanDetailsModel.advanceEMIPaymentTypeDetails.type == PaymentTypeStatus.eligible) {
        await _getAdvanceEMIPaymentInfo(loanDetailsModel);
      }
    } else {
      withdrawalDetailState = WithdrawalDetailState.error;
    }
  }

  _getAdvanceEMIPaymentInfo(LoanDetailsModel loanDetailsModel) async {
    await getAdvanceEMIPaymentInfoFromAPI(
      loanId: loanDetailsModel.loanId,
      loanStartDate: loanDetailsModel.loanStartDate,
      nextDueDate: loanDetailsModel.nextDueDate,
      onSuccess: (AdvanceEMIPaymentInfoModel advanceEMIPaymentInfoModel) {
        logAdvanceEMICTALoadedEvent(
          noOfEMIs: "1",
          advanceEMIDueAmount: advanceEMIPaymentInfoModel.emiAmount.toString(),
          loanId: advanceEMIPaymentInfoModel.loanId,
        );
        this.advanceEMIPaymentInfoModel = advanceEMIPaymentInfoModel;
        homePageCard.add(HomePageCard.advanceEMI);
      },
      onFailure: (ApiResponse apiResponse) {
        handleAPIError(
          apiResponse,
          screenName: homeScreenLogic.HOME_PAGE_SCREEN,
          retry: () => _getAdvanceEMIPaymentInfo(loanDetailsModel),
        );
      },
    );
  }

  Future<LoanDetailsModel?> _onLoanIdFetched(String loanId) async {
    LoanDetailsModel loanDetailsModel =
        await EmiRepository().getLoanDetails(loanId: loanId);
    switch (loanDetailsModel.apiResponse.state) {
      case ResponseState.success:
        return loanDetailsModel;
      default:
        var apiResponse = loanDetailsModel.apiResponse;
        logError(
          statusCode: apiResponse.statusCode.toString(),
          responseBody: apiResponse.apiResponse,
          requestBody: apiResponse.requestBody,
          exception: apiResponse.exception,
          url: apiResponse.url,
        );
    }
    return null;
  }

  Future<void> _checkIfCustomerIsInvalid(LoansModel model) async {
    if (model.apiResponse.apiResponse.contains('customerId is invalid')) {
      customerLoansModel = LoansModel(
        customerId: AppAuthProvider.getCif,
        activeLoans: [],
        closedLoans: [],
      );
      homeScreenLogic.loansModel = customerLoansModel;
      shouldOpenAllWithdrawals = false;
      withdrawalDetailState = WithdrawalDetailState.success;
    } else {
      _onApiError(model);
    }
  }

  void _onApiError(LoansModel model) {
    var apiResponse = model.apiResponse;
    logError(
      statusCode: apiResponse.statusCode.toString(),
      responseBody: apiResponse.apiResponse,
      requestBody: apiResponse.requestBody,
      exception: apiResponse.exception,
      url: apiResponse.url,
    );
    withdrawalDetailState = WithdrawalDetailState.error;
  }

  // fetchLetter(DocumentType documentType, String fileName) async {
  //   if (homeScreenLogic.isWithdrawInferencePolling) {
  //     homeScreenLogic.processingRequestToast();
  //   } else {
  //     await Get.toNamed(
  //       Routes.PDF_DOCUMENT_SCREEN,
  //       arguments: {
  //         'documentType': documentType,
  //         'fileName': fileName,
  //       },
  //     );
  //   }
  // }

  ///Fetch the first loan id details
  String _computeLoanId() {
    if (customerLoansModel.activeLoans.isNotEmpty) {
      return customerLoansModel.activeLoans.last.loanId;
    } else if (customerLoansModel.closedLoans.isNotEmpty) {
      return customerLoansModel.closedLoans.last.loanId;
    }
    return '';
  }

  onOverDuePayClicked() async {
    LPCService.instance.activeCard = lpcCard;
    if (customerLoansModel.overdueLoans.length == 1) {
      ///Redirect to repayment page if single loan
      logOverduePayNowCTAClickedEvent(
        loanAmount: overDueLoanDetailsModel.loanAmount,
        loanId: overDueLoanDetailsModel.loanId,
        noOfLoans: customerLoansModel.overdueLoans.length.toString(),
      );
      await Get.toNamed(
        Routes.RE_PAYMENT_TYPE_SELECTOR,
        arguments: {
          'paymentType': RePaymentType.fullPayment,
          'loanDetails': overDueLoanDetailsModel,
        },
      );
    } else {
      ///Redirect to details page if more than one loan
      logOverduePayNowCTAClickedEvent(
        loanAmount: "",
        loanId: "",
        noOfLoans: customerLoansModel.overdueLoans.length.toString(),
      );
      await Get.toNamed(
        Routes.PAYMENT_LOAN_LIST,
        arguments: {
          'type': PaymentLoanListType.overdue,
          'loans_list': customerLoansModel.overdueLoans,
        },
      );
    }
    homeScreenInterface.fetchHomePageV2();
    onAfterFirstLayout(withdrawalDetailsHomeScreenType, lpcCard);
  }

  computeAdvanceLoanInfoText() {
    return "Loan ID: #${customerLoansModel.advanceEMILoans.first.loanId}${customerLoansModel.advanceEMILoans.length > 1 ? "\n+${customerLoansModel.advanceEMILoans.length - 1} more" : ""}";
  }

  computeOverdueInfoText() {
    if(customerLoansModel.overdueLoans.length == 1 && loanDetailsModel.isPendingPayment) {
      return "Clear your pending charges from the previous payment";
    } else{
      return "Pay your EMI now to avoid late fee & charges";
    }
  }

  computeOverdueNudgeText() {
    if(loanDetailsModel.isPendingPayment) return "Pending amount";
    return "Overdue alert";
  }

// void onAllWithdrawalCardTapped() async {
//   AppAnalytics.trackWebEngageEventWithAttribute(
//     eventName: "All_Withdrawals_Clicked",
//   );

//   if (homeScreenLogic.isWithdrawInferencePolling) {
//     homeScreenLogic.processingRequestToast();
//   } else if (shouldOpenAllWithdrawals) {
//     AppAnalytics.trackWebEngageEventWithAttribute(
//       eventName: "Entered servicing screen",
//     );
//     await Get.toNamed(
//       Routes.SERVICING_SCREEN,
//       arguments: {'loans_model': customerLoansModel},
//     );
//     onAfterFirstLayout(withdrawalDetailsHomeScreenType);
//   }
// }
}
