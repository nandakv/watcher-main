import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/modules/on_boarding/widgets/e_mandate_polling/widgets/emandate_polling_widget.dart';
import 'package:privo/app/modules/polling/gradient_circular_progress_indicator.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../../../../res.dart';
import '../../../../common_widgets/success_screen.dart';
import 'e_mandate_polling_logic.dart';
import 'widgets/emandate_polling_failure_screen.dart';

class EMandatePollingPage extends StatefulWidget {
  EMandatePollingPage({Key? key}) : super(key: key);

  @override
  State<EMandatePollingPage> createState() => _EMandatePollingPageState();
}

class _EMandatePollingPageState extends State<EMandatePollingPage>
    with AfterLayoutMixin {
  final logic = Get.find<EMandatePollingLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EMandatePollingLogic>(
      builder: (logic) {
        switch (logic.eMandatePollingState) {
          case EMandatePollingState.polling:
            return EMandatePollingWidget();
          case EMandatePollingState.success:
            return const SuccessScreen(
              title: "Auto-Pay Activated!",
              subTitle:
                  "Your future payments will be made automatically\non the due date",
              img: Res.autoPaySuccessSVG,
            );
          case EMandatePollingState.error:
            return EmandateFailureScreen();
        }
      },
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
