import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/emi_repository.dart';
import 'package:privo/app/mixin/advance_emi_payment_mixin.dart';
import 'package:privo/app/models/advance_emi_payment_info_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/loans_model.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_analytics.dart';
import 'package:privo/app/modules/payment_loans_list/payment_loans_list_view.dart';
import 'package:privo/app/modules/re_payment_type_selector/re_payment_type_selector_logic.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/utils/error_logger_mixin.dart';

class PaymentLoansListLogic extends GetxController
    with
        ApiErrorMixin,
        ErrorLoggerMixin,
        AdvanceEMIPaymentMixin,
        PaymentLoansListAnalytics {
  late List<Loans> loanList;

  late PaymentLoanListType paymentLoanListType;

  ///every item on overdue loan list we have to make api call for current list
  List<LoanDetailsModel> loanDetailsList = [];
  List<AdvanceEMIPaymentInfoModel> advanceEMIList = [];

  var arguments = Get.arguments;

  bool _isLoanListLoading = false;

  bool get isLoanListLoading => _isLoanListLoading;

  set isLoanListLoading(bool value) {
    _isLoanListLoading = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    _getArguments();
  }

  _getArguments() {
    paymentLoanListType = arguments['type'];
    loanList = arguments['loans_list'];
    _logEventsOnScreenLoaded();
  }

  _logEventsOnScreenLoaded() {
    switch (paymentLoanListType) {
      case PaymentLoanListType.overdue:
        logLoanListScreenLoaded(noOfLoans: loanList.length.toString());
        break;
      case PaymentLoanListType.advanceEMI:
        logListOfEmisLoaded(loanList.length.toString());
        break;
    }
  }

  void onAfterLayout() {
    _getArguments();
    _getLoans();
  }

  String computeDPD(String days) {
    if (num.parse(days) > 90) {
      return "90+";
    }
    return days;
  }

  Future<void> _getLoans() async {
    isLoanListLoading = true;
    loanDetailsList.clear();
    for (var loan in loanList) {
      await getLoanDetail(loan);
    }
    Get.log("loan list length - ${loanList.length}");
    isLoanListLoading = false;
  }

  Future getLoanDetail(Loans loan) async {
    LoanDetailsModel loanDetails =
        await EmiRepository().getLoanDetails(loanId: loan.loanId);
    switch (loanDetails.apiResponse.state) {
      case ResponseState.success:
        if (loanDetails.advanceEMIPaymentTypeDetails.type == PaymentTypeStatus.eligible) {
          await _getAdvanceEMIPaymentInfo(loanDetails);
        } else {
          loanDetails.dpd = loan.dpd;
          loanDetailsList.add(loanDetails);
        }
        break;
      default:
        _onApiError(loanDetails.apiResponse);
    }
  }

  Future _getAdvanceEMIPaymentInfo(LoanDetailsModel loanDetails) async {
    if (loanDetails.advanceEMIPaymentTypeDetails.type == PaymentTypeStatus.eligible) {
      await getAdvanceEMIPaymentInfoFromAPI(
        loanId: loanDetails.loanId,
        loanStartDate: loanDetails.loanStartDate,
        nextDueDate: loanDetails.nextDueDate,
        onSuccess: (AdvanceEMIPaymentInfoModel advanceEMIPaymentInfoModel) {
          loanDetailsList.add(loanDetails);
          advanceEMIList.add(advanceEMIPaymentInfoModel);
        },
        onFailure: (ApiResponse apiResponse) {
          _onApiError(apiResponse);
        },
      );
    }
  }

  void _onApiError(ApiResponse apiResponse) {
    logError(
      statusCode: apiResponse.statusCode.toString(),
      responseBody: apiResponse.apiResponse,
      requestBody: apiResponse.requestBody,
      exception: apiResponse.exception,
      url: apiResponse.url,
    );
  }

  onPayNowClicked(LoanDetailsModel loanDetailsModel, int index) async {
    if (paymentLoanListType == PaymentLoanListType.advanceEMI) {
      AdvanceEMIPaymentInfoModel model = advanceEMIList[index];
      logCTAPayClicked("homescreen_list");
      await PaymentNavigationService().navigate(
        routeArguments: getAdvanceEMIPaymentArgument(
            advanceEMIPaymentInfoModel: model,
            loanDetailModel: loanDetailsModel),
      );
    } else {
      logOverduePayClickedEvent(
        loanId: loanDetailsModel.loanId,
        amount: loanDetailsModel.totalPendingAmount,
        dpd: loanDetailsModel.dpd,
      );
      await Get.toNamed(Routes.RE_PAYMENT_TYPE_SELECTOR, arguments: {
        'loanDetails': loanDetailsModel,
        'paymentType': RePaymentType.fullPayment
      });
    }
    await _getLoans();
  }

  @override
  void onClose() {
    super.onClose();
    _logEventsOnScreenClosed();
  }

  void _logEventsOnScreenClosed() {
    switch (paymentLoanListType) {
      case PaymentLoanListType.overdue:
        logLoanListScreenClosed(noOfLoans: loanList.length.toString());
        break;
      case PaymentLoanListType.advanceEMI:
        break;
    }
  }

  void logOnOverdueKnowMoreClicked(LoanDetailsModel loanDetailsModel) {
    logKnowMoreClicked(
      overDueAmount: loanDetailsModel.totalPendingAmount,
      loanId: loanDetailsModel.loanId,
      noOfLoans: loanList.length.toString(),
    );
  }

  computeDueDate(String nextDueDate) {
    DateTime parsedDate = DateTime.parse(nextDueDate);
    String formattedDate = DateFormat("d MMM ''yy").format(parsedDate);
    return formattedDate;
  }

  computeBadgeTitle(LoanDetailsModel model) {
    return "Due date: ${computeDueDate(model.nextDueDate)}";
  }

  computeOverDueBadgeTitle(LoanDetailsModel loanDetailsModel) {
    if (loanDetailsModel.isPendingPayment) return "Pending amount";
    return "${computeDPD(loanDetailsModel.dpd)} Days Overdue";
  }
}
