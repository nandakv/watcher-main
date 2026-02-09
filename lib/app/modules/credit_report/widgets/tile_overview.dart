import 'package:flutter/material.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';

class TileOverview extends StatelessWidget {
  TileOverview(
      {super.key, required this.creditAccount, this.showStatus = true});

  CreditAccount creditAccount;
  bool showStatus;

  @override
  Widget build(BuildContext context) {
    return _loanOverView(creditAccount);
  }

  Column _loanOverView(CreditAccount creditAccount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          creditAccount.sanctionAmountText,
          style: const TextStyle(
              color: navyBlueColor, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const VerticalSpacer(10),
        showStatus
            ? _subTitle(creditAccount.isLoanClosed ? "Closed" : "Active",
                creditAccount.isLoanClosed ? secondaryDarkColor : greenColor)
            : const SizedBox()
      ],
    );
  }

  Text _subTitle(String subTitle, Color color) {
    return Text(
      subTitle,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        height: 0.14,
      ),
    );
  }
}
