import 'package:get/get.dart';
import 'package:privo/app/api/api_error_mixin.dart';
import 'package:privo/app/api/response_model.dart';
import 'package:privo/app/data/repository/emi_repository.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/home_screen_card_model.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/models/loan_details_model.dart';
import 'package:privo/app/models/loans_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/payment/payment_view.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/web_engage_constant.dart';

enum UPLLoanDetailsTopWidgetState { loading, success, error }

class DisbursalCompleteHomeScreenLogic extends GetxController
    with ApiErrorMixin {
  final String WIDGET_KEY = 'widget_key';

  UPLLoanDetailsTopWidgetState _uplLoanDetailsTopWidgetState =
      UPLLoanDetailsTopWidgetState.loading;

  UPLLoanDetailsTopWidgetState get uplLoanDetailsTopWidgetState =>
      _uplLoanDetailsTopWidgetState;

  set uplLoanDetailsTopWidgetState(UPLLoanDetailsTopWidgetState value) {
    _uplLoanDetailsTopWidgetState = value;
    update([WIDGET_KEY]);
  }

  late LoanDetailsModel loanDetailsModel;

  late LoansModel customerLoansModel;

  late LpcCard lpcCard;

  onAfterLayout(
    LpcCard lpcCard,
    UplDisbursalHomeScreenType uplDisbursalCompleteHomePageModel,
  ) async {
    this.lpcCard = lpcCard;
    getCustomerLoans(lpcCard, uplDisbursalCompleteHomePageModel);
  }

  getCustomerLoans(
    LpcCard lpcCard,
    UplDisbursalHomeScreenType uplDisbursalCompleteHomePageModel,
  ) async {
    uplLoanDetailsTopWidgetState = UPLLoanDetailsTopWidgetState.loading;
    LoansModel customerLoansModel = await EmiRepository().getLoans(
      customerId: uplDisbursalCompleteHomePageModel.cif,
    );
    switch (customerLoansModel.apiResponse.state) {
      case ResponseState.success:
        this.customerLoansModel = customerLoansModel;
        fetchLoanDetails(customerLoansModel);
        break;
      default:
        uplLoanDetailsTopWidgetState = UPLLoanDetailsTopWidgetState.error;
    }
  }

  String computeActiveLoanId(LoansModel customerLoansModel) {
    for (var element in customerLoansModel.activeLoans) {
      if (lpcCard.appFormId == element.appFormId) {
        return element.loanId;
      }
    }
    return customerLoansModel.activeLoans.first
        .loanId; // We have added this return statement so that if at all  appform id from lpc card matches with none of the appformid's in the customer loans model active losn, we will return the first loan id such that the old logic still stays.
  }

  fetchLoanDetails(LoansModel customerLoansModel) async {
    try {
      //We are accessing 0th element directly as we will have only one loan in UPL
      String loanId = customerLoansModel.activeLoans.isNotEmpty
          ? computeActiveLoanId(customerLoansModel)
          : customerLoansModel.closedLoans[0].loanId;

      LoanDetailsModel loanDetailsModel = await EmiRepository().getLoanDetails(
        loanId: loanId,
      );

      switch (loanDetailsModel.apiResponse.state) {
        case ResponseState.success:
          this.loanDetailsModel = loanDetailsModel;
          uplLoanDetailsTopWidgetState = UPLLoanDetailsTopWidgetState.success;
          break;
        default:
          onUplLoanDetailsFetchFailure();
      }
    } catch (e) {
      onUplLoanDetailsFetchFailure();
    }
  }

  onUplLoanDetailsFetchFailure() {
    uplLoanDetailsTopWidgetState = UPLLoanDetailsTopWidgetState.error;
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.homepageApiFailureCardLoaded,
    );
  }

  fetchLoanAmount() {
    return "₹ ${AppFunctions().parseIntoCommaFormat(loanDetailsModel.loanAmount)}";
  }

  fetchMonthlyEmi() {
    return num.tryParse(loanDetailsModel.emiAmount) != 0
        ? "₹ ${AppFunctions().parseIntoCommaFormat(loanDetailsModel.emiAmount)}"
        : "-";
  }

  fetchCardBadgeType() {
    if (loanDetailsModel.overduePaymentTypeDetails.type == PaymentTypeStatus.eligible) {
      return CardBadgeType.overdue;
    }
    switch (loanDetailsModel.loanStatus) {
      case LoanStatus.active:
        return CardBadgeType.active;
      case LoanStatus.closed:
        return CardBadgeType.closed;
      default:
        return CardBadgeType.none;
    }
  }

  computeEmiPaidPercent() {
    try {
      if (loanDetailsModel != null) {
        int paidEmi = loanDetailsModel.emiPaid;
        int totalEmi = loanDetailsModel.emiTotal;
        Get.log("${(paidEmi / totalEmi).toPrecision(2)}");
        return (paidEmi / totalEmi).toPrecision(2);
      }
    } catch (e) {
      Get.log(e.toString());
    }
  }
}
