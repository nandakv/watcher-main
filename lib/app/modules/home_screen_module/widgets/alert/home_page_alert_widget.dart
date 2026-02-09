import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:privo/app/common_widgets/shimmer_loading/skeleton_loading_widget.dart';
import 'package:privo/app/firebase/analytics.dart';
import 'package:privo/app/models/home_screen_model.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_card/home_screen_card.dart';
import 'package:privo/app/modules/home_screen_module/home_screen_interface.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/widgets/advance_emi_alert_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/widgets/low_and_grow_alert_widget.dart';
import 'package:privo/app/modules/home_screen_module/widgets/alert/widgets/overdue_alert_widget.dart';
import 'package:privo/app/services/lpc_service.dart';
import '../../../../models/home_screen_card_model.dart';
import '../../../../utils/app_functions.dart';
import '../../../../utils/web_engage_constant.dart';
import '../../home_screen_logic.dart';
import 'home_page_alert_widget_logic.dart';
import 'widgets/credit_line_expiry_alert.dart';

class HomePageWithdrawalAlert extends StatefulWidget {
  HomePageWithdrawalAlert({
    Key? key,
    this.withdrawalDetailsHomeScreenType,
    required this.lpcCard,
  }) : super(key: key);

  final LpcCard lpcCard;
  final WithdrawalDetailsHomeScreenType? withdrawalDetailsHomeScreenType;
  late HomeScreenInterface homeScreenInterface;

  @override
  State<HomePageWithdrawalAlert> createState() =>
      _HomePageWithdrawalAlertState();
}

class _HomePageWithdrawalAlertState extends State<HomePageWithdrawalAlert>
    with AfterLayoutMixin {
  final homeScreenLogic = Get.find<HomeScreenLogic>();

  HomePageWithdrawalAlertLogic get logic =>
      Get.put(HomePageWithdrawalAlertLogic(), tag: widget.lpcCard.appFormId);

  @override
  Widget build(BuildContext context) {
    if (widget.withdrawalDetailsHomeScreenType?.clExpiryDays != null) {
      return CreditLineExpiryAlert(
        withdrawalDetailsHomeScreenType: widget.withdrawalDetailsHomeScreenType,
        lpcCard: widget.lpcCard,
      );
    }
    return _computeOtherAlerts(); // low and grow, overdue, advance emi
  }

  Widget _computeOtherAlerts() {
    return GetBuilder<HomePageWithdrawalAlertLogic>(
      tag: widget.lpcCard.appFormId,
      builder: (logic) {
        switch (logic.withdrawalDetailState) {
          case WithdrawalDetailState.loading:
            return const SkeletonLoadingWidget(
              skeletonLoadingType: SkeletonLoadingType.primaryHomeScreenCard,
            );
          case WithdrawalDetailState.error:
            return _onError();
          case WithdrawalDetailState.success:
            _computeAlertCard();
            return SizedBox();
        }
      },
    );
  }

  SizedBox _onError() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logic.homeScreenInterface.showHomePageAlert([]);
    });
    return SizedBox();
  }

  Widget _overdueWidget() {
    return OverdueAlertWidget(
      refIDText: logic.computeOverdueAlertTitle(),
      ctaTitle: logic.computeOverdueCTAText(),
      onKnowMore: logic.onOverdueKnowMore(),
      nudgeTitle: logic.computeOverdueNudgeText(),
      infoText: logic.computeOverdueInfoText(),
      lpcCard: widget.lpcCard,
      onPay: logic.onOverDuePayClicked,
    );
  }

  Widget _advanceEMIWidget() {
    return AdvanceEMIAlertWidget(
      onKnowMore: logic.onPressAdvanceEMIKnowMore,
      onPayNow: logic.onPressPayAdvanceEMIButton,
      loanInfoText: logic.computeAdvanceLoanInfoText(),
    );
  }

  _computeAlertCard() {
    List<Widget> alerts = [];
    for (var element in logic.homePageCard) {
      switch (element) {
        case HomePageCard.overdue:
          logic.primaryHomeScreenLogic.cardBadgeType = CardBadgeType.overdue;
          alerts.add(_overdueWidget());
          break;
        case HomePageCard.advanceEMI:
          alerts.add(_advanceEMIWidget());
          break;
        case HomePageCard.none:
          break;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logic.homeScreenInterface.showHomePageAlert(alerts);
    });
    return alerts;
  }

  @override
  void initState() {
    logic.onAfterFirstLayout(
      widget.withdrawalDetailsHomeScreenType,
      widget.lpcCard,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {}
}
