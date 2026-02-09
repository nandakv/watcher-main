import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/utils/app_functions.dart';

abstract class WithdrawalHelper {

  String aprInfoText =
      "Effective annualised rate charged to the borrower of a digital loan based on an all-inclusive cost and margin including the cost of funds.";

  String netAmountInfoText =
      "This is the actual amount disbursed to the borrower’s account after the deduction of applicable charges and fees.";

  String bpiInfoText =
      "Amount collected as an interest from the borrower if the time between the actual date of disbursal and the 1st instalment is more than 30 days.";


  parsePaymentBreakDownData(
      { WithdrawalCalculationModel? calculationModel});

  convertToFixedString(double? value) {
    if (value != null) {
      return "₹${AppFunctions().parseIntoCommaFormat(value.toStringAsFixed(2).toString())}";
    }
  }

  bool isDiscountedProcessingFee(double? discountedProcessingFee) {
    return discountedProcessingFee != null ? true : false;
  }

  bool isDiscountValid(
      double? discountedProcessingFee, double? processingFee) {
    return processingFee != discountedProcessingFee ? true : false;
  }
}
