import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/models/arguments_model/faq_help_support_arguments.dart';
import '../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../common_widgets/gradient_button.dart';
import '../models/home_screen_model.dart';
import '../routes/app_pages.dart';
import '../services/lpc_service.dart';
import '../theme/app_colors.dart';

class MultiLPCFaq {
  final LpcCard? lpcCard;

  MultiLPCFaq({this.lpcCard});

  Future openMultiLPCBottomSheet(
      {required Function onPressContinue, bool isFromHomePage = false}) async {
    final FaqHelpAndSupportNavigationService faqNavigationService =
        FaqHelpAndSupportNavigationService();
    if (this.lpcCard != null) {
      await faqNavigationService.navigate(
        routeArguments: FAQHelpSupportArguments(
          isFromSupportMenu: false,
          isFromHomePage: isFromHomePage,
          lpcCard: this.lpcCard!,
        ),
      );
      return;
    }

    if (LPCService.instance.lpcCards.length == 1) {
      await faqNavigationService.navigate(
        routeArguments: FAQHelpSupportArguments(
          isFromSupportMenu: true,
          isFromHomePage: isFromHomePage,
          lpcCard: LPCService.instance.lpcCards.first,
        ),
      );
      return;
    }

    var result = await Get.bottomSheet(
      BottomSheetRadioButtonWidget(
        title: 'Select a loan you need help with',
        titleTextStyle: const TextStyle(
          color: darkBlueColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        radioValues:
            LPCService.instance.lpcCards.map((e) => e.loanProductName).toList()
              ..add("Other"),
        ctaButtonsBuilder: (radioLogic) {
          return [
            GradientButton(
              onPressed: () {
                Get.back(result: radioLogic.selectedGroupValue);
              },
            ),
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ];
        },
      ),
      isDismissible: false,
    );

    LpcCard? lpcCard;

    if (result != null) {
      if (result == "Other") {
        await Get.toNamed(Routes.HELP_AND_SUPPORT);
        return;
      }
      try {
        lpcCard = LPCService.instance.lpcCards.singleWhere(
          (element) => element.loanProductName == result,
        );
        onPressContinue();
        await faqNavigationService.navigate(
          routeArguments: FAQHelpSupportArguments(
            isFromSupportMenu: true,
            isFromHomePage: isFromHomePage,
            lpcCard: lpcCard,
          ),
        );
        return;
      } on Exception catch (e) {
        await Get.offNamed(Routes.HELP_AND_SUPPORT);
        return;
      }
    }
  }
}
