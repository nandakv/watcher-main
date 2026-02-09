import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/common_ui_low_and_glow/upgrade_offer.dart';
import 'package:privo/app/common_widgets/gradient_button.dart';
import 'package:privo/app/common_widgets/onboarding_step_of_widget.dart';
import 'package:privo/app/common_widgets/spacer_widgets.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/widgets/add_bank_card_widget.dart';
import 'package:privo/app/modules/on_boarding/widgets/offer_upgrade_bank_selection/widgets/bank_added_card_widget.dart';
import 'package:privo/app/common_widgets/failure_page.dart';
import 'package:privo/app/modules/polling/polling_screen.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/res.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import 'offer_upgrade_bank_selection_logic.dart';
import 'widgets/bank_statement_method_selection_widget.dart';
import 'widgets/upgrade_offer_info_page.dart';

class OfferUpgradeBankSelectionView extends StatefulWidget {
  const OfferUpgradeBankSelectionView({
    Key? key,
  }) : super(key: key);

  @override
  State<OfferUpgradeBankSelectionView> createState() =>
      _OfferUpgradeBankSelectionViewState();
}

class _OfferUpgradeBankSelectionViewState
    extends State<OfferUpgradeBankSelectionView> with AfterLayoutMixin {
  final logic = Get.put(OfferUpgradeBankSelectionLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      builder: (logic) {
        switch (logic.offerUpgradePageState) {
          case OfferUpgradePageState.loading:
            return _loadingWidget();
          case OfferUpgradePageState.bankList:
            return _bankListWidget(context);
          case OfferUpgradePageState.polling:
            return _pollingWidget();
          case OfferUpgradePageState.webView:
            return WillPopScope(
              onWillPop: () async => logic.onWebViewBackPressed(),
              child: _computeWebView(logic, context),
            );
          case OfferUpgradePageState.failure:
            return _failureScreen();
        }
      },
    );
  }

  Widget _failureScreen() {
    return FailurePage(
      title: logic.bankReportPollingModel.failureTitle,
      message: logic.bankReportPollingModel.failureMessage,
      illustration: Res.aaFailure,
      ctaTitle: "Try Again",
      onCtaClicked: logic.onFailureCtaPressed,
    );
  }

  Widget _loadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _pollingWidget() {
    return PollingScreen(
      titleLines: const ["Hold Tight !"],
      bodyTexts: const ["We are evaluating your bank details"],
      isV2: true,
      assetImagePath: Res.evaluatingBankDetailsImgSvg,
      onClosePressed: logic.onPollingClosePressed,
      stopPollingCallback: logic.stopPolling,
      startPollingCallback: logic.startPolling,
    );
  }

  Widget _bankListWidget(BuildContext context) {
    return GetBuilder<OfferUpgradeBankSelectionLogic>(
      builder: (logic) {
        return logic.showUpgradeOfferInfoScreen
            ? UpgradeOfferInfoPage()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const OnboardingStepOfWidget(
                              // currentStep: "3",
                              // totalStep: "3",
                              // appState: "30",
                              title: "Bank Details",
                              subTitle: "Provide Bank Statements",
                            ),
                            _chooseBankWidget(),
                          ],
                        ),
                      ),
                    ),
                    _computeGradientButton()
                  ],
                ),
              );
      },
    );
  }

  Widget _computeGradientButton() {
    if (logic.isCLP && logic.bankReportModel.bankList.isNotEmpty) {
      return _continueButton();
    }
    switch (logic.sbdAddedBankState) {
      case SBDAddedBankState.zeroBankAdded:
        return const SizedBox.shrink();
      case SBDAddedBankState.oneBankAdded:
      case SBDAddedBankState.twoBanksAdded:
      case SBDAddedBankState.threeBanksAdded:
        return _continueButton();
    }
  }

  Column _continueButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GetBuilder<OfferUpgradeBankSelectionLogic>(
            id: logic.CONTINUE_BUTTON_ID,
            builder: (logic) {
              return GradientButton(
                onPressed: logic.onContinuePressed,
                isLoading: logic.isButtonLoading,
              );
            }),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _chooseBankWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        _rbiText(),
        const SizedBox(
          height: 24,
        ),
        _computeSBDBanksWidget(),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _computeSBDBanksWidget() {
    if (logic.isCLP) {
      return _computeCLPBankListWidget();
    }
    switch (logic.sbdAddedBankState) {
      case SBDAddedBankState.zeroBankAdded:
        return _sbdZeroBankAddedWidget();
      case SBDAddedBankState.oneBankAdded:
        return _sbdOneBankAddedWidget();
      case SBDAddedBankState.twoBanksAdded:
        return _sbdTwoBanksAdded();
      case SBDAddedBankState.threeBanksAdded:
        return _sbdThreeBanksAdded();
    }
  }

  Widget _computeCLPBankListWidget() {
    if (logic.bankReportModel.bankList.isNotEmpty) {
      return BankAddedCardWidget(
        bankDetail: logic.bankReportModel.bankList.first,
      );
    }
    return AddBankCardWidget(
      addBankCardType: AddBankCardType.primary,
      onTap: () => logic.onTapAddBank('primary'),
      isCLP: true,
    );
  }

  Widget _sbdZeroBankAddedWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddBankCardWidget(
          addBankCardType: AddBankCardType.primary,
          onTap: () => logic.onTapAddBank('primary'),
        ),
        const SizedBox(
          height: 16,
        ),
        AddBankCardWidget(
          addBankCardType: AddBankCardType.recommendedDisabled,
          onTap: () {},
        ),
        const SizedBox(
          height: 20,
        ),
        _addMoreBanksTextButton(false),
      ],
    );
  }

  Center _addMoreBanksTextButton(bool enabled) {
    return Center(
      child: TextButton(
        onPressed: enabled
            ? () => logic.onTapAddBank(
                  '',
                  isTertiary: true,
                )
            : null,
        child: Text(
          "Add More Banks",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: enabled ? darkBlueColor : lightGrayColor,
          ),
        ),
      ),
    );
  }

  Widget _sbdOneBankAddedWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BankAddedCardWidget(bankDetail: logic.bankReportModel.bankList.first),
        const SizedBox(
          height: 16,
        ),
        AddBankCardWidget(
          addBankCardType: AddBankCardType.recommendedEnabled,
          onTap: () {
            if (logic.isButtonLoading) return null;
            return logic.onTapAddBank('secondary');
          },
        ),
        const SizedBox(
          height: 20,
        ),
        _addMoreBanksTextButton(false),
      ],
    );
  }

  Widget _sbdTwoBanksAdded() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BankAddedCardWidget(bankDetail: logic.bankReportModel.bankList.first),
        const SizedBox(
          height: 16,
        ),
        BankAddedCardWidget(bankDetail: logic.bankReportModel.bankList[1]),
        const SizedBox(
          height: 10,
        ),
        GetBuilder<OfferUpgradeBankSelectionLogic>(
          id: logic.CONTINUE_BUTTON_ID,
          builder: (logic) {
            return _addMoreBanksTextButton(!logic.isButtonLoading);
          },
        ),
      ],
    );
  }

  Widget _sbdThreeBanksAdded() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return BankAddedCardWidget(
          bankDetail: logic.bankReportModel.bankList[index],
        );
      },
      separatorBuilder: (context, index) => const VerticalSpacer(16),
      itemCount: logic.bankReportModel.bankList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget _computeWebView(
      OfferUpgradeBankSelectionLogic logic, BuildContext context) {
    switch (logic.selectedBankStatementUploadOption) {
      case BankStatementUploadOption.aa:
      case BankStatementUploadOption.netBanking:
        return WebViewWidget(controller: logic.webviewControllerPlus);
      case BankStatementUploadOption.uploadPDF:
        return InAppWebView(
          onWebViewCreated: logic.onInAppWebViewCreated,
          shouldOverrideUrlLoading: logic.onUploadPDFCallbackTriggered,
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            allowFileAccess: true,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
          ),
        );
    }
  }

  Row _rbiText() {
    return Row(
      children: [
        SvgPicture.asset(Res.green_shield_svg),
        const SizedBox(
          width: 10,
        ),
        const Flexible(
          child: Text(
            "Your data is 100% safe and encrypted",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: darkBlueColor,
                fontSize: 10,
                letterSpacing: 0.16,
                fontFamily: 'Figtree'),
          ),
        )
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    logic.onAfterLayout();
  }
}

class NoBanksFoundWidget extends StatelessWidget {
  const NoBanksFoundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.close,
                color: navyBlueColor,
                size: 18,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "At the moment we are servicing limited banks, will notify you once extend our services to your bank.",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: darkBlueColor,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
