import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/e_mandate_logic.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/widgets/emandate_failure_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate/widgets/mandate_details_widget.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'widgets/jus_pay_mandate_type_selection_widget.dart';

class SetUpEMandateWidget extends StatefulWidget {
  const SetUpEMandateWidget({Key? key}) : super(key: key);

  @override
  State<SetUpEMandateWidget> createState() => _SetUpEMandateWidgetState();
}

class _SetUpEMandateWidgetState extends State<SetUpEMandateWidget>
    with AfterLayoutMixin {
  final logic = Get.find<EMandateLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: logic.onWebViewBackPressed,
      child: GetBuilder<EMandateLogic>(
        id: logic.BODY_KEY,
        builder: (logic) {
          switch (logic.eMandateState) {
            case EMandateState.loading:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case EMandateState.idle:
              return MandateDetailsWidget();
            case EMandateState.jusPay:
              return JusPayMandateTypeSelectionWidget(
                jusPayMandateCombination: logic.jusPayMandateCombination,
              );
            case EMandateState.jusPayWebView:
              return WebViewWidget(controller: logic.webViewControllerPlus);
            case EMandateState.razorPay:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case EMandateState.error:
              return EmandateFailureWidget();
          }
        },
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
