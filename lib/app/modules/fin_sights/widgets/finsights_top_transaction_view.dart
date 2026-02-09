import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_empty_widget.dart';
import 'package:privo/app/utils/app_text_styles.dart';
import 'package:privo/app/utils/text_styles.dart';
import '../../../../res.dart';
import '../../../common_widgets/gradient_button.dart';
import '../../../common_widgets/spacer_widgets.dart';
import '../../../components/pill_button.dart';
import '../../../theme/app_colors.dart';
import '../../../utils/app_functions.dart';
import '../fin_sights_logic.dart';
import '../finsights_transaction_error.dart';
import 'mask_data_widget.dart';

class FinsightsTopTransactionView extends StatelessWidget {
  FinsightsTopTransactionView({super.key});

  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: GetBuilder<FinSightsLogic>(
            id: logic.TRANSACTION_LIST_KEY,
            builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Top Transactions")
                          .headingSMedium(color: appBarTitleColor),
                      if (logic.finSightsViewModel.topFundsTransferred
                              .isNotEmpty ||
                          logic.finSightsViewModel.topFundsReceived.isNotEmpty)
                        _monthWidget(),
                    ],
                  ),
                  const VerticalSpacer(22),
                  _sentReceiveSelectionWidget(),
                  const VerticalSpacer(16),
                  _showTransactionData(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _showTransactionData() {
    switch (logic.transactionState) {
      case TransactionState.success:
        return _transactionWidget();
      case TransactionState.badRequest:
        return FinsightsTransactionError();
    }
  }

  _transactionWidget() {
    return logic.filteredList.isEmpty
        ? const FinsightsEmptyWidget()
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: logic.filteredList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF8FD1EC),
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _showIcon(index),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    logic.filteredList[index].category!,
                                    maxLines: 1,
                                    style:AppTextStyles.bodyMMedium(color: secondaryDarkColor),
                                  ),
                                  VerticalSpacer(5.h),
                                  Text(logic.transactionListMonthYear(
                                   logic.selectedMonth,
                                  )).bodyXSRegular(color: secondaryDarkColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0.w),
                              child: MaskDataWidget(
                                text:
                                    '₹${AppFunctions().formatNumberWithCommas(logic.filteredList[index].amount)}',
                                styleBuilder: (text) =>
                                    Text(text).bodyMMedium(
                                      color: navyBlueColor,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const VerticalSpacer(10)
                ],
              );
            });
  }

  Container _showIcon(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: preRegistrationEnabledGradientColor2.withOpacity(0.10),
        border: Border.all(color: const Color(0xFF229ACE), width: 1.w),
        borderRadius: BorderRadius.circular(28),
      ),
      child: SvgPicture.asset(
        width: 15.w,
        height: 15.h,
        logic
            .getCategorySvgPath(logic.filteredList[index].category ?? "Others"),
      ),
    );
  }

  _monthWidget() {
    return GetBuilder<FinSightsLogic>(
      id: logic.MONTH_ID,
      builder: (logic) {
        return InkWell(
          onTap: () {
            logic.radioWidget();
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: darkBlueColor,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 7,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(logic.dropDowndateText())
                      .bodyXSMedium(color: darkBlueColor),
                  const SizedBox(
                    width: 4,
                  ),
                  SvgPicture.asset(
                    Res.dropDownTFSvg,
                    height: 3.5,
                    width: 6.5,
                    color: darkBlueColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container sentReceivedWidget(String title, bool isButtonSelected) {
    return Container(
      decoration: _buttonDecoration(isButtonSelected),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Text(
          title,
        ).bodyXSMedium(color: isButtonSelected ? Colors.white : darkBlueColor),
      ),
    );
  }

  BoxDecoration _buttonDecoration(bool isButtonSelected) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isButtonSelected ? darkBlueColor : Colors.white,
      border: Border.all(
        color: darkBlueColor.withOpacity(1),
        width: 1,
      ),
    );
  }

  Widget _sentReceiveSelectionWidget() {
    return GetBuilder<FinSightsLogic>(
      builder: (logic) {
        return Row(
          children: TopTranscationType.values
              .map((topTranscationType) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: PillButton(
                      text: topTranscationType.title,
                      onTap: () {
                        logic.sendReceiveOnTap(topTranscationType);
                      },
                      isSelected:
                          logic.currentTopTransactionPillType == topTranscationType,
                    ),
                  ))
              .toList(),
        );
      }
    );
  }

  Padding transacationErrorWidget() {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 90.w, vertical: 60.h),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_outlined,
            color: grey400,
          ),
           VerticalSpacer(4.h),
          const Text(
            "An error occurred! Please click refresh to reload the graph",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 10,
              color: secondaryDarkColor,
            ),
          ),
            VerticalSpacer(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: GradientButton(
              onPressed: () {
             logic.getFinSightsOverview();
              },
              title: "Refresh",
            ),
          )
        ],
      ),
    );
  }
}
