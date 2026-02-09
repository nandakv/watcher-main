import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/utils/app_functions.dart';

import 'withdrawal_helper.dart';

class ClpWithdrawalHelper extends WithdrawalHelper {
  @override
  List<WithdrawalBreakDownData> parsePaymentBreakDownData(
      {WithdrawalCalculationModel? calculationModel,
      bool insuranceOpted = false}) {
    return [
      WithdrawalBreakDownData(
        title: "EMI Amount",
        value: calculationModel == null
            ? null
            : convertToFixedString(calculationModel.emiAmount),
        isHighlighted: true,
      ),
      WithdrawalBreakDownData(
        title: "Rate of Interest",
        value: calculationModel == null
            ? null
            : "${_fetchInterestRate(calculationModel)}%",
      ),
      WithdrawalBreakDownData(
        title: "Total Loan Amount",
        value: calculationModel == null
            ? null
            : convertToFixedString(calculationModel.loanAmount),
      ),
      WithdrawalBreakDownData(
        title: "Processing Fee",
        value: calculationModel == null
            ? null
            : convertToFixedString(calculationModel.processingFee?.toDouble()),
        isDiscountedProcessingFee: isDiscountedProcessingFee(
                calculationModel?.discountedProcessingFee) &&
            isDiscountValid(calculationModel?.discountedProcessingFee,
                calculationModel?.processingFee?.toDouble()),
      ),
      WithdrawalBreakDownData(
        title: "Broken Period Interest (BPI)",
        value: calculationModel == null
            ? null
            : convertToFixedString(calculationModel.bpi),
        infoText: bpiInfoText,
      ),
      WithdrawalBreakDownData(
        title: "Annual Percentage Rate (APR)",
        value: calculationModel == null
            ? null
            : "${calculationModel.apr?.toStringAsFixed(2)}%",
        infoText: aprInfoText,
      ),
      if (calculationModel?.insuranceWrapperResponse != null && insuranceOpted)
        WithdrawalBreakDownData(
          title: "Insurance",
          value: calculationModel == null
              ? null
              : "-${convertToFixedString(calculationModel.insuranceWrapperResponse!.first.totalPremium)}",
          infoText: aprInfoText,
        ),
      WithdrawalBreakDownData(
        title: "Net Disbursal Amount",
        value: calculationModel == null
            ? null
            : convertToFixedString(calculationModel.disbursedAmount),
        infoText: netAmountInfoText,
        isHighlighted: true,
        showDivider: true,
      ),
    ];

    // additionalData.forEach((key, value) {
    //   breakdownData.add(
    //     WithdrawalBreakDownData(
    //       title: key,
    //       value: convertToFixedString(value),
    //       // You can add other properties as needed
    //     ),
    //   );
    // });
  }

  _fetchInterestRate(WithdrawalCalculationModel calculationModel) {
    if (calculationModel.interestRate != null) {
      return calculationModel.interestRate!.toStringAsFixed(2).toString();
    }
  }
}
