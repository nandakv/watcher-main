import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/back_arrow_app_bar.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/credit_report/credit_report_logic.dart';
import 'package:privo/app/modules/credit_report/model/credit_report_model.dart';
import 'package:privo/app/modules/credit_report/widgets/credit_report_tile.dart';
import 'package:privo/app/modules/credit_report/widgets/powered_by_experian.dart';
import 'package:privo/app/modules/credit_report/widgets/tile_overview.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/components/selection_chip_widget/selection_chip_model.dart';
import 'package:privo/components/selection_chip_widget/selection_chip_widget.dart';

import '../credit_report_helper_mixin.dart';

class AllCreditLoans extends StatelessWidget {
  AllCreditLoans({super.key});

  final logic = Get.find<CreditReportLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreditReportLogic>(
      id: logic.ALL_CREDIT_LOANS,
      builder: (logic) {
        return Column(
          children: [
            BackArrowAppBar(
              title: 'Credit Overview',
              onBackPress: logic.onBackClicked,
            ),
            _body(),
            const VerticalSpacer(20),
            const PoweredByExperian(),
            const VerticalSpacer(40),
          ],
        );
      },
    );
  }

  Expanded _body() {
    return Expanded(
      child: SingleChildScrollView(
        controller: logic.creditOverviewScrollController,
        key: logic.creditOverviewScrollKey,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SelectionChipWidget(
                  selectionChips: selectionChips(),
                  scrollAxis: Axis.horizontal,
                  selectedIndex: logic.creditOverviewAccountType.indexVal),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: _loans(title: "Active", accounts: logic.fetchAccounts()),
            ),
            _loans(
                title: "Closed",
                accounts: logic.fetchAccounts(fetchClosedLoans: true))
          ],
        ),
      ),
    );
  }

  Widget _loans(
      {required String title, required List<CreditAccount> accounts}) {
    return Column(
      children: [
        _loanTitleBar(title: title, length: accounts.length.toString()),
        const VerticalSpacer(16),
        ...List.generate(
          accounts.length,
          (index) => CreditReportTile(
            title: accounts[index].accountName,
            subTitle: accounts[index].lenderName,
            subTitleColor: secondaryDarkColor,
            rightInfoWidget: TileOverview(
              creditAccount: accounts[index],
              showStatus: false,
            ),
            iconPath: logic.getExperianBankLogo(
                experianBankName: accounts[index].lenderName),
            onTap: () => logic.onCreditOverviewTapped(accounts[index]),
          ),
        )
      ],
    );
  }

  Row _loanTitleBar({required String title, required String length}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: darkBlueColor),
        ),
        const SizedBox(
          width: 4,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: _activeLoansDecoration(),
          child: Text(
            length,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        )
      ],
    );
  }

  BoxDecoration _activeLoansDecoration() =>
      const BoxDecoration(shape: BoxShape.circle, color: darkBlueColor);

  List<SelectionChipModel> selectionChips() {
    return CreditAccountType.values
        .map((creditOverviewAccountType) => SelectionChipModel(
            title: "${creditOverviewAccountType.title}s",
            index: creditOverviewAccountType.indexVal,
            onTap: () =>
                logic.onCreditAccountChipTapped(creditOverviewAccountType)))
        .toList();
  }
}
