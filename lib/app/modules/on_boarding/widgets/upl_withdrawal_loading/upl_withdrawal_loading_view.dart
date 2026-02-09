import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/upl_withdrawal_loading/upl_withdraw_success_widget.dart';
import 'package:privo/app/modules/polling/disbursement_polling.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';

import '../../../../../res.dart';
import '../result_page_widget.dart';
import 'upl_withdrawal_loading_logic.dart';

class UPLWithdrawalPollingView extends StatefulWidget {
  UPLWithdrawalPollingView({Key? key}) : super(key: key);

  @override
  State<UPLWithdrawalPollingView> createState() =>
      _UPLWithdrawalPollingViewState();
}

class _UPLWithdrawalPollingViewState extends State<UPLWithdrawalPollingView>
    with AfterLayoutMixin {
  final logic = Get.find<UPLWithdrawalLoadingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UPLWithdrawalLoadingLogic>(
      builder: (logic) {
        return logic.isWithdrawalSuccess
            ? UPLWithdrawSuccess()
            : PollingScreen(
                titleLines: const ["Disbursement in progress"],
                bodyTexts: const [
                  "Thank you for completing these steps! We are processing the transfer of your loan amount. We will notify you once done."
                ],
                widgetBelowIllustration: const SizedBox(
                  height: 10,
                ),
                assetImagePath: Res.sblDisbursalProgressSVG,
                showBottomInfoText: false,
                onClosePressed: logic.onClosePressed,
                isV2: true,
              );
      },
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
