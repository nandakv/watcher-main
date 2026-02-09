import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/transaction_history/transaction_history_logic.dart';
import 'package:privo/app/modules/transaction_history/widgets/filter_by_option.dart';
import 'package:privo/app/modules/transaction_history/widgets/sort_by_option.dart';
import 'package:privo/app/theme/app_colors.dart';

class TransactionHistoryBottomBar extends StatelessWidget {
  const TransactionHistoryBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryLogic>(builder: (logic) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: _filterAndSortBoxDecoration(),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 52),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SortByOption(),
                    const VerticalDivider(
                      thickness: 1,
                      color: lightGrayColor,
                    ),
                    FilterByOption()
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  BoxDecoration _filterAndSortBoxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      border: Border(
        left: BorderSide(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0xFFE2E2E2),
        ),
        top: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0xFFE2E2E2),
        ),
        right: BorderSide(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0xFFE2E2E2),
        ),
        bottom: BorderSide(
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0xFFE2E2E2),
        ),
      ),
    );
  }
}
