import 'package:privo/app/models/withdrawal_calculation_model.dart';
import 'package:privo/app/modules/withdrawal_screen/helpers/withdrawal_helper.dart';
import 'package:privo/app/modules/withdrawal_screen/widgets/withdrawal/withdrawal_logic.dart';
import 'package:privo/app/utils/app_functions.dart';

class FlexiOdWithdrawalHelper extends WithdrawalHelper{
  @override
  parsePaymentBreakDownData({WithdrawalCalculationModel? calculationModel, }) {
    return [
      WithdrawalBreakDownData(
        title: "Withdrawal Amount",
        value: calculationModel == null ? null : convertToFixedString(calculationModel.loanAmount),
        isHighlighted: true,
      ),
      WithdrawalBreakDownData(
        title: "Rate of Interest",
        value: calculationModel == null ? null :  "${calculationModel.interestRate?.toStringAsFixed(2)}%",
      ),
      WithdrawalBreakDownData(
        title: "Annual Percentage Rate (APR)",
        value: calculationModel == null ? null :  "${calculationModel.apr?.toStringAsFixed(2)}%",
        infoText: aprInfoText,
      ),
      WithdrawalBreakDownData(
        title: "Net Disbursal Amount",
        value: calculationModel == null ? null :  convertToFixedString(calculationModel.disbursedAmount),
        isHighlighted: true,
        showDivider: true
      ),
    ];
  }

}