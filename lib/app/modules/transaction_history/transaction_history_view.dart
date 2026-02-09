import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/components/top_navigation_bar.dart';
import 'package:privo/app/models/payment_history_model.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/modules/transaction_history/widgets/no_transactions.dart';
import 'package:privo/app/modules/transaction_history/widgets/transaction_card.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/app_text_styles.dart';

import 'transaction_history_logic.dart';
import 'widgets/filter_by_option.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with AfterLayoutMixin {
  final logic = Get.find<TransactionHistoryLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionHistoryLogic>(builder: (logic) {
      return Scaffold(
        backgroundColor: whiteTextColor,
        floatingActionButton: FilterByOption(),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const TopNavigationBar(
                title: "Transactions",
                enableShadow: true,
              ),
              if (logic.paymentHistoryLength != 0)
                logic.isPageLoading
                    ? const SizedBox()
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              logic.dateRangeValue,
                              style: AppTextStyles.headingSMedium(
                                  color: navyBlueColor),
                            ),
                            verticalSpacer(5),
                            _excessPaymentsDisclaimer(),
                          ],
                        ),
                      ),
              _paymentHistory(),
              if (logic.paymentHistoryLength != 0) verticalSpacer(40.h)
            ],
          ),
        ),
      );
    });
  }

  Widget _excessPaymentsDisclaimer() {
    return RichText(
      text: TextSpan(
        text: '* ',
        style: AppTextStyles.bodyXSRegular(color: red),
        children: <TextSpan>[
          TextSpan(
            text:
                '''Payments shown don't include excess or "Pay in Advance" amounts. Excess payments will show after EMI adjustment. Find all excess payment records in your SOA.''',
            style: AppTextStyles.bodyXSRegular(color: primaryDarkColor),
          ),
        ],
      ),
    );
  }

  Widget _paymentHistory() {
    return logic.isPageLoading ? _onPageLoading() : _onPaymentHistoryLoaded();
  }

  Widget _onPaymentHistoryLoaded() {
    return logic.paymentHistoryLength == 0
        ? const NoTransactions()
        : Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: NotificationListener<ScrollEndNotification>(
                onNotification: logic.onScrollEndReached,
                child: ListView.builder(
                    itemCount: logic.paymentHistoryLength,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: _transactionDetailsContainer(index),
                          ),
                          _paginationLoadingWidget(index),
                        ],
                      );
                    }),
              ),
            ),
          );
  }

  Widget _paginationLoadingWidget(int index) {
    return GetBuilder<TransactionHistoryLogic>(
        id: logic.PAGINATION_LODING_ID,
        builder: (logic) {
          return _showLoadingForNextPage(index)
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: RotationTransitionWidget(
                    loadingState: LoadingState.bottomLoader,
                    buttonTheme: AppButtonTheme.dark,
                  ),
                )
              : const SizedBox();
        });
  }

  bool _showLoadingForNextPage(int index) {
    //-1 is added to determine and show loading indicator only after the last element card
    return logic.loadingState == PaginationLoadingState.loading &&
        index == (logic.paymentHistoryLength - 1);
  }

  Padding _onPageLoading() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: RotationTransitionWidget(
        loadingState: LoadingState.bottomLoader,
        buttonTheme: AppButtonTheme.dark,
      ),
    );
  }

  Widget _transactionDetailsContainer(int index) {
    PaymentTransactions transaction = logic.fetchPaymentTransactions()[index];
    return TransactionCard(transaction: transaction);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
