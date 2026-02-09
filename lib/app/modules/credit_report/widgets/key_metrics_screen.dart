import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/back_arrow_app_bar.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/model/key_metric.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_account_base_container.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_info_widget.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/theme/app_colors.dart';

class KeyMetricsScreen extends StatelessWidget {
  KeyMetricsScreen({super.key});

  final logic = Get.find<CreditReportLogic>();

  Widget _appbar() {
    return BackArrowAppBar(
        title: 'Credit Builder', onBackPress: logic.onBackClicked);
  }

  Widget _creditAccountTypeTile() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: CreditInfoWidget(
        type: logic.selectedCreditInfoType,
        decoration: const BoxDecoration(),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _divider() {
    return Divider(
      thickness: 0.5,
      color: darkBlueColor.withOpacity(.1),
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      controller: logic.keyMetricScrollController,
      key: logic.keyMetricScrollKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VerticalSpacer(32),
            _creditAccountTypeTile(),
            const VerticalSpacer(12),
            _divider(),
            const VerticalSpacer(24),
            keyMetrics(),
            _noteTextWidget(),
            _creditAccounts(),
            _infoWidget(),
          ],
        ),
      ),
    );
  }

  Widget keyMetrics() {
    List<KeyMetric> keyMetrics = logic.getKeyMetricsForSelectedCreditInfoType();
    if (keyMetrics.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: logic
            .getKeyMetricsForSelectedCreditInfoType()
            .map((e) => _keyMetricTile(e))
            .toList(),
      ),
    );
  }

  Widget _keyMetricTile(KeyMetric keyMetric) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          keyMetric.name,
          style: const TextStyle(
            color: secondaryDarkColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 16 / 12,
          ),
        ),
        const VerticalSpacer(4),
        Text(
          keyMetric.value,
          style: const TextStyle(
            color: navyBlueColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }

  Widget _noteTextWidget() {
    if (logic.selectedCreditInfoType.infoText.isEmpty) {
      return const SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          logic.selectedCreditInfoType.infoText,
          style: const TextStyle(
            color: secondaryDarkColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      );
    }
  }

  Widget _creditAccounts() {
    List<KeyMetricCreditAccountDetails> creditAccounts =
        logic.getKeyMetricsAccountDetails();

    return creditAccounts.isEmpty
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.only(bottom: 34.0),
            child: Column(
              children: creditAccounts
                  .map((creditAccount) => _creditAccountTile(
                        creditAccount: creditAccount,
                      ))
                  .toList(),
            ),
          );
  }

  Widget _creditAccountTile({
    required KeyMetricCreditAccountDetails creditAccount,
  }) {
    return InkWell(
      onTap: () =>
          logic.onCreditAccountTapped(creditAccount.accountSerialNumber),
      child: CreditAccountBaseContainer(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creditAccount.accountType,
                    maxLines: 2,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 20 / 14,
                        color: darkBlueColor),
                  ),
                  const VerticalSpacer(2),
                  Text(
                    creditAccount.lenderName,
                    style: const TextStyle(
                        fontSize: 10,
                        height: 14 / 10,
                        color: secondaryDarkColor),
                  ),
                ],
              ),
            ),
            const HorizontalSpacer(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  creditAccount.firstDataPoint,
                  style: const TextStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: primaryDarkColor),
                ),
                const VerticalSpacer(2),
                Text(
                  creditAccount.secondDataPoint,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 16 / 12,
                    color: secondaryDarkColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _infoTitleWidget() {
    return Text(
      "What is ${logic.selectedCreditInfoType.title}?",
      style: const TextStyle(
        color: primaryDarkColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 20 / 14,
      ),
    );
  }

  Widget _infoDescriptionWidget() {
    return Text(
      logic.selectedCreditInfoType.description,
      style: const TextStyle(
        color: secondaryDarkColor,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 17 / 12,
      ),
    );
  }

  Widget _infoWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoTitleWidget(),
        const VerticalSpacer(8),
        _infoDescriptionWidget(),
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
                const VerticalSpacer(12),
                const PoweredByExperian(),
                const VerticalSpacer(40),
              ],
            );
          }),
        ),
      ),
    );
  }
}
