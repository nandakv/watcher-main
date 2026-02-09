import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/payment_history_model.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_functions.dart';
import 'package:privo/app/utils/app_text_styles.dart';

class TransactionCard extends StatelessWidget {
  final PaymentTransactions transaction;
  TransactionCard({Key? key, required this.transaction}) : super(key: key);

  final logic = Get.find<TransactionHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        logic.onTransactionCardTapped(transaction);
      },
      child: Container(
        width: double.infinity,
        decoration: _transactionContainerDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppFunctions().parseNumberToCommaFormatWithRupeeSymbol(
                        num.parse(transaction.amount)),
                    style: AppTextStyles.bodyLMedium(color: navyBlueColor),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    transaction.createdDate,
                    style:
                        AppTextStyles.bodyXSMedium(color: secondaryDarkColor),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 4, bottom: 4),
                decoration: BoxDecoration(
                    color: green100, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  'Success',
                  style: AppTextStyles.bodyXSMedium(color: greenColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ShapeDecoration _transactionContainerDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
