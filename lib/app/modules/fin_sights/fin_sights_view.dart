import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/shimmer_loading/finsights_shimmer_loading_widget.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/modules/fin_sights/finsight_wait_screen.dart';
import 'package:privo/app/modules/fin_sights/widgets/fin_sights_intro_screen.dart';
import 'package:privo/app/modules/fin_sights/widgets/finsights_failure_bottom_sheet.dart';
import 'package:privo/app/modules/fin_sights/widgets/mobile_screen_flow/mobile_input_screen.dart';
import 'package:privo/app/modules/fin_sights/widgets/new_intro/new_intro_screen.dart';
import 'package:privo/app/modules/know_more_and_get_started/widgets/know_more_widget.dart';
import 'package:privo/app/common_widgets/failure_page.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/res.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'fin_sights_logic.dart';
import 'widgets/bank_selection_widget/bank_selection_widget.dart';
import 'widgets/finsights_dashboard_screen.dart';

class FinSightsPage extends StatefulWidget {
  FinSightsPage({Key? key}) : super(key: key);

  @override
  State<FinSightsPage> createState() => _FinSightsPageState();
}

class _FinSightsPageState extends State<FinSightsPage> with AfterLayoutMixin {
  final logic = Get.find<FinSightsLogic>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: logic.onPopped,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: GetBuilder<FinSightsLogic>(
            builder: (logic) {
              switch (logic.finSightState) {
                case FinSightState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case FinSightState.introScreen:
                  return FinSightsIntroScreen();
                case FinSightState.knowMore:
                  return KnowMoreWidget(
                    knowMoreHelper: logic,
                  );
                case FinSightState.bankDetails:
                  return GetBuilder<FinSightsLogic>(
                    id: logic.BANK_DETAILS_WIDGET_KEY,
                    builder: (logic) {
                      return FinsightsBankSelectionWidget(
                        onContinueTapped: logic.openMobileNumberBottomSheet,
                        isCTALoading: logic.initiatingWebview,
                        onBankSelected: logic.onBankSelected,
                      );
                    },
                  );
                case FinSightState.dashboardLoading:
                  return const FinSightsShimmerLoadingWidget();
                case FinSightState.dashboard:
                  return FinsightsDashboardScreen();
                case FinSightState.aaWebView:
                  return SafeArea(child: _aaWebView(logic));
                case FinSightState.polling:
                  return PopScope(
                    canPop: false,
                    child: SafeArea(
                      child: PollingScreen(
                        onClosePressed: () {
                          logic.onPollingBackPress();
                        },
                        enableTitleSpacer: false,
                        enableHelpIcon: false,
                        bodyTexts: const [
                          'We’re processing your bank details to provide impactful insights'
                        ],
                        titleLines: const ['Crafting Insights Just for You'],
                        isV2: true,
                        progressIndicatorText:
                        "Almost done! This won’t take more than a minute",
                        assetImagePath: Res.eMandatePollingSVG,
                      ),
                    ),
                  );
                case FinSightState.pollingFailure:
                  return FailurePage(
                    title: "Something went wrong!",
                    message:
                        "Looks like there was an issue fetching your details. Please try again",
                    illustration: Res.aaFailure,
                    ctaTitle: "Try Again",
                    onCtaClicked: logic.onFailureRetryClicked,
                    enableContactCTA: true,
                    showV2ContactDetails: true,
                  );
                case FinSightState.newIntroScreen:
                  return NewIntroScreen();
                case FinSightState.mobileInputScreen:
                  return const MobileInputScreen();
                case FinSightState.waitScreen:
                  return SafeArea(
                    child: FinsightsWaitScreen(
                      onClosePressed: () {
                        logic.finSightsBackClicked("Finsights Polling screen");
                      },
                    ),
                  );
              }
            },
          ),
        ));
  }

  WillPopScope _aaWebView(FinSightsLogic logic) {
    return WillPopScope(
        onWillPop: () async => logic.onWebViewBackPressed(),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(logic.responseURL)),
          onWebViewCreated: (controller) {
            controller.addJavaScriptHandler(
              handlerName: 'messageEventListener',
              callback: (args) {
                logic.eventListenerCallBack(args);
              },
            );
          },
        ));
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
