import 'dart:convert';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import '../../../../res.dart';
import '../../../common_widgets/success_screen.dart';
import '../../polling/polling_screen.dart';
import '../../../common_widgets/failure_page.dart';
import 'aa_stand_alone_logic.dart';
import 'aa_stand_alone_initiation_screen.dart';

class AAStandAloneScreenView extends StatefulWidget {
  const AAStandAloneScreenView({super.key});

  @override
  State<AAStandAloneScreenView> createState() => _AAStandAloneScreenViewState();
}

class _AAStandAloneScreenViewState extends State<AAStandAloneScreenView>
    with AfterLayoutMixin {
  final logic = Get.find<AAStandAloneLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GetBuilder<AAStandAloneLogic>(
        builder: (logic) {
          switch (logic.aaBankState) {
            case AABankPageState.loading:
              return _loadingWidget();
            case AABankPageState.bankAccountConsent:
              return AAStandAloneInitiationScreen(
                aaStandAloneBankReport: logic.aaStandAloneBankReport,
              );
            case AABankPageState.polling:
              return _pollingScreen();
            case AABankPageState.webView:
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
                  )
              );
            case AABankPageState.success:
              return const SuccessScreen(
                title: "Your details are verified",
                subTitle:
                    "Your information has been securely verified, and your loan journey is on track",
                img: Res.aaBankSuccess,
              );
            case AABankPageState.failure:
              return _failureScreen();
          }
        },
      ),
    );
  }

  Widget _failureScreen() {
    return WillPopScope(
      onWillPop: () async => logic.onCloseButtonClicked(screenName: "aa_failure"),
      child: FailurePage(
        title: "Something went wrong!",
        message:
            "Looks like there was an issue fetching your details. Please try again",
        illustration: Res.aaFailure,
        ctaTitle: "Try Again",
        onCtaClicked: () {
          logic.aaBankState = AABankPageState.loading;
          logic.onTryAgainClicked();
        },
        isSkip: logic.retryCount >= 2 ? true : false,
        onSkipClicked: () {
          logic.onSkipClickedEvent();
        },
          onBackClicked: () {
            logic.onTryAgainClicked();
            logic.logCrossButtonClicked(screenName: "aa_failure");
          }),
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _pollingScreen() {
    return WillPopScope(
      onWillPop: () async => logic.onCloseButtonClicked(screenName: "aa_polling"),
      child: PollingScreen(
        onClosePressed: () {
          logic.onCloseButtonClicked(screenName: "aa_polling");
        },
        enableTitleSpacer: false,
        enableHelpIcon: false,
        bodyTexts: const [
          'We’re securely fetching the required details to move your loan forward'
        ],
        titleLines: const ['We’re processing your details'],
        isV2: true,
        progressIndicatorText: "It usually takes less than a minute to complete",
        assetImagePath: Res.offer_polling,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}
