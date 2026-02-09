import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:privo/app/common_widgets/back_arrow_app_bar.dart';
import 'package:privo/app/common_widgets/rich_text_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/common_widgets/vertical_spacer.dart';
import 'package:privo/app/models/rich_text_model.dart';
import 'package:privo/app/modules/credit_account_details/payment_history_table.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_report_tile.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/modules/credit_report/widgets/tile_overview.dart';

import '../../theme/app_colors.dart';

class CreditAccountDetailsScreen extends StatefulWidget {
  const CreditAccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CreditAccountDetailsScreen> createState() =>
      _CreditAccountDetailsScreenState();
}

class _CreditAccountDetailsScreenState extends State<CreditAccountDetailsScreen>
    with AfterLayoutMixin {
  final logic = Get.find<CreditReportLogic>();

  double creditLimitUtilizationWidth = 0;

  final _containerKey = GlobalKey();

  Widget _appbar() {
    return BackArrowAppBar(
        title: 'Account Details', onBackPress: logic.onBackClicked);
  }

  Widget _creditAccountTypeTile() {
    return CreditReportTile(
      title: logic.creditAccount.accountName,
      subTitle: logic.creditAccount.lenderName,
      subTitleColor: secondaryDarkColor,
      rightInfoWidget: TileOverview(
        creditAccount: logic.creditAccount,
      ),
      decoration: const BoxDecoration(),
      padding: EdgeInsets.zero,
      iconPath: logic.getExperianBankLogo(
          experianBankName: logic.creditAccount.lenderName),
      onTap: () {},
    );
  }

  Widget _creditCardAccountDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _accountDetailsTile(
                "Total Limit", logic.creditAccount.sanctionAmountText),
            _accountDetailsTile("Issued On", logic.creditAccount.issuedOn),
          ],
        ),
        const VerticalSpacer(24),
        logic.creditAccount.isLoanClosed
            ? _accountDetailsTile(
                "Closed on", logic.creditAccount.dateClosedText)
            : _accountDetailsTile(
                "Balance", logic.creditAccount.amountToBePaidText),
        const VerticalSpacer(32),
        Text(
          "Utilisation: ${logic.creditAccount.creditCardUtilizationPercentText}",
          style: const TextStyle(
            color: secondaryDarkColor,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        _creditLimitWidget(),
      ],
    );
  }

  Widget _creditLimitWidget() {
    if (logic.creditAccount.isLimitDetailsAvailable) {
      return Column(
        children: [
          verticalSpacer(12),
          _creditLimitProgressBar(),
          verticalSpacer(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _amountWidget(logic.creditAccount.limitUtilizedText),
              _amountWidget(logic.creditAccount.sanctionAmountText),
            ],
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "NA",
        style: _titleTextStyle(),
      ),
    );
  }

  Widget _creditLimitProgressBar() {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        children: [
          _totalLimitBar(),
          Padding(
            padding: const EdgeInsets.all(0.5),
            child: _limitUtilizedBar(),
          ),
        ],
      ),
    );
  }

  Widget _totalLimitBar() {
    return Container(
      key: _containerKey,
      height: 15,
      decoration: _emiProgressDecoration(color: navyBlueColor),
    );
  }

  Widget _limitUtilizedBar() {
    if (logic.creditAccount.limitUtilizedPercent! < 0) {
      return const SizedBox();
    }
    return Container(
      height: 14,
      width: creditLimitUtilizationWidth *
          (logic.creditAccount.limitUtilizedPercent! / 100),
      decoration: _emiProgressDecoration(color: greenColor),
    );
  }

  BoxDecoration _emiProgressDecoration(
      {Color color = const Color(0xFF161742)}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
    );
  }

  Widget _amountWidget(String amount) {
    return Text(
      amount,
      style: const TextStyle(
        color: navyBlueColor,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  Widget _loanAccountDetails() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _accountDetailsTile(
                "Total Limit", logic.creditAccount.sanctionAmountText),
            _accountDetailsTile(
              "Issued On",
              logic.creditAccount.issuedOn,
            ),
          ],
        ),
        verticalSpacer(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _accountDetailsTile(
                "Amount To Be Paid", logic.creditAccount.amountToBePaidText),
            _accountDetailsTile(
              "Loan Tenure",
              logic.creditAccount.repaymentTenureText,
            ),
          ],
        ),
        verticalSpacer(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
                alignment: Alignment.topLeft,
                child:
                    _accountDetailsTile("EMI Amount", logic.creditAccount.emi)),
            if (logic.creditAccount.isLoanClosed)
              _accountDetailsTile(
                  "Closed on", logic.creditAccount.dateClosedText)
          ],
        ),
      ],
    );
  }

  Widget _accountDetails() {
    if (logic.creditAccount.isCreditCard) {
      return _creditCardAccountDetails();
    }
    return _loanAccountDetails();
  }

  Widget _accountDetailsTile(String title, String value,
      {CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: secondaryDarkColor,
          ),
        ),
        const VerticalSpacer(4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: navyBlueColor,
          ),
        ),
      ],
    );
  }

  Widget _updatedOnWidget() {
    return RichTextWidget(infoList: [
      RichTextModel(
        text: "Updated on ",
        textStyle: const TextStyle(
          fontSize: 10,
          color: secondaryDarkColor,
          height: 14 / 10,
        ),
      ),
      RichTextModel(
        text: logic.creditAccount.updatedOn,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: secondaryDarkColor,
          height: 14 / 10,
        ),
      ),
    ]);
  }

  Widget _divider() {
    return Divider(
      thickness: 0.5,
      color: darkBlueColor.withOpacity(.1),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _creditAccountTypeTile(),
            verticalSpacer(16),
            _divider(),
            verticalSpacer(20),
            _accountDetails(),
            verticalSpacer(32),
            _paymentHistoryWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: _missingDataInfoWidget(),
            ),
            _updatedOnWidget(),
          ],
        ),
      ),
    );
  }

  Widget _missingDataInfoWidget() {
    return const Text(
      "Some information may be missing on this page.\nThis could be because Experian is still waiting for updates from your bank or other lenders.",
      style: TextStyle(
        color: secondaryDarkColor,
        fontWeight: FontWeight.w500,
        fontSize: 10,
        height: 1.4,
      ),
    );
  }

  TextStyle _titleTextStyle() {
    return const TextStyle(
      color: navyBlueColor,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
    );
  }

  Widget _paymentHistoryWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment History",
          style: GoogleFonts.poppins(
            color: navyBlueColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        verticalSpacer(16),
        (logic.creditAccount.tableData.isEmpty)
            ? const Text("NA")
            : PaymentHistoryTable(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: GetBuilder<CreditReportLogic>(builder: (logic) {
            return Column(
              children: [
                _appbar(),
                Expanded(child: _bodyWidget()),
                verticalSpacer(12),
                const PoweredByExperian(),
                verticalSpacer(28),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    Get.log("width ${_containerKey.currentContext?.size!}");
    creditLimitUtilizationWidth =
        _containerKey.currentContext?.size?.width ?? 0;
    logic.update();
  }
}
