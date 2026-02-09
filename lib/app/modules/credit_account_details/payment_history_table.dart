import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';

import '../../../res.dart';
import '../../theme/app_colors.dart';
import '../credit_report/model/credit_report_model.dart';

class PaymentHistoryTable extends StatelessWidget {
  PaymentHistoryTable({Key? key}) : super(key: key);

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryLightColor,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(8),
          child: GetBuilder<CreditReportLogic>(
              id: logic.PAYMENT_HISTORY_TABLE,
              builder: (logic) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _yearWidget(),
                    verticalSpacer(22),
                    _paymentTable(),
                  ],
                );
              }),
        ),
        verticalSpacer(12),
        _tableLegendWidget(),
      ],
    );
  }

  Widget _paymentTable() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return _paymentMonthTile(index);
      },
    );
  }

  Widget _paymentMonthTile(int index) {
    return Center(
      child: Column(
        children: [
          Text(
            logic.month[index],
            style: const TextStyle(
              fontSize: 12,
              color: primaryDarkColor,
              height: 16 / 12,
            ),
          ),
          verticalSpacer(3),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: _computePaymentHistoryIcon(index),
          ),
        ],
      ),
    );
  }

  _computePaymentHistoryIcon(int index) {
    switch (logic.getTransactionHistoryType(index)) {
      case TransactionHistoryDataType.notAvailable:
        return _notAvailableIcon();
      case TransactionHistoryDataType.paid:
        return _amountPaidIcon();
      case TransactionHistoryDataType.unpaid:
        return _amountNotPaidIcon();
      case TransactionHistoryDataType.none:
        return const SizedBox();
    }
  }

  Widget _tableLegendWidget() {
    return Row(
      children: [
        _legendTile(icon: _amountPaidIcon(), legend: "Paid"),
        _legendTile(icon: _amountNotPaidIcon(), legend: "Unpaid"),
        _legendTile(icon: _notAvailableIcon(), legend: "Not Available"),
      ],
    );
  }

  Widget _legendTile({required Widget icon, required String legend}) {
    return Row(
      children: [
        icon,
        horizontalSpacer(6),
        Text(legend, style: _legendTextStyle),
        horizontalSpacer(22),
      ],
    );
  }

  TextStyle get _legendTextStyle {
    return const TextStyle(
      fontSize: 10,
      color: primaryDarkColor,
      fontWeight: FontWeight.w500,
      height: 14 / 10,
    );
  }

  Widget _amountPaidIcon() {
    return SvgPicture.asset(
      Res.right_tick,
      colorFilter: const ColorFilter.mode(greenColor, BlendMode.srcIn),
    );
  }

  Widget _amountNotPaidIcon() {
    return SvgPicture.asset(
      Res.right_tick,
      colorFilter: const ColorFilter.mode(secondaryDarkColor, BlendMode.srcIn),
    );
  }

  Widget _notAvailableIcon() {
    return SvgPicture.asset(
      Res.creditTransactionNA,
    );
  }

  Widget _leftArrowWidget() {
    return logic.isPrevYearDisabled
        ? const SizedBox()
        : InkWell(
            onTap: logic.onPrevYear,
            child: const Icon(
              Icons.chevron_left_rounded,
              color: primaryDarkColor,
              size: 15,
            ),
          );
  }

  Widget _rightArrowWidget() {
    return SizedBox(
      width: 25,
      height: 25,
      child: logic.isNextYearDisabled
          ? const SizedBox()
          : InkWell(
              onTap: logic.onNextYear,
              child: const Icon(
                Icons.chevron_right_rounded,
                color: navyBlueColor,
                size: 15,
              ),
            ),
    );
  }

  Widget _yearWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _leftArrowWidget(),
        horizontalSpacer(4),
        Text(
          logic.currSelectedYear.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: primaryDarkColor,
            height: 16 / 12,
          ),
        ),
        horizontalSpacer(4),
        _rightArrowWidget(),
      ],
    );
  }
}
