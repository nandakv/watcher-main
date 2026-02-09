import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/bottom_sheet_widget.dart';
import 'package:privo/app/common_widgets/log_out_dialog.dart';
import 'package:privo/app/data/provider/auth_provider.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/on_boarding/mixins/app_form_mixin.dart';
import 'package:privo/app/routes/app_pages.dart';
import 'package:privo/app/services/lpc_service.dart';
import 'package:privo/app/theme/app_colors.dart';
import 'package:privo/app/utils/multi_lpc_faq.dart';
import 'package:privo/app/utils/web_engage_constant.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../common_widgets/bottom_sheet_radio_button/bottom_sheet_radio_button_widget.dart';
import '../../common_widgets/gradient_button.dart';

enum DrawerScreen { homeScreen, myAccount, helpAndSupport }

class NavigationDrawerLogic extends GetxController {
  int HOME_SCREEN_INDEX = 1;
  int MY_ACCOUNT_INDEX = 2;
  int KNOWLEDGE_BASE_INDEX = 3;
  int HELP_SUPPORT_INDEX = 4;
  int REFER_A_FRIEND_INDEX = 5;

  String? lpc;

  late final String REFER_A_FRIEND_ID = "REFER_A_FRIEND_ID";

  onHomePressed(int currentIndex) {
    if (currentIndex == HOME_SCREEN_INDEX) {
      _closeDrawer();
    } else {
      currentIndex = HOME_SCREEN_INDEX;
      Get.offAllNamed(
        Routes.HOME_SCREEN,
      );
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.hamburgerMenuOpened,
          attributeName: {"home": true});
    }
  }

  void _closeDrawer() {
    Get.back();
  }

  onMyAccountPressed(int currentIndex) {
    if (currentIndex == MY_ACCOUNT_INDEX) {
      _closeDrawer();
    } else {
      currentIndex = 2;
      Get.offNamed(Routes.PROFILE_SCREEN);
    }
  }

  Future<bool> shouldEnableReferral()async{
    return await AppAuthProvider.showReferral;
  }

  onHelpAndSupportPressed(int currentIndex) async {
    lpc ??= await AppAuthProvider.getLpc;
    if (currentIndex == HELP_SUPPORT_INDEX) {
      _closeDrawer();
    } else {
      currentIndex = 3;
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.getHelpClicked,
          attributeName: {"home_page": true});
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.hamburgerMenuOpened,
          attributeName: {"help_and_support": true});

      _closeDrawer();

      MultiLPCFaq().openMultiLPCBottomSheet(
          onPressContinue: () {}, isFromHomePage: true);
    }
  }

  onKnowledgeBasePressed(int currentIndex) {
    if (currentIndex == KNOWLEDGE_BASE_INDEX) {
      _closeDrawer();
    } else {
      currentIndex = 4;
      Get.offNamed(Routes.KNOWLEDGE_BASE);
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.hamburgerMenuOpened,
          attributeName: {"knowledge_base": true});
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.knowledgeBaseClicked);
    }
  }

  void onReferaFriendPressed(int currentIndex) {
    if (currentIndex == REFER_A_FRIEND_INDEX) {
      _closeDrawer();
    } else {
      currentIndex = 4;
      Get.offNamed(Routes.REFERRAL, arguments: {'fromHomePage': true});
    }
  }

  onTermsOfUseClicked() {
    launchUrlString(
      "https://regulatory.creditsaison.in/terms-conditions",
      mode: LaunchMode.externalApplication,
    );
    AppAnalytics.trackWebEngageEventWithAttribute(
      eventName: WebEngageConstants.hamburgerTermsOfUse,
    );
  }

  void onLogoutPressed() async {
    var result = await Get.bottomSheet(
      const BottomSheetWidget(
        enableCloseIconButton: true,
        child: LogOutDialog(),
      ),
    );
    if (result != null && result) {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.appLoggedOut,
          attributeName: {"logged_out": true});
      _closeDrawer();
      await AppAuthProvider.logout();
    } else {
      AppAnalytics.trackWebEngageEventWithAttribute(
          eventName: WebEngageConstants.appLoggedOut,
          attributeName: {"stay": true});
    }
  }
}
